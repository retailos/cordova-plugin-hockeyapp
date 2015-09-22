package org.nypr.cordova.hockeyappplugin;

import net.hockeyapp.android.CrashManager;
import net.hockeyapp.android.UpdateManager;
import net.hockeyapp.android.*;

import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.lang.RuntimeException;
import java.lang.Runnable;
import java.lang.Thread;

import android.util.Log;

public class HockeyAppPlugin extends CordovaPlugin {
	protected static final String LOG_TAG = "HockeyAppPlugin";
    public static boolean initialized = false;
	private String hockeyAppId;
	@Override
	public void initialize(CordovaInterface cordova, CordovaWebView webView) {
		super.initialize(cordova, webView);
        
        int appResId = cordova.getActivity().getResources().getIdentifier("droid_appid", "string", cordova.getActivity().getPackageName());
        hockeyAppId = cordova.getActivity().getString(appResId);
        if(isHockeyAppIdValid()) {
	  _checkForCrashes();
	  _checkForUpdates();
        FeedbackManager.register(cordova.getActivity(), hockeyAppId, null);
        initialized = true;
        Tracking.startUsage(cordova.getActivity());
		Log.d(LOG_TAG, "HockeyApp Plugin initialized");
        }
	}
	
	@Override
	public void onResume(boolean multitasking) {
		Log.d(LOG_TAG, "HockeyApp Plugin resuming");
	  _checkForUpdates();
		super.onResume(multitasking);
	}

  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) {
    boolean ret=true;
    if(action.equalsIgnoreCase("forcecrash")){
      new Thread(new Runnable() {
        public void run() {
          Calendar c = Calendar.getInstance();
          SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
          throw new RuntimeException("Test crash at " + df.format(c.getTime()));
        }
      }).start();
    }else if(action.equals("feedback")) {
            if(initialized) {
                cordova.getActivity().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        FeedbackManager.showFeedbackActivity(cordova.getActivity());
                    }
                });
                callbackContext.success();
                 }
        else{
        callbackContext.error("cordova hockeyapp plugin not initialized, call start() first");
                ret=false;
        }
            
        }
      else{
      callbackContext.error(LOG_TAG + " error: invalid action (" + action + ")");
      ret=false;
    }
    return ret;
  }
		
	@Override
	public void onDestroy() {
		Log.d(LOG_TAG, "HockeyApp Plugin destroying");
		super.onDestroy();
	}

	@Override
	public void onReset() {
		Log.d(LOG_TAG, "HockeyApp Plugin onReset--WebView has navigated to new page or refreshed.");
		super.onReset();
	}
	
	protected void _checkForCrashes() {
		Log.d(LOG_TAG, "HockeyApp Plugin checking for crashes");
        CrashManager.register(cordova.getActivity(), hockeyAppId);
		
	}

	protected void _checkForUpdates() {
		// Remove this for store builds!
		//__HOCKEY_APP_UPDATE_ACTIVE_START__
		//Log.d(LOG_TAG, "HockeyApp Plugin checking for updates");
		//UpdateManager.register(cordova.getActivity(), hockeyAppId);
		//__HOCKEY_APP_UPDATE_ACTIVE_END__
	}
    
    protected boolean isHockeyAppIdValid() { 
        return hockeyAppId!=null || !hockeyAppId.equals("");
     }
}
