package br.ufrj.ct.restauranteuniversitario;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.Spinner;
import android.widget.Switch;
import android.widget.Toast;

import com.google.gson.Gson;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;


/**
 * Fragment for the screen that searches for a ticket
 */
public class TicketSearcherFragment extends Fragment {

    /**
     * TAG for debugging purposes
     */
    final String TAG = "SearchFragment";

    /**
     * The queue id of the selected attendance
     */
    String queue_id = "";

    /**
     * The edit text for the identity
     */
    private EditText editTextIdentity;

    /**
     * The spinner to select the queue
     */
    private Spinner spinnerQueueAttendance;

    /**
     * The map to store the queue id's mapped with their queue strings
     */
    HashMap<String, String> map;


    /**
     * Handler to keep updating the screen
     */
    Handler handler;

    /**
     * Empty constructor required for fragments
     */
    public TicketSearcherFragment() {
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
        return inflater.inflate(R.layout.fragment_ticket_searcher, container, false);
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
        Switch swt = (Switch) getActivity().findViewById(R.id.ticket_searcher_identity_switch);
        editTextIdentity = (EditText) getActivity().findViewById(R.id.ticket_searcher_identity_edit_text);
        spinnerQueueAttendance = (Spinner) getActivity().findViewById(R.id.ticket_searcher_queues_spinner);
        Button buttonSend = (Button) getActivity().findViewById(R.id.ticket_searcher_button);
        final LinearLayout layout = (LinearLayout) getActivity().findViewById(R.id.ticket_searcher_queues_spinner_layout);

        //retrieve saved identity if there is any
        AppUtility.retrieveSavedIdentity(editTextIdentity, swt, getActivity());

        //save the typed identity
        AppUtility.saveIdentity(editTextIdentity, swt, getActivity());

        map = new HashMap<>();

        handler = new Handler();

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
                            String CPF = editTextIdentity.getText().toString();
                            final String attendance = spinnerQueueAttendance.getSelectedItem().toString();
                            queue_id = map.get(attendance);

                            //call API search ticket
                            API.searchTicket(attendance, CPF, queue_id, getActivity(), new API.TicketSearcherCallback() {
                                //if the response code is 200
                                @Override
                                public void onSuccess(ArrayList<Ticket> tickets) {
                                    //prepare to transact between fragments
                                    FragmentManager fm = getActivity().getSupportFragmentManager();
                                    FragmentTransaction ft = fm.beginTransaction();
                                    Fragment fragment = null;
                                    String TAG = null;
                                    Log.i("SearchFragment", tickets.toString());
                                    //if there are more than one ticket, go to attach TicketSearcherResultFragment
                                    if(tickets.size() == 1) {
                                        Ticket ticket = tickets.get(0);
                                        //SharedPreferences sharedPref = getActivity().getPreferences(Context.MODE_PRIVATE);
                                        //SharedPreferences.Editor editor = sharedPref.edit();
                                        Gson gson = new Gson();
                                        String ticketJson = gson.toJson(ticket);
                                        //editor.putString("ticketJson", ticketJson);
                                        //Log.i("TicketSearcherFragment", ticketJson);
                                        //editor.commit();

                                        Intent intent = new Intent(getActivity().getApplicationContext(), TicketActivity.class);
                                        intent.putExtra("ticket", ticketJson);
                                        startActivity(intent);

                                    }
                                    //if there's only one ticket, attach TicketFragment
                                    else {
                                        fragment = new TicketSearchResultFragment();
                                        ((TicketSearchResultFragment)fragment).setTickets(tickets);
                                        ((TicketSearchResultFragment)fragment).setAttendance(attendance);

                                        //do the attachment
                                        ft.addToBackStack("SearchFragment");
                                        ft.replace(R.id.main_frame, fragment);
                                        ft.commit();
                                    }
                                }

                                @Override
                                public void onError(String message) {
                                    Toast.makeText(getContext(), message, Toast.LENGTH_LONG).show();
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
        ((AppCompatActivity)getActivity()).getSupportActionBar().setTitle(getActivity().getString(R.string.ticket_searcher));
    }

}
