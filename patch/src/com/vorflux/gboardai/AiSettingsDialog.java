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

public final class AiSettingsDialog {
    private AiSettingsDialog() {}

    public static void show(final Context context) {
        final int pad = Math.round(20 * context.getResources().getDisplayMetrics().density);
        LinearLayout root = new LinearLayout(context);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setPadding(pad, pad / 2, pad, 0);
        TextView notice = new TextView(context);
        notice.setText("文本会发送到您配置的 OpenAI 兼容服务。模型通过 /v1/models 自动获取；API Key 由 Android Keystore 加密并仅保存在本机。\n\n现有 AI 模型：" + valueOrNone(AiConfig.getCachedModel(context)));
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
                .setTitle("Gboard AI · OpenAI 兼容设置")
                .setView(root)
                .setNegativeButton(android.R.string.cancel, null)
                .setNeutralButton("清除 Key", null)
                .setPositiveButton("保存并获取模型", null)
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
                        if (!AiConfig.setBaseUrl(context, base.getText().toString())) {
                            base.setError("请输入有效的 HTTPS API 地址");
                            return;
                        }
                        if (key.length() > 0) AiConfig.setApiKey(context, key.getText().toString());
                        final String apiKey = AiConfig.getApiKey(context);
                        if (apiKey.length() == 0) { key.setError("请填写 API Key"); return; }
                        shown.getButton(DialogInterface.BUTTON_POSITIVE).setEnabled(false);
                        shown.getButton(DialogInterface.BUTTON_POSITIVE).setText("正在获取模型…");
                        new Thread(new Runnable() {
                            @Override public void run() {
                                String model = null; String error = null;
                                try { model = OpenAiClient.discoverModel(context, apiKey); AiConfig.setCachedModel(context, model); }
                                catch (Exception e) { error = e.getMessage(); }
                                final String selected = model; final String problem = error;
                                shown.getWindow().getDecorView().post(new Runnable() {
                                    @Override public void run() {
                                        if (problem == null) {
                                            Toast.makeText(context, "已自动选择模型：" + selected, Toast.LENGTH_LONG).show();
                                            shown.dismiss();
                                        } else {
                                            shown.getButton(DialogInterface.BUTTON_POSITIVE).setEnabled(true);
                                            shown.getButton(DialogInterface.BUTTON_POSITIVE).setText("保存并获取模型");
                                            new AlertDialog.Builder(context).setTitle("模型获取失败").setMessage(problem).setPositiveButton(android.R.string.ok, null).show();
                                        }
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

    private static String valueOrNone(String value) { return value == null || value.length() == 0 ? "未获取" : value; }
}
