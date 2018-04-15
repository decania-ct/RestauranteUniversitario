package br.ufrj.ct.restauranteuniversitario;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.google.firebase.iid.FirebaseInstanceId;
import com.google.firebase.iid.FirebaseInstanceIdService;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Felipe Podolan Oliveira on 16/12/16.
 * This class deals with the Firebase Token.
 */

public class RUInstanceIDService extends FirebaseInstanceIdService {

    /**
     * TAG for logging
     */
    private final String TAG = "MyInstanceIDService";

    /**
     * This method is called whenever the fcm_token (Firebase token) is refreshed
     */
    @Override
    public void onTokenRefresh() {
        super.onTokenRefresh();
        // Get updated firebase token.
        String refreshedToken = FirebaseInstanceId.getInstance().getToken();
        Log.d(TAG, "Refreshed token: " + refreshedToken);

        //Save new token on device
        SharedPreferences sharedPreferences =
                getApplicationContext().getSharedPreferences(getString(R.string.fcm_preference), Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putString(getString(R.string.fcm_token), refreshedToken);
        editor.commit();
    }
}
