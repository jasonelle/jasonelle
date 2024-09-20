package com.jasonette.seed.Action;

import android.content.Context;
import android.util.Log;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.jasonette.seed.Core.JasonViewActivity;
import com.jasonette.seed.Helper.JasonHelper;
import com.jasonette.seed.Launcher.Launcher;
import org.json.JSONObject;
import androidx.annotation.NonNull;

import com.google.firebase.messaging.FirebaseMessaging;

// Unlike APN which requires manual registration, FCM automatically registers push upon app launch.
// As a result, $push.register can behave in two different ways:
// 1. If the device is already registered, it immediately triggers $push.onregister event.
// 2. If the device is NOT yet registered, it doesn't do anything (the $push.onregister event will be auto-triggered by JasonPushRegisterService instead)

public class JasonPushAction {
    public void register(final JSONObject action, JSONObject data, final JSONObject event, Context context) {

      FirebaseMessaging.getInstance().getToken().addOnCompleteListener(new OnCompleteListener<String>() {
        @Override
        public void onComplete(@NonNull Task<String> task) {
          if(task.isComplete()) {

            if (!task.isSuccessful()) {
              Log.w("Instance", "getInstanceId failed", task.getException());
              return;
            }

            // Get new Instance ID token
            String refreshedToken = task.getResult();
            if(refreshedToken != null){
              // Token exists => already registered => Immediately trigger $push.onregister
              try {
                JSONObject response = new JSONObject();
                JSONObject payload = new JSONObject();
                payload.put("token", refreshedToken);
                response.put("$jason", payload);
                ((JasonViewActivity)Launcher.getCurrentContext()).simple_trigger("$push.onregister", response, Launcher.getCurrentContext());
              } catch (Exception e) {
                Log.d("Warning", e.getStackTrace()[0].getMethodName() + " : " + e.toString());
              }
            } else {
              // Token doesn't exist => ignore => JasonPushRegisterService will take care of $push.onregister
              Log.d("Debug", "Firebase Token does not Exist");
            }

          }
        }
      });

      JasonHelper.next("success", action, data, event, context);
    }
}
