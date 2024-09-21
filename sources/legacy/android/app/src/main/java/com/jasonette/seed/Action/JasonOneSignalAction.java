package com.jasonette.seed.Action;

import com.onesignal.OneSignal;
import org.json.JSONObject;
import android.content.Context;
import com.jasonette.seed.Helper.JasonHelper;
import android.util.Log;

public class JasonOneSignalAction {
  // https://documentation.onesignal.com/docs/aliases-external-id
  public void login(final JSONObject action, JSONObject data, final JSONObject event, final Context context) {

    /*
     *  This function let you set the external onesignal id for the actual user
     *
     *            "type": "$onesignal.login",
     *            "options": {
     *              "externalid": "%id%",
     *            }
     */

    try {
      if (action.has("options")) {
        JSONObject options = action.getJSONObject("options");
        if(options.has("externalid")){

          // REGISTER ID
          String externalid = options.getString("externalid");
          OneSignal.login(externalid);
          Log.d("Debug", "OneSignal Login " + externalid);
          JasonHelper.next("success", action, new JSONObject(), event, context);
        }
        else {
          JSONObject err = new JSONObject();
          err.put("message", "externalid is empty");
          JasonHelper.next("error", action, err, event, context);
        }
      }
      else {
        JSONObject err = new JSONObject();
        err.put("message", "$onesignal.set has no options defined");
        JasonHelper.next("error", action, err, event, context);
      }
    } catch (Exception e) {
      Log.d("Warning", e.getStackTrace()[0].getMethodName() + " : " + e.toString());
    }
  }

  public void logout(final JSONObject action, JSONObject data, final JSONObject event, final Context context) {
    /*
     *  This function let you set the external onesignal id for the actual user
     *
     *            "type": "$onesignal.login",
     */
    Log.d("Debug", "OneSignal Logout");
    OneSignal.logout();
    JasonHelper.next("success", action, new JSONObject(), event, context);
  }
}
