package com.upcwangying.apps.flutter.boilerplate;

import android.os.Bundle;
import android.util.Log;

import com.huawei.hms.push.HmsMessageService;

public class FlutterBoilerplatePushService extends HmsMessageService {
    private static final String TAG = "FlutterBoilerplatePushService";

    @Override
    public void onNewToken(String token) {
        super.onNewToken(token);
        Log.i(TAG, "receive token:" + token);
    }

    @Override
    public void onNewToken(String token, Bundle bundle) {
        super.onNewToken(token);
        Log.i(TAG, "receive new token:" + token);
    }
}
