package com.pichillilorenzo.flutter_inappbrowser;

import android.util.Log;

import java.lang.reflect.Field;
import java.util.Iterator;
import java.util.Map;
import java.util.HashMap;

public class InAppBrowserOptions {

    boolean useShouldOverrideUrlLoading = false;
    boolean clearCache = false;
    String userAgent = "";
    boolean javaScriptEnabled = true;
    boolean javaScriptCanOpenWindowsAutomatically = false;
    boolean hidden = false;
    boolean toolbarTop = true;
    String toolbarTopBackgroundColor = "";
    String toolbarTopFixedTitle = "";
    boolean hideUrlBar = false;
    boolean mediaPlaybackRequiresUserGesture = true;

    boolean hideTitleBar = false;
    boolean closeOnCannotGoBack = true;
    boolean clearSessionCache = false;
    boolean builtInZoomControls = false;
    boolean supportZoom = true;
    boolean databaseEnabled = false;
    boolean domStorageEnabled = false;
    boolean useWideViewPort = true;
    boolean safeBrowsingEnabled = true;
    boolean progressBar = true;

    public void parse(HashMap<String, Object> options) {
        Iterator it = options.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry<String, Object> pair = (Map.Entry<String, Object>)it.next();
            try {
                this.getClass().getDeclaredField(pair.getKey()).set(this, pair.getValue());
            } catch (NoSuchFieldException e) {
                Log.d("InAppBrowserOptions", e.getMessage());
            } catch (IllegalAccessException  e) {
                Log.d("InAppBrowserOptions", e.getMessage());
            }
        }
    }

    public HashMap<String, Object> getHashMap() {
        HashMap<String, Object> options = new HashMap<>();
        for (Field f: this.getClass().getDeclaredFields()) {
            try {
                options.put(f.getName(), f.get(this));
            } catch (IllegalAccessException e) {
                Log.d("InAppBrowserOptions", e.getMessage());
            }
        }
        return options;
    }

}
