package com.example.quash_assignment;
import android.app.Activity;
import android.graphics.Bitmap;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.view.Window;

import androidx.annotation.NonNull;

import java.io.ByteArrayOutputStream;
import java.util.Timer;
import java.util.TimerTask;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** QuashAssignmentPlugin */
public class QuashAssignmentPlugin implements FlutterPlugin, MethodCallHandler {
    private MethodChannel channel;
    private Activity activity;
    private final Handler handler = new Handler(Looper.getMainLooper());
    private Timer timer;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "quash_assignment");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("startScreenshotCapture")) {

            startScreenshotCapture();
            result.success(null);
        } else if (call.method.equals("stopScreenshotCapture")) {
            stopScreenshotCapture();
            result.success(null);
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    public void setActivity(Activity activity) {
        this.activity = activity;
    }

    private void startScreenshotCapture() {
        if (timer == null) {
            timer = new Timer();
            timer.schedule(new TimerTask() {
                

                // @Override
                public void run() {
                

                    captureScreenshot();
                }
            }, 0, 100);
        }
    }

    private void stopScreenshotCapture() {
        if (timer != null) {
            timer.cancel();
            timer = null;
        }
    }

    private void captureScreenshot() {
        handler.post(() -> {
        
        if (activity != null) {
            

            Window window = activity.getWindow();
            

            if (window != null) {
            

                View rootView = window.getDecorView().getRootView();
                rootView.setDrawingCacheEnabled(true);
                Bitmap bitmap = Bitmap.createBitmap(rootView.getDrawingCache());
                rootView.setDrawingCacheEnabled(false);

                ByteArrayOutputStream stream = new ByteArrayOutputStream();
                bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream);
                byte[] byteArray = stream.toByteArray();

                channel.invokeMethod("onScreenshot", byteArray);
            }
        }
        });

    }
}
