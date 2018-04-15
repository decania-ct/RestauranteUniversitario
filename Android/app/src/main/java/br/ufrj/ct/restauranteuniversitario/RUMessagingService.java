package br.ufrj.ct.restauranteuniversitario;

import android.app.PendingIntent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;

import android.content.Intent;
import android.content.Context;

import android.app.Notification;
import android.app.NotificationManager;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by Felipe Podolan Oliveira on 16/12/16.
 * This class handles Firebase push notifications and Firebase push messages.
 * For this application it's used only Firebase push messages
 */

public class RUMessagingService extends FirebaseMessagingService {

    /**
     * Notification ID to allow for future updates
     */
    private static final int MY_NOTIFICATION_ID = 1;

    /**
     * Tag for logging
     */
    private final String TAG = "RUMessagingService";

    /**
     * This method is called whenever a push message or notification is received
     * @param remoteMessage the message received
     */
    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        super.onMessageReceived(remoteMessage);

        String jwtToken;
        JSONObject jsonObject = null;

        Log.d(TAG, "From: " + remoteMessage.getFrom());
        String base_url = getApplicationContext().getString(R.string.base_api_url);

        // Check if message contains a data payload.
        if (remoteMessage.getData().size() > 0) {
            //Get the type of the message and the environment (dev or prod)
            String type = "";
            String environment = "";
            try {
                jsonObject = new JSONObject(remoteMessage.getData());
                type = jsonObject.getString("type");
                environment = jsonObject.getString("environment");
            }
            catch (JSONException e) {
                e.printStackTrace();
            }
            //we only handle the dev push messages on dev apps. The same goes to prod.
            if(base_url.contains(environment)) {
                //switch among the possible push notifications
                switch (type) {
                    //case it's a JWT token update, store it on the device
                    case "jwt_token":
                        try {
                            jwtToken = jsonObject.getString("token");
                            SharedPreferences sharedPref =
                                    getApplicationContext().getSharedPreferences(getString(R.string.jwt_preference), Context.MODE_PRIVATE);
                            SharedPreferences.Editor editor = sharedPref.edit();
                            editor.putString(getString(R.string.jwt_token), jwtToken);
                            editor.commit();
                            Log.i("RUMessaging", jwtToken);
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                        break;
                    //case it's a notification, display it to the user
                    case "notification":
                        sendNotification(jsonObject);
                        break;
                    //case it's an attendance, update the ticket
                    case "attendance":
                        updateTicket();
                        break;
                }
            }
        }

        // Check if message contains a notification payload.
        if (remoteMessage.getNotification() != null) {
            Log.d(TAG, "Message Notification Body: " + remoteMessage.getNotification().getBody());
            //Since notifications are only called when app is running and being displayed, this application
            //will not use push notifications. Everything will be done through push messages.
        }
    }

    /**
     * This method displays notifications for the user
     * @param notificationJSON the json with the data of the notification
     */
    private void sendNotification(JSONObject notificationJSON) {
        Intent notificationIntent;
        PendingIntent contentIntent;
        long[] mVibratePattern = { 0, 200, 200, 300 };

        //creatig the notification intent
        notificationIntent = new Intent(getApplicationContext(), br.ufrj.ct.restauranteuniversitario.MainActivity.class);

        //creating the content intent
        contentIntent = PendingIntent.getActivity(this, 0,
                notificationIntent, PendingIntent.FLAG_ONE_SHOT);

        //getting the data from the json and storing in local variables
        String title = null;
        String text = null;
        try {
            title = notificationJSON.getString("title");
            text = notificationJSON.getString("text");
        } catch (JSONException e) {
            e.printStackTrace();
        }

        //getting the app icon bitmap
        Bitmap icon = BitmapFactory.decodeResource(getResources(),
                R.drawable.ru_icon);

        //building the notification with the data and icons
        Notification.Builder notificationBuilder = new Notification.Builder(
                getApplicationContext())
                .setTicker(title + ": " + text)
                .setSmallIcon(R.drawable.icons8diningroom)
                .setLargeIcon(icon)
                .setAutoCancel(true)
                .setContentTitle(title)
                .setContentText(text)
                .setContentIntent(contentIntent)
                .setVibrate(mVibratePattern);

        //send the notification
        NotificationManager mNotificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        assert mNotificationManager != null;
        mNotificationManager.notify(MY_NOTIFICATION_ID, notificationBuilder.build());

    }


    private void updateTicket() {

    }

}