package br.ufrj.ct.restauranteuniversitario;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.Fragment;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.NumberPicker;
import android.widget.ProgressBar;
import android.widget.Spinner;
import android.widget.Switch;
import android.widget.TimePicker;
import android.widget.Toast;

import com.google.firebase.messaging.FirebaseMessaging;

import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Field;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.TimeZone;

/**
 * Created by Felipe Podolan Oliveira.
 * Fragment for the screen that allocates a ticket for an user
 */
public class TicketAllocatorFragment extends Fragment {
    /**
     * TAG for debugging purposes
     */
    private final String TAG = "GeneratorFragment";

    /**
     * The minute interval of the time picker
     */
    private int TIME_PICKER_INTERVAL = 5;

    /**
     * The queue id of the selected attendance
     */
    private String queue_id = "";

    /**
     * The edit text for the identity
     */
    private EditText editTextIdentity;

    /**
     * The spinner to select the queue
     */
    private Spinner spinnerQueueAttendance;

    /**
     * Time Picker to select the requested time
     */
    private TimePicker timePickerSelectedTime;

    /**
     * TODO: The progress bar after the user hits the send button
     */
    private ProgressBar bar;


    /**
     * The shared preferences to save data
     */
    SharedPreferences sharedPref;

    /**
     * the map to store the queue id's mapped with their queue strings
     */
    HashMap<String, String> map;

    /**
     * the params to send to the server
     */
    JSONObject params;

    /**
     * Handler to keep updating the screen
     */
    Handler handler;

    /**
     * Empty constructor required for fragments
     */
    public TicketAllocatorFragment() {
        // Required empty public constructor
    }

    /**
     * This method is called when the fragment view is created
     * @param inflater the inflater that inflates the layout view
     * @param container the view group container that contains all the views
     * @param savedInstanceState the saved instance state in case the fragment needs data to be saved
     *                           and restored when it's resumed
     * @return View inflated
     */
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_ticket_allocator, container, false);
    }

    /**
     * This method is called when the activity that holds the fragment is created. In this case,
     * when the MainActivity is created.
     * @param savedInstanceState the saved instance state in case the fragment needs data to be saved
     *                           and restored when it's resumed
     */
    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        //initialize the class' fields
        //url = getString(R.string.base_api_url) + "queue?status=AVALIABLE&extra=STATISTICS";
        Switch swt = (Switch) getActivity().findViewById(R.id.ticket_allocator_identity_switch);
        editTextIdentity = (EditText) getActivity().findViewById(R.id.ticket_allocator_identity_edit_text);
        sharedPref = getActivity().getPreferences(Context.MODE_PRIVATE);
        spinnerQueueAttendance = (Spinner) getActivity().findViewById(R.id.ticket_allocator_queues_spinner);
        timePickerSelectedTime = (TimePicker) getActivity().findViewById(R.id.ticket_allocator_time_time_picker);
        Button buttonSend = (Button) getActivity().findViewById(R.id.ticket_allocator_button);
        final LinearLayout layout = (LinearLayout) getActivity().findViewById(R.id.ticket_allocator_spinner_layout);

        //configure time picker
        timePickerSelectedTime.setIs24HourView(true);
        //Call method to display minutes with an interval
        setTimePickerInterval();
        //sets the minute accordingly to the current hour
        setTimePickerMinute();

        //retrieve saved identity if there is any
        AppUtility.retrieveSavedIdentity(editTextIdentity, swt, getActivity());

        //save the typed identity
        AppUtility.saveIdentity(editTextIdentity, swt, getActivity());

        map = new HashMap<>();

        final ArrayList<String> list = new ArrayList<>();
        final SpinnerAdapter adapter = new SpinnerAdapter(getActivity(), R.layout.support_simple_spinner_dropdown_item, list);
        spinnerQueueAttendance.setAdapter(adapter);

        final JSONObject urlParams = new JSONObject();
        try {
            urlParams.put("status", "AVALIABLE");
            urlParams.put("extra", "");
        } catch (JSONException e) {
            e.printStackTrace();
        }

        handler = new Handler();
        handler.postDelayed(new Runnable() {
            public void run() {
                Log.i(TAG, "Entered refreshing spinner");
                layout.setVisibility(View.VISIBLE);
                API.getQueues(getActivity(), urlParams, new API.GetQueuesCallback() {
                    @Override
                    public void onSuccess(ArrayList<Queue> queues) {
                        layout.setVisibility(View.GONE);
                        handler.removeCallbacksAndMessages(null);
                        if(queues.size() > 0) {
                            list.clear();
                            map.clear();
                            for(Queue queue: queues) {
                                list.add(queue.getAttendance());
                                map.put(queue.getAttendance(), queue.getId_queues());
                            }
                            adapter.notifyDataSetChanged();
                        }
                    }

                    @Override
                    public void onError(String errorMessage) {
                        Toast.makeText(getActivity(), errorMessage, Toast.LENGTH_LONG).show();
                        handler.removeCallbacksAndMessages(null);
                    }
                });
                handler.postDelayed(this, 10000);
            }
        }, 10000);

        //Add button click listener to button send
        buttonSend.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(!editTextIdentity.getText().toString().isEmpty()) {
                    if (spinnerQueueAttendance.getSelectedItem() != null) {
                        if (!spinnerQueueAttendance.getSelectedItem().toString().isEmpty()) {

                            //get queue id from the selected item on spinner using the map
                            queue_id = map.get(spinnerQueueAttendance.getSelectedItem().toString());

                            //create json object to be sent on request body
                            params = new JSONObject();
                            try {
                                params.put("user_id", editTextIdentity.getText().toString());
                                Locale pt_br = new Locale("pt","BR");
                                DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd", pt_br);
                                Date today = Calendar.getInstance().getTime();
                                String todayStr = dateFormat.format(today);
                                SimpleDateFormat sdf = new SimpleDateFormat("ZZZZZ", pt_br);
                                sdf.setTimeZone(TimeZone.getTimeZone("Brazil/East"));
                                String zone = sdf.format(new Date());
                                if (android.os.Build.VERSION.SDK_INT >= 23) {
                                    params.put("date_requested", todayStr + "T" +
                                            String.format("%02d", timePickerSelectedTime.getHour()) + ":" +
                                            String.format("%02d", timePickerSelectedTime.getMinute() * 5) + ":00"
                                            + zone);
                                } else {
                                    params.put("date_requested", todayStr + "T" +
                                            String.format("%02d", timePickerSelectedTime.getCurrentHour()) + ":" +
                                            String.format("%02d", timePickerSelectedTime.getCurrentMinute() * 5) + ":00"
                                            + zone);
                                }
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }

                            //Call the API's allocate ticket method
                            API.allocateTicket(params, queue_id, getActivity(), new API.TicketAllocatorCallback() {
                                @Override
                                public void onSuccess(Ticket ticket) {
                                    String ticketId = ticket.getTicketId();
                                    String cancelToken = ticket.getCancel_token();
                                    SharedPreferences sharedPref =
                                           getActivity().getApplicationContext().getSharedPreferences(getString(R.string.cancel_token_preference),
                                                   Context.MODE_PRIVATE);
                                    SharedPreferences.Editor editor = sharedPref.edit();
                                    editor.putString(ticketId, cancelToken);
                                    editor.commit();
                                    Toast.makeText(getActivity(), "Agendamos às: " + ticket.getDate_allocated()
                                            + ".\n" + ticket.getMessage(), Toast.LENGTH_LONG).show();
                                    FirebaseMessaging.getInstance().subscribeToTopic("queue-" + ticket.getQueue_id());
                                }

                                @Override
                                public void onError(String message) {
                                    Toast.makeText(getActivity(), message, Toast.LENGTH_LONG).show();
                                }
                            });

                        } else {
                            Toast.makeText(getActivity(), getString(R.string.no_attendance_message),
                                    Toast.LENGTH_LONG).show();
                        }
                    } else {
                        Toast.makeText(getActivity(), getString(R.string.no_attendance_message),
                                Toast.LENGTH_LONG).show();
                    }
                } else {
                    Toast.makeText(getActivity(), getString(R.string.no_id_message),
                            Toast.LENGTH_LONG).show();
                }
            }
        });
    }


    /**
     * This method sets the interval of the minutes for the time picker
     */
    private void setTimePickerInterval() {
        try {
            Class<?> classForid = Class.forName("com.android.internal.R$id");

            Field field = classForid.getField("minute");
            NumberPicker minutePicker = (NumberPicker) timePickerSelectedTime
                    .findViewById(field.getInt(null));

            minutePicker.setMinValue(0);
            minutePicker.setMaxValue(11);
            ArrayList<String> displayedValues = new ArrayList<String>();
            for (int i = 0; i < 60; i += TIME_PICKER_INTERVAL) {
                displayedValues.add(String.format("%02d", i));
            }
            minutePicker.setDisplayedValues(displayedValues
                    .toArray(new String[0]));
            minutePicker.setWrapSelectorWheel(true);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * This method displays the minutes accordingly to the current minute
     */
    private void setTimePickerMinute () {
        Calendar calendar = Calendar.getInstance();

        double currentPerInterval = (double)calendar.get(Calendar.MINUTE)/TIME_PICKER_INTERVAL;
        int ceil = (int) Math.ceil(currentPerInterval);

        int upper_limit = (60 - TIME_PICKER_INTERVAL) / TIME_PICKER_INTERVAL;

        if (android.os.Build.VERSION.SDK_INT >= 23) {
            if(currentPerInterval > upper_limit) {
                timePickerSelectedTime.setHour(timePickerSelectedTime.getHour() + 1);
                timePickerSelectedTime.setMinute(0);
            }
            else {
                timePickerSelectedTime.setMinute(ceil);
            }
        }
        else {
            if(currentPerInterval > upper_limit) {
                timePickerSelectedTime.setCurrentHour(timePickerSelectedTime.getCurrentHour() + 1);
                timePickerSelectedTime.setCurrentMinute(0);
            }
            else {
                timePickerSelectedTime.setCurrentMinute(ceil);
            }
        }

    }

    /**
     * This method is called when the the fragment is detached.
     */
    @Override
    public void onDetach() {
        super.onDetach();
        handler.removeCallbacksAndMessages(null);
    }

    /**
     * This method is called when the fragment is resumed
     */
    @Override
    public void onResume() {
        super.onResume();
        ((AppCompatActivity)getActivity()).getSupportActionBar().setTitle(getActivity().getString(R.string.ticket_allocator));
    }

}
