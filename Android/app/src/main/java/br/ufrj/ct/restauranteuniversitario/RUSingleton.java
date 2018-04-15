package br.ufrj.ct.restauranteuniversitario;

import android.content.Context;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.toolbox.Volley;

/**
 * Created by Felipe Podolan Oliveira on 05/01/17.
 * This class is a singleton to add Volley HTTP requests to the request queue
 */

public class RUSingleton {
    /**
     * the instance of this class
     */
    private static RUSingleton mInstance;
    /**
     * the context of the application
     */
    private static Context mCtx;

    /**
     * the Volley request queue
     */
    private RequestQueue requestQueue;

    /**
     * Constructor for this singleton
     * @param context the context of the application
     */
    private RUSingleton(Context context) {
        mCtx = context;
        requestQueue = getRequestQueue();
    }

    /**
     * This method gets the current Volley queue or creates a new one if there isn't one
     * @return The RequestQueue that is currently being used or a new one if there isn't one
     */
    private RequestQueue getRequestQueue() {
        if(requestQueue == null) {
            requestQueue = Volley.newRequestQueue(mCtx.getApplicationContext());
        }
        return requestQueue;
    }

    /**
     * This method returns an instance of this class
     * @param context the context of the application
     * @return RUSingleton instance
     */
    public static synchronized RUSingleton getmInstance(Context context) {
        if (mInstance == null) {
            mInstance = new RUSingleton(context);
        }
        return mInstance;
    }

    /**
     * This method adds a HTTP Volley request to the Volley queue
     * @param request the Volley request to be added
     * @param <T> the type of the request to be added
     */
    public<T> void addToRequestQueue(Request<T> request) {
        getRequestQueue().add(request);
    }
}
