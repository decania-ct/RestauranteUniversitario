package br.ufrj.ct.restauranteuniversitario;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Handler;
import android.util.Log;
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.NetworkResponse;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.google.gson.Gson;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;

/**
 * Created by Felipe Podolan Oliveira on 30/07/17.
 * This class is responsible for making the calls to the RU API using the Volley HTTP library.
 * Each method represents a different route of the API and the interfaces allow the callbacks.
 */

public class API {

    /**
     * Check token counter so that the calls between the GetToken and the CheckToken methods won't be
     * infinite.
     */
    public static int checkTokenCounter = 0;

    /**
     * This interface is used for the callback of the route GET /status/token
     * which checks if the JWT token saved in the device is valid
     */
    public interface TokenCheckerCallback {
        void onSuccess();
        void onError(String errorMessage);
    }

    /**
     * This method makes a HTTP request to the API to check if the JWT token saved in the device (if
     * there is any) is a valid token.
     * Route: GET /status/token.
     * @param context the context of the application
     * @param callback the TokenCheckerCallback interface that allows other methods to call this
     *                 method and get its results
     */
    public static void checkToken(final Context context, final TokenCheckerCallback callback) {
        if(context != null) {
            //Getting the route of the API, using the saved API base url string
            String url = context.getString(R.string.base_api_url) + "status/token";
            Log.i("API Login", url);

            //Creating the request. This is a GET HTTP string request of the given URL.
            StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
                    new Response.Listener<String>() {
                        //if the response code is 200, callback onSuccess method of the interface
                        @Override
                        public void onResponse(String response) {
                            callback.onSuccess();
                        }

                    },
                    new Response.ErrorListener() {
                        @Override
                        //if the response is an error, the token isn't valid. So, ask for a new one
                        public void onErrorResponse(VolleyError error) {
                            Log.i("API Login", error.toString());
                            if(checkTokenCounter < 10) {
                                Log.i("API Login", Integer.valueOf(checkTokenCounter).toString());
                                checkTokenCounter++;
                                Handler handler = new Handler();
                                handler.postDelayed(new Runnable() {
                                    public void run() {
                                        //Calls getToken method to ask for a new token with route POST clients/token
                                        getToken(context, new TokenGetterCallback() {
                                            //onSuccess callback of POST clients/token calls onSuccess callback of GET status/token
                                            @Override
                                            public void onSuccess() {
                                                callback.onSuccess();
                                            }

                                            //onError callback of POST clients/toke calls onError callback of GET status/token
                                            @Override
                                            public void onError(String errorMessage) {
                                                callback.onError(errorMessage);
                                            }
                                        });
                                    }
                                }, 4000);
                            }
                        }
                    }
            )

            {
                //This method is responsible for the headers of the request
                @Override
                public Map<String, String> getHeaders() throws AuthFailureError {
                    SharedPreferences sharedPref =
                            context.getSharedPreferences(context.getString(R.string.jwt_preference), Context.MODE_PRIVATE);
                    String jwtToken = sharedPref.getString(context.getString(R.string.jwt_token), "");
                    Map<String, String> params = new HashMap<>();
                    params.put("Authorization", "Bearer " + jwtToken);
                    params.put("Content-Type", "application/json");
                    params.put("Accept", "application/json");
                    return params;
                }

            };

            //After the request behavior is defined, send request to API
            RUSingleton.getmInstance(context).addToRequestQueue(stringRequest);
        }
    }

    /**
     * This interface is used for the callback of the route POST clients/token
     * which asks the API for a new JWT token
     */
    public interface TokenGetterCallback {
        void onSuccess();
        void onError(String errorMessage);
    }

    /**
     * This method makes an HTTP request to the API to ask for a new JWT token.
     * Route: POST clients/token
     * @param context the context of the application
     * @param callback the TokenGetterCallback interface that allows other methods to call this
     *                 method and get its results
     */
    public static void getToken(final Context context, final TokenGetterCallback callback) {
        if(context != null) {
            //Getting the route of the API, using the saved API base url string
            String url = context.getString(R.string.base_api_url) + "clients/token";
            Log.i("API Login", url);

            //Creating the request. This is a POST HTTP string request of the given URL.
            StringRequest stringRequest = new StringRequest(Request.Method.POST, url,
                    new Response.Listener<String>() {
                        //if the response code is 200
                        @Override
                        public void onResponse(String response) {
                            //the response body's json should have a key "result"
                            JSONObject jsonObject = null;
                            String result = null;
                            try {
                                jsonObject = new JSONObject(response);
                                result = jsonObject.getString("result");
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }

                        /*
                         * if key "result" has a value "success" check if the received token is valid using route GET /status/token
                         *
                         * NOTE: the token is sent through a push message (which is manipulated within the RUMessagingService class) and thus
                         * when the checkToken method is called it might have not been received yet. This causes a loop behaviour between these
                         * two methods until the token is received and the GET status/token request receives a 200 code response
                         */
                            if(result.equals("success")) {
                                Handler handler = new Handler();
                                handler.postDelayed(new Runnable() {
                                    public void run() {
                                        checkToken(context, new TokenCheckerCallback() {
                                            @Override
                                            //onSuccess callback of GET status/token calls onSuccess callback of POST clients/token
                                            public void onSuccess() {
                                                callback.onSuccess();
                                            }

                                            //onError callback of GET status/token calls onError callback of POST clients/token
                                            @Override
                                            public void onError(String errorMessage) {
                                                callback.onError(errorMessage);
                                            }
                                        });
                                    }
                                }, 4000);
                            }
                        }

                    },
                    new Response.ErrorListener() {
                        //if the response is an error, get the error message and send to onError callback
                        @Override
                        public void onErrorResponse(VolleyError error) {
                            Log.i("LoginActivity", error.toString());
                            JSONObject resultError = null;
                            String data = null;
                            String message = null;
                            NetworkResponse response = error.networkResponse;
                            if(response != null && response.data != null){
                                switch(response.statusCode){
                                    default:
                                        data = new String(response.data);
                                        Log.i("API GenerateTicket", data);
                                        try {
                                            JSONObject jsonObject = new JSONObject(data);
                                            message = jsonObject.getString("details");
                                            if (message.isEmpty()) {
                                                message = jsonObject.getString("message");
                                            }
                                        } catch (JSONException e) {
                                            e.printStackTrace();
                                        }
                                        break;
                                }
                            }
                            callback.onError(message);
                        }
                    }
            )

            {
                //This method is responsible for the body of the request
                @Override
                public byte[] getBody() {
                    try {
                        final JSONObject params = new JSONObject();
                        SharedPreferences sharedPreferences =
                                context.getApplicationContext().getSharedPreferences(context.getString(R.string.fcm_preference), Context.MODE_PRIVATE);
                        try {
                            params.put("subject", AppUtility.getDeviceName());
                            params.put("app", context.getString(R.string.firebase_package_name));
                            params.put("device", sharedPreferences.getString(context.getString(R.string.fcm_token), null));
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                        Log.i("API Login", params.toString());
                        return params.toString().getBytes("utf-8");
                    } catch (UnsupportedEncodingException uee) {
                        uee.printStackTrace();
                        return null;
                    }
                }

                //This method is responsible for the headers of the request
                @Override
                public Map<String, String> getHeaders() throws AuthFailureError {
                    Map<String, String> params = new HashMap<>();
                    params.put("Content-Type", "application/json");
                    params.put("Accept", "application/json");
                    return params;
                }

            };

            //After the request behavior is defined, send request to API//send request to API
            RUSingleton.getmInstance(context).addToRequestQueue(stringRequest);
        }
    }

    /**
     * This interface is used for the callback of the route POST queues/:queue_id
     * which allocates a ticket in a queue
     */
    public interface TicketAllocatorCallback {
        void onSuccess(Ticket ticket);
        void onError(String errorMessage);
    }

    /**
     * This method makes an HTTP request to the API to allocate a ticket in a queue.
     * Route: POST queues/:queue_id
     * @param params the params gotten from the interface to be sent in the body of the request
     * @param queueId the queue id which the ticket is going to be allocated in
     * @param context the context of the application
     * @param callback the TicketAllocatorCallback interface that allows other methods to call this
     *                 method and get its results
     */
    public static void allocateTicket(final JSONObject params, final String queueId, final Context context, final TicketAllocatorCallback callback) {
        if(context != null) {
            checkTokenCounter = 0;
            //Before doing the request, check if the stored JWT token is valid calling GET status/token route
            checkToken(context, new TokenCheckerCallback() {
                //if the GET status/token response has a code 200, the token is valid
                @Override
                public void onSuccess() {
                    //Getting the params and storing them in local variables
                    String userId = "";
                    try {
                        userId = params.getString("user_id");
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                    //Creating the ticket to send in the onSuccess callback
                    final Ticket ticket = new Ticket();
                    ticket.setUser_id(userId);
                    ticket.setQueue_id(queueId);

                    //Getting the route of the API, using the saved API base url string and the queue id
                    String url = context.getString(R.string.base_api_url) + "queues/" + queueId;

                    Log.i("API GenerateTicket", url);
                    Log.i("API GenerateTicket", params.toString());

                    //Creating the request. This is a POST HTTP string request of the given URL.
                    StringRequest stringRequest = new StringRequest(Request.Method.POST, url,
                            new Response.Listener<String>() {
                                //if the response code is 200
                                @Override
                                public void onResponse(String response) {
                                    JSONObject jsonObject = null;
                                    String result = null;
                                    try {
                                        //the json from the response body should have a key "result"
                                        jsonObject = new JSONObject(response);
                                        Log.i("GeneratorFragment", response);
                                        result = jsonObject.getString("result");
                                        //set the ticket params
                                        JSONObject ticketJson = jsonObject.getJSONObject("ticket");
                                        ticket.setCancel_token(ticketJson.getString("cancel_token"));
                                        ticket.setDate_allocated(AppUtility.formatDate(ticketJson.getString("date_allocated")));
                                        ticket.setId_ticket(ticketJson.getString("id_ticket"));
                                        ticket.setMessage(ticketJson.getString("message"));

                                    } catch (JSONException e) {
                                        e.printStackTrace();
                                    }
                                    //if value of key result is success, call onSuccess callback
                                    if(result.equals("success") && !ticket.getUser_id().isEmpty()) {
                                        callback.onSuccess(ticket);
                                    }
                                    //if value of key result isn't "success", get the error details/message and call onError callback
                                    else {
                                        String errorMessage = null;
                                        try {
                                            jsonObject = new JSONObject(response);
                                            Log.i("GeneratorFragment", response);
                                            errorMessage = jsonObject.getString("details");
                                            if (errorMessage.isEmpty()) {
                                                errorMessage = jsonObject.getString("message");
                                            }
                                            callback.onError(errorMessage);
                                        } catch (JSONException e) {
                                            e.printStackTrace();
                                        }
                                    }
                                }

                            },
                            new Response.ErrorListener() {
                                @Override
                                //if the response is an error, get the error details/message and call onError callback
                                public void onErrorResponse(VolleyError error) {
                                    Log.i("API GenerateTicket", error.toString());
                                    JSONObject resultError = null;
                                    String data = null;
                                    String message = null;
                                    NetworkResponse response = error.networkResponse;
                                    if(response != null && response.data != null){
                                        switch(response.statusCode){
                                            default:
                                                data = new String(response.data);
                                                Log.i("API GenerateTicket", data);
                                                try {
                                                    JSONObject jsonObject = new JSONObject(data);
                                                    message = jsonObject.getString("details");
                                                    if (message.isEmpty()) {
                                                        message = jsonObject.getString("message");
                                                    }
                                                } catch (JSONException e) {
                                                    e.printStackTrace();
                                                }
                                                break;
                                        }
                                    }
                                    callback.onError(message);
                                }
                            }
                    )

                    {
                        //This method is responsible for the body of the request
                        @Override
                        public byte[] getBody() {
                            try {
                                return params.toString().getBytes("utf-8");
                            } catch (UnsupportedEncodingException uee) {
                                uee.printStackTrace();
                                return null;
                            }
                        }

                        //This method is responsible for the headers of the request
                        @Override
                        public Map<String, String> getHeaders() throws AuthFailureError {
                            SharedPreferences sharedPref =
                                    context.getSharedPreferences(context.getString(R.string.jwt_preference), Context.MODE_PRIVATE);
                            String jwtToken = sharedPref.getString(context.getString(R.string.jwt_token), "");
                            Map<String, String> params = new HashMap<>();
                            params.put("Authorization", "Bearer " + jwtToken);
                            params.put("Content-Type", "application/json");
                            params.put("Accept", "application/json");
                            return params;
                        }
                    };

                    //After the request behavior is defined, send request to API
                    RUSingleton.getmInstance(context).addToRequestQueue(stringRequest);
                }

                @Override
                public void onError(String errorMessage) {

                }
            });
        }
    }

    /**
     * This interface is used for the callback of the route GET queues/:queue_id/tickets/:user_id
     * which searches for a ticket in a queue
     */
    public interface TicketSearcherCallback {
        void onSuccess(ArrayList<Ticket> tickets);
        void onError(String errorMessage);
    }

    /**
     * This method makes an HTTP request to the API to search for a ticket in a queue.
     * Route: GET queues/:queue_id/tickets/:user_id
     * @param attendance the attendance string is a string that is related to a single queue
     * @param userId the user id whose ticket is to be searched
     * @param queueId the queue id where the ticket is allocated
     * @param context the context of the application
     * @param callback the TicketSearchCallback interface that allows other methods to call this
     *                 method and get its results
     */
    public static void searchTicket(final String attendance, final String userId, final String queueId,
                                    final Context context, final TicketSearcherCallback callback) {
        if(context != null) {
            checkTokenCounter = 0;
            //Before doing the request, check if the stored JWT token is valid calling GET status/token route
            checkToken(context, new TokenCheckerCallback() {
                //if the GET status/token response has a code 200, the token is valid
                @Override
                public void onSuccess() {
                    //Getting the route of the API, using the saved API base url string, the queue id and the user id
                    String url = context.getString(R.string.base_api_url) + "queues/" + queueId + "/tickets/" + userId;

                    //Creating the request. This is a GET HTTP string request of the given URL.
                    StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
                            new Response.Listener<String>() {
                                //if the response code is 200
                                @Override
                                public void onResponse(String response) {
                                    Boolean hasPendingTickets = false;
                                    try {
                                        //the json from the response body should have a key "result"
                                        JSONObject jsonObject = new JSONObject(response.toString());
                                        String result = jsonObject.getString("result");
                                        Log.i("API Search", result.toString());
                                        //if value of key result is success, get the array of tickets found for that queue and for that user
                                        if(result.equals("success")) {
                                            JSONArray ticketsArray = jsonObject.getJSONArray("tickets");
                                            ArrayList<Ticket> tickets = new ArrayList<>();
                                            //for each ticket found, check its status
                                            for(int i = 0; i < ticketsArray.length(); i++) {
                                                try {
                                                    JSONObject ticketJsonObject = (JSONObject) ticketsArray.get(i);
                                                    //we are only interested in displaying the PENDING tickets
                                                    if (ticketJsonObject.getString("status").equals("PENDING")) {
                                                        hasPendingTickets = true;
                                                        //Create the Ticket object from the ticket json using the Gson library
                                                        Gson gson = new Gson();
                                                        Log.i("API Search", ticketJsonObject.toString());
                                                        Ticket ticket = gson.fromJson(ticketJsonObject.toString(), Ticket.class);
                                                        ticket.setStatus(Ticket.statusEnum.PENDING);
                                                        ticket.setAttendance(attendance);
                                                        ticket.setDate_allocated(AppUtility.formatDate(ticket.getDate_allocated()));
                                                        //add all the PENDING tickets to the tickets array list
                                                        tickets.add(ticket);
                                                    }
                                                } catch (JSONException e) {
                                                    e.printStackTrace();
                                                }
                                            }
                                            //call onSuccess callback
                                            if(hasPendingTickets) {
                                                callback.onSuccess(tickets);
                                            }
                                            //if no ticket with a PENDING status has been found in that queue for that user, display the massage saying that
                                            //no tickets have been found
                                            else {
                                                Log.i("API SEARCH", context.getString(R.string.toast_no_tickets_found_message));
                                                Toast.makeText(context, context.getString(R.string.toast_no_tickets_found_message),
                                                        Toast.LENGTH_LONG).show();
                                            }
                                        }
                                        else {
                                            //if value of key result isn't "success", get the error details/message and call onError callback
                                            String errorMessage = null;
                                            try {
                                                jsonObject = new JSONObject(response);
                                                Log.i("GeneratorFragment", response);
                                                errorMessage = jsonObject.getString("details");
                                                if (errorMessage.isEmpty()) {
                                                    errorMessage = jsonObject.getString("message");
                                                }
                                                callback.onError(errorMessage);
                                            } catch (JSONException e) {
                                                e.printStackTrace();
                                            }
                                        }
                                    } catch (JSONException e) {
                                        e.printStackTrace();
                                    }
                                }

                            },
                            new Response.ErrorListener() {
                                //if the response is an error, get the error details/message and call onError callback
                                @Override
                                public void onErrorResponse(VolleyError error) {
                                    Log.i("SearchFragment", error.toString());
                                    JSONObject resultError = null;
                                    String data = null;
                                    String message = null;
                                    NetworkResponse response = error.networkResponse;
                                    if(response != null && response.data != null){
                                        switch(response.statusCode){
                                            default:
                                                data = new String(response.data);
                                                Log.i("API GenerateTicket", data);
                                                try {
                                                    JSONObject jsonObject = new JSONObject(data);
                                                    message = jsonObject.getString("details");
                                                    if (message.isEmpty()) {
                                                        message = jsonObject.getString("message");
                                                    }
                                                } catch (JSONException e) {
                                                    e.printStackTrace();
                                                }
                                                break;
                                        }
                                    }
                                    callback.onError(message);
                                }
                            }
                    )
                    {
                        //This method is responsible for the headers of the request
                        @Override
                        public Map<String, String> getHeaders() throws AuthFailureError {
                            SharedPreferences sharedPref =
                                    context.getSharedPreferences(context.getString(R.string.jwt_preference), Context.MODE_PRIVATE);
                            String jwtToken = sharedPref.getString(context.getString(R.string.jwt_token), "");
                            Map<String, String> params = new HashMap<>();
                            params.put("Authorization", "Bearer " + jwtToken);
                            params.put("Content-Type", "application/json");
                            params.put("Accept", "application/json");
                            Log.i("API Search", params.toString());
                            return params;
                        }
                    };

                    //After the request behavior is defined, send request to API
                    RUSingleton.getmInstance(context).addToRequestQueue(stringRequest);
                }

                @Override
                public void onError(String errorMessage) {

                }
            });
        }
    }

    /**
     * This interface is used for the callback of the route PUT queues/:queue_id/tickets/:user_id
     * which updates a ticket in a queue
     */
    public interface TicketUpdaterCallback {
        void onSuccess(Ticket.statusEnum status);
        void onError(String errorMessage);
    }

    /**
     * This method makes an HTTP request to the API to update a ticket in a queue.
     * Route: PUT queues/:queue_id/tickets/:user_id
     * @param newStatus the new status of the ticket
     * @param context the context of the application
     * @param ticket the ticket object to be updated
     * @param callback the TicketUpdaterCallback interface that allows other methods to call this
     *                 method and get its results
     */
    public static void updateStatus(final Ticket.statusEnum newStatus, final Context context, final Ticket ticket, final TicketUpdaterCallback callback) {
        if(context != null) {
            checkTokenCounter = 0;
            //Before doing the request, check if the stored JWT token is valid calling GET status/token route
            checkToken(context, new TokenCheckerCallback() {
                //if the GET status/token response has a code 200, the token is valid
                @Override
                public void onSuccess() {
                    ticket.setStatus(newStatus);
                    //Getting the route of the API, using the saved API base url string, the queue id and the user id
                    String url = context.getString(R.string.base_api_url) + "queues/" + ticket.getQueue_id() + "/tickets/" + ticket.getUser_id();

                    //Creating the request. This is a PUT HTTP string request of the given URL.
                    StringRequest stringRequest = new StringRequest(Request.Method.PUT, url,
                            new Response.Listener<String>() {
                                //if the response code is 200
                                @Override
                                public void onResponse(String response) {
                                    //create a ticket object from the ticket json of the response which is the updated ticket
                                    Gson gson = new Gson();
                                    Ticket updatedTicket = gson.fromJson(response, Ticket.class);
                                    //call onSuccess callback
                                    callback.onSuccess(updatedTicket.getStatus());
                                }

                            },
                            new Response.ErrorListener() {
                                //if the response is an error, get the error details/message and call onError callback
                                @Override
                                public void onErrorResponse(VolleyError error) {
                                    JSONObject resultError = null;
                                    String data = null;
                                    String message = null;
                                    NetworkResponse response = error.networkResponse;
                                    if(response != null && response.data != null){
                                        switch(response.statusCode){
                                            default:
                                                data = new String(response.data);
                                                Log.i("API GenerateTicket", data);
                                                try {
                                                    JSONObject jsonObject = new JSONObject(data);
                                                    message = jsonObject.getString("details");
                                                    if (message.isEmpty()) {
                                                        message = jsonObject.getString("message");
                                                    }
                                                } catch (JSONException e) {
                                                    e.printStackTrace();
                                                }
                                                break;
                                        }
                                    }
                                    callback.onError(message);
                                }
                            }
                    )

                    {
                        //This method is responsible for the body of the request
                        @Override
                        public byte[] getBody() {
                            try {
                                //creating json object to be sent on request body
                                JSONObject params = new JSONObject();
                                try {
                                    params.put("status", newStatus.name());
                                    params.put("cancel_token", ticket.getCancel_token());
                                    Log.i("Ticket Fragment", params.toString());
                                } catch (JSONException e) {
                                    e.printStackTrace();
                                }
                                return params.toString().getBytes("utf-8");
                            } catch (UnsupportedEncodingException uee) {
                                uee.printStackTrace();
                                return null;
                            }
                        }

                        //This method is responsible for the headers of the request
                        @Override
                        public Map<String, String> getHeaders() throws AuthFailureError {
                            SharedPreferences sharedPref =
                                    context.getSharedPreferences(context.getString(R.string.jwt_preference), Context.MODE_PRIVATE);
                            String jwtToken = sharedPref.getString(context.getString(R.string.jwt_token), "");
                            Map<String, String> params = new HashMap<>();
                            params.put("Authorization", "Bearer " + jwtToken);
                            params.put("Content-Type", "application/json");
                            params.put("Accept", "application/json");
                            return params;
                        }
                    };

                    //After the request behavior is defined, send request to API
                    RUSingleton.getmInstance(context).addToRequestQueue(stringRequest);
                }

                @Override
                public void onError(String errorMessage) {

                }
            });
        }
    }

    /**
     * This interface is used for the callback of the route GET /queues
     * which gets queues
     */
    public interface GetQueuesCallback {
        void onSuccess(ArrayList<Queue> queues);
        void onError(String errorMessage);
    }

    /**
     * This method makes an HTTP request to the API to get queues.
     * Route: GET /queues
     * @param context the context of the application
     * @param urlParams the params of the URL
     * @param callback the GetQueuesCallback interface that allows other methods to call this
     *                 method and get its results
     */
    public static void getQueues(final Context context, final JSONObject urlParams, final GetQueuesCallback callback) {
        if(context != null) {
            checkTokenCounter = 0;
            checkToken(context, new TokenCheckerCallback() {
                //if the GET status/token response has a code 200, the token is valid
                @Override
                public void onSuccess() {
                    String status = "";
                    String extra = "";
                    try {
                        if(!urlParams.getString("status").isEmpty()) {
                            status = "status=" + urlParams.getString("status");
                        }
                        if(!urlParams.getString("extra").isEmpty()) {
                            extra = "extra=" + urlParams.getString("extra");
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                    //Getting the route of the API, using the saved API base url string
                    String url = context.getString(R.string.base_api_url) + "queues";
                    if(!status.isEmpty()) {
                        url += "?" + status;
                        if(!extra.isEmpty()){
                            url += "&" + extra;
                        }
                    }
                    else {
                        url += "?" + extra;
                    }

                    Log.i("TAG", url);
                    //Creating the request. This is a GET HTTP string request of the given URL.
                    StringRequest request = new StringRequest(Request.Method.GET, url,
                            new Response.Listener<String>() {
                                //if the response code is 200
                                @Override
                                public void onResponse(String response) {
                                    try {
                                        ArrayList<Queue> queues = new ArrayList<>();

                                        JSONArray jsonArray = new JSONArray(response);
                                        //for each available queue
                                        for(int i = 0; i < jsonArray.length(); i++) {
                                            Gson gson = new Gson();
                                            //create the json object of each queue
                                            JSONObject queueJsonObject = jsonArray.getJSONObject(i);
                                            Queue queue = gson.fromJson(queueJsonObject.toString(), Queue.class);

                                            //handle the dates format
                                            String dateStr = null;
                                            String hrStart = null;
                                            String hrEnd = null;
                                            Locale pt_br = new Locale("pt","BR");
                                            SimpleDateFormat sfm = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZZZZZ", pt_br);
                                            sfm.setTimeZone(TimeZone.getTimeZone("Brazil/East"));
                                            try {
                                                Date dateStartDate = sfm.parse(queue.getDate_start());
                                                Date dateEndDate = sfm.parse(queue.getDate_end());
                                                sfm = new SimpleDateFormat("dd/MM/yyyy", pt_br);
                                                sfm.setTimeZone(TimeZone.getTimeZone("Brazil/East"));
                                                dateStr = sfm.format(dateStartDate);
                                                sfm = new SimpleDateFormat("HH:mm'h'", pt_br);
                                                sfm.setTimeZone(TimeZone.getTimeZone("Brazil/East"));
                                                hrStart = sfm.format(dateStartDate);
                                                hrEnd = sfm.format(dateEndDate);
                                            } catch (ParseException e) {
                                                e.printStackTrace();
                                            }

                                            String queueStr = queue.getType() + " " + queue.getOu() + " " + dateStr +
                                                    " " + hrStart +
                                                    " às " + hrEnd;

                                            queue.setAttendance(queueStr);

                                            queues.add(queue);
                                        }
                                        callback.onSuccess(queues);
                                        Log.i("TAG", queues.toString());
                                    } catch (JSONException e) {
                                        e.printStackTrace();
                                    }
                                }
                            },
                            new Response.ErrorListener() {
                                //if the response is an error, get the error message and send to onError callback
                                @Override
                                public void onErrorResponse(VolleyError error) {
                                    String data;
                                    String message = null;
                                    NetworkResponse response = error.networkResponse;
                                    if(response != null && response.data != null){
                                        switch(response.statusCode){
                                            default:
                                                data = new String(response.data);
                                                try {
                                                    JSONObject jsonObject = new JSONObject(data);
                                                    message = jsonObject.getString("details");
                                                    if (message.isEmpty()) {
                                                        message = jsonObject.getString("message");
                                                    }
                                                } catch (JSONException e) {
                                                    e.printStackTrace();
                                                }
                                                break;
                                        }
                                    }
                                    callback.onError(message);
                                }
                            }
                    )
                    {
                        //This method is responsible for the headers of the request
                        @Override
                        public Map<String, String> getHeaders() throws AuthFailureError {
                            SharedPreferences sharedPref =
                                    context.getSharedPreferences(context.getString(R.string.jwt_preference), Context.MODE_PRIVATE);
                            String jwtToken = sharedPref.getString(context.getString(R.string.jwt_token), "");
                            Map<String, String> params = new HashMap<>();
                            params.put("Authorization", "Bearer " + jwtToken);
                            params.put("Content-Type", "application/json");
                            params.put("Accept", "application/json");
                            return params;
                        }
                    };

                    //After the request behavior is defined, send request to API
                    RUSingleton.getmInstance(context).addToRequestQueue(request);
                }

                @Override
                public void onError(String errorMessage) {

                }
            });
        }
    }
}