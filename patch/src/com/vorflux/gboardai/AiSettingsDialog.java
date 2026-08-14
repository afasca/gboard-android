package com.vorflux.gboardai;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.text.InputType;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;
import java.util.List;

public final class AiSettingsDialog {
    private AiSettingsDialog() {}

    public static void show(final Context context) {
        final int pad = Math.round(20 * context.getResources().getDisplayMetrics().density);
        LinearLayout root = new LinearLayout(context);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setPadding(pad, pad / 2, pad, 0);
        TextView notice = new TextView(context);
        notice.setText("文本会发送到您配置的 OpenAI 兼容服务。API Key 由 Android Keystore 加密并仅保存在本机。\n\n" + modeSummary(context));
        root.addView(notice);
        final EditText base = new EditText(context);
        base.setHint("API Base URL");
        base.setSingleLine(true);
        base.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_URI);
        base.setText(AiConfig.getStoredBaseUrl(context));
        root.addView(base);
        final EditText key = new EditText(context);
        key.setHint("API Key（留空表示不修改）");
        key.setSingleLine(true);
        key.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
        root.addView(key);
        AlertDialog dialog = new AlertDialog.Builder(context)
                .setTitle("MyBoard AI · OpenAI 兼容设置")
                .setView(root)
                .setNegativeButton(android.R.string.cancel, null)
                .setNeutralButton("清除 Key", null)
                .setPositiveButton("保存并选择模型", null)
                .create();
        dialog.setOnShowListener(new DialogInterface.OnShowListener() {
            @Override public void onShow(final DialogInterface raw) {
                final AlertDialog shown = (AlertDialog) raw;
                shown.getButton(DialogInterface.BUTTON_NEUTRAL).setOnClickListener(new View.OnClickListener() {
                    @Override public void onClick(View v) {
                        AiConfig.setApiKey(context, ""); key.setText("");
                        Toast.makeText(context, "API Key 已清除", Toast.LENGTH_SHORT).show();
                    }
                });
                shown.getButton(DialogInterface.BUTTON_POSITIVE).setOnClickListener(new View.OnClickListener() {
                    @Override public void onClick(View v) {
                        if (!saveConnection(context, base, key)) return;
                        final String apiKey = AiConfig.getApiKey(context);
                        if (apiKey.length() == 0) { key.setError("请填写 API Key"); return; }
                        shown.getButton(DialogInterface.BUTTON_POSITIVE).setEnabled(false);
                        shown.getButton(DialogInterface.BUTTON_POSITIVE).setText("正在获取模型…");
                        new Thread(new Runnable() {
                            @Override public void run() {
                                List<String> models = null; String error = null;
                                try { models = OpenAiClient.listModels(context, apiKey); }
                                catch (Exception e) { error = e.getMessage(); }
                                final List<String> available = models; final String problem = error;
                                shown.getWindow().getDecorView().post(new Runnable() {
                                    @Override public void run() {
                                        shown.getButton(DialogInterface.BUTTON_POSITIVE).setEnabled(true);
                                        shown.getButton(DialogInterface.BUTTON_POSITIVE).setText("保存并选择模型");
                                        if (problem != null) {
                                            new AlertDialog.Builder(context).setTitle("模型获取失败").setMessage(problem).setPositiveButton(android.R.string.ok, null).show();
                                            return;
                                        }
                                        showModelPicker(context, shown, available);
                                    }
                                });
                            }
                        }, "GboardAI-models").start();
                    }
                });
            }
        });
        dialog.show();
    }

    private static boolean saveConnection(Context context, EditText base, EditText key) {
        String keyValue = key.length() > 0 ? key.getText().toString() : null;
        if (!AiConfig.setBaseUrl(context, base.getText().toString())) {
            base.setError("请输入有效的 HTTPS API 地址");
            return false;
        }
        if (keyValue != null) AiConfig.setApiKey(context, keyValue);
        return true;
    }

    private static void showModelPicker(final Context context, final AlertDialog settings, final List<String> models) {
        final CharSequence[] choices = new CharSequence[models.size() + 1];
        choices[0] = "自动选择（推荐）";
        int checked = AiConfig.isManualModel(context) ? -1 : 0;
        String manual = AiConfig.getManualModel(context);
        for (int i = 0; i < models.size(); i++) {
            choices[i + 1] = models.get(i);
            if (models.get(i).equals(manual)) checked = i + 1;
        }
        String warning = checked < 0 ? "\n\n当前手动模型不在服务返回的列表中。选择其他模型或自动模式后才会更改。" : "";
        new AlertDialog.Builder(context)
                .setTitle("选择模型")
                .setMessage("按适用性排序；自动模式会使用首选模型，并在模型失效时重新发现。" + warning)
                .setSingleChoiceItems(choices, checked, new DialogInterface.OnClickListener() {
                    @Override public void onClick(DialogInterface picker, int which) {
                        if (which == 0) {
                            AiConfig.setManualModel(context, "");
                            AiConfig.setCachedModel(context, models.get(0));
                            Toast.makeText(context, "已切换为自动模式：" + models.get(0), Toast.LENGTH_LONG).show();
                        } else {
                            String selected = models.get(which - 1);
                            AiConfig.setManualModel(context, selected);
                            Toast.makeText(context, "已手动选择模型：" + selected, Toast.LENGTH_LONG).show();
                        }
                        picker.dismiss();
                        settings.dismiss();
                    }
                })
                .setNegativeButton(android.R.string.cancel, null)
                .show();
    }

    private static String modeSummary(Context context) {
        String manual = AiConfig.getManualModel(context);
        if (manual.length() > 0) return "当前模式：手动\n当前模型：" + manual;
        return "当前模式：自动\n当前模型：" + valueOrNone(AiConfig.getCachedModel(context));
    }

    private static String valueOrNone(String value) { return value == null || value.length() == 0 ? "尚未自动获取" : value; }
}
