package com.vorflux.gboardai;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Typeface;
import android.text.InputType;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;
import java.util.List;

public final class AiSettingsDialog {
    private static final String[] STYLE_VALUES = {"standard", "concise", "formal", "natural", "professional", "custom"};
    private static final String[] STYLE_LABELS = {"标准润色", "简洁", "正式", "自然/口语", "专业", "自定义"};
    private static final int[] DEBOUNCE_VALUES = {300, 500, 800, 1200, 2000};
    private static final String[] DEBOUNCE_LABELS = {"300 ms", "500 ms", "800 ms（建议）", "1200 ms", "2000 ms"};

    private AiSettingsDialog() {}

    public static void show(final Context context) {
        int pad = Math.round(20 * context.getResources().getDisplayMetrics().density);
        LinearLayout content = new LinearLayout(context);
        content.setOrientation(LinearLayout.VERTICAL);
        content.setPadding(pad, pad / 2, pad, 0);

        TextView intro = text(context, "文本会发送到您配置的 OpenAI 兼容服务。API Key 由 Android Keystore 加密且仅保存在本机。不会记录 API Key、提示词、原文、译文或润色结果。\n\n" + modeSummary(context));
        content.addView(intro);

        final EditText base = input(context, "API Base URL", true, InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_URI);
        base.setText(AiConfig.getStoredBaseUrl(context));
        content.addView(base);

        final EditText key = input(context, "API Key（留空表示不修改）", true, InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
        content.addView(key);

        content.addView(section(context, "翻译"));
        final Spinner debounce = spinner(context, DEBOUNCE_LABELS);
        debounce.setSelection(indexOf(DEBOUNCE_VALUES, AiConfig.getDebounceMs(context)));
        content.addView(labelled(context, "输入停顿时间", debounce));

        final EditText translationPrompt = input(context, "翻译提示词；支持 {source} 和 {target}", false, InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_MULTI_LINE);
        translationPrompt.setMinLines(4);
        translationPrompt.setText(AiConfig.getTranslationPrompt(context));
        content.addView(translationPrompt);
        Button resetTranslation = button(context, "恢复默认翻译提示词");
        resetTranslation.setOnClickListener(v -> translationPrompt.setText(AiConfig.DEFAULT_TRANSLATION_PROMPT));
        content.addView(resetTranslation);

        content.addView(section(context, "AI 润色"));
        TextView polishHelp = text(context, "键盘工具栏中的“AI 润色”可直接打开此功能，并复用原生结果、替换和撤销流程。");
        content.addView(polishHelp);
        final Spinner style = spinner(context, STYLE_LABELS);
        style.setSelection(indexOf(STYLE_VALUES, AiConfig.getPolishStyle(context)));
        content.addView(labelled(context, "默认风格", style));

        final EditText polishPrompt = input(context, "自定义润色提示词", false, InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_MULTI_LINE);
        polishPrompt.setMinLines(4);
        polishPrompt.setText(AiConfig.getPolishPrompt(context));
        content.addView(polishPrompt);
        Button resetPolish = button(context, "恢复默认润色提示词");
        resetPolish.setOnClickListener(v -> polishPrompt.setText(AiConfig.DEFAULT_POLISH_PROMPT));
        content.addView(resetPolish);

        ScrollView scroll = new ScrollView(context);
        scroll.addView(content);

        final AlertDialog dialog = new AlertDialog.Builder(context)
                .setTitle("MyBoard AI · OpenAI 兼容设置")
                .setView(scroll)
                .setNegativeButton(android.R.string.cancel, null)
                .setNeutralButton("清除 Key", null)
                .setPositiveButton("保存并选择模型", null)
                .create();
        dialog.setOnShowListener(ignored -> {
            dialog.getButton(DialogInterface.BUTTON_NEUTRAL).setOnClickListener(v -> {
                AiConfig.setApiKey(context, "");
                key.setText("");
                Toast.makeText(context, "API Key 已清除", Toast.LENGTH_SHORT).show();
            });
            dialog.getButton(DialogInterface.BUTTON_POSITIVE).setOnClickListener(v -> {
                String keyValue = key.length() > 0 ? key.getText().toString() : null;
                if (!save(context, base, keyValue, translationPrompt, debounce, style, polishPrompt)) return;
                Button positive = dialog.getButton(DialogInterface.BUTTON_POSITIVE);
                positive.setEnabled(false);
                positive.setText("正在读取模型…");
                final String apiKey = AiConfig.getApiKey(context);
                if (TextUtils.isEmpty(apiKey)) {
                    positive.setEnabled(true);
                    positive.setText("保存并选择模型");
                    key.setError("请填写 API Key");
                    return;
                }
                new Thread(() -> {
                    List<String> models = null;
                    String error = null;
                    try {
                        models = OpenAiClient.listModels(context, apiKey);
                    } catch (Exception failure) {
                        error = failure.getMessage();
                    }
                    final List<String> available = models;
                    final String problem = error;
                    dialog.getWindow().getDecorView().post(() -> {
                        positive.setEnabled(true);
                        positive.setText("保存并选择模型");
                        if (problem != null) {
                            new AlertDialog.Builder(context).setTitle("模型获取失败").setMessage(problem)
                                    .setPositiveButton(android.R.string.ok, null).show();
                        } else {
                            showModelPicker(context, dialog, available);
                        }
                    });
                }, "GboardAI-models").start();
            });
        });
        dialog.show();
    }

    private static boolean save(Context context, EditText base, String key, EditText translationPrompt,
            Spinner debounce, Spinner style, EditText polishPrompt) {
        if (!AiConfig.setBaseUrl(context, base.getText().toString())) {
            base.setError("请输入有效的 HTTPS API 地址");
            return false;
        }
        if (key != null) AiConfig.setApiKey(context, key);
        AiConfig.setTranslationPrompt(context, translationPrompt.getText().toString());
        AiConfig.setDebounceMs(context, DEBOUNCE_VALUES[debounce.getSelectedItemPosition()]);
        AiConfig.setPolishStyle(context, STYLE_VALUES[style.getSelectedItemPosition()]);
        AiConfig.setPolishPrompt(context, polishPrompt.getText().toString());
        return true;
    }

    private static void showModelPicker(final Context context, final AlertDialog settings, final List<String> models) {
        CharSequence[] choices = new CharSequence[models.size() + 1];
        choices[0] = "自动选择（推荐）";
        int selected = AiConfig.isManualModel(context) ? -1 : 0;
        String manual = AiConfig.getManualModel(context);
        for (int i = 0; i < models.size(); i++) {
            choices[i + 1] = models.get(i);
            if (models.get(i).equals(manual)) selected = i + 1;
        }
        String warning = selected < 0 ? "\n\n当前手动模型不在服务返回的列表中。选择其他模型或自动模式后才会更改。" : "";
        new AlertDialog.Builder(context)
                .setTitle("选择模型")
                .setMessage("按适用性排序；自动模式会使用首选模型，并在模型失效时重新发现。" + warning)
                .setSingleChoiceItems(choices, selected, (dialog, which) -> {
                    if (which == 0) {
                        AiConfig.setManualModel(context, "");
                        AiConfig.setCachedModel(context, models.get(0));
                        Toast.makeText(context, "已切换为自动模式：" + models.get(0), Toast.LENGTH_SHORT).show();
                    } else {
                        String model = models.get(which - 1);
                        AiConfig.setManualModel(context, model);
                        Toast.makeText(context, "已手动选择模型：" + model, Toast.LENGTH_SHORT).show();
                    }
                    dialog.dismiss();
                    settings.dismiss();
                })
                .setNegativeButton(android.R.string.cancel, null)
                .show();
    }

    private static String modeSummary(Context context) {
        String manual = AiConfig.getManualModel(context);
        if (!TextUtils.isEmpty(manual)) return "当前模式：手动\n当前模型：" + manual;
        String cached = AiConfig.getCachedModel(context);
        return "当前模式：自动\n当前模型：" + (TextUtils.isEmpty(cached) ? "尚未发现" : cached);
    }

    private static TextView text(Context context, String value) {
        TextView view = new TextView(context);
        view.setText(value);
        return view;
    }

    private static TextView section(Context context, String value) {
        TextView view = text(context, "\n" + value);
        view.setTypeface(Typeface.DEFAULT, Typeface.BOLD);
        view.setTextSize(17);
        return view;
    }

    private static EditText input(Context context, String hint, boolean singleLine, int type) {
        EditText view = new EditText(context);
        view.setHint(hint);
        view.setSingleLine(singleLine);
        view.setInputType(type);
        return view;
    }

    private static Spinner spinner(Context context, String[] labels) {
        Spinner spinner = new Spinner(context);
        ArrayAdapter<String> adapter = new ArrayAdapter<>(context, android.R.layout.simple_spinner_item, labels);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(adapter);
        return spinner;
    }

    private static View labelled(Context context, String label, View input) {
        LinearLayout row = new LinearLayout(context);
        row.setOrientation(LinearLayout.VERTICAL);
        TextView title = text(context, label);
        row.addView(title);
        row.addView(input, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
        return row;
    }

    private static Button button(Context context, String label) {
        Button button = new Button(context);
        button.setText(label);
        return button;
    }

    private static int indexOf(int[] values, int value) {
        for (int i = 0; i < values.length; i++) if (values[i] == value) return i;
        return 0;
    }

    private static int indexOf(String[] values, String value) {
        for (int i = 0; i < values.length; i++) if (values[i].equals(value)) return i;
        return 0;
    }
}
