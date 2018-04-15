package br.ufrj.ct.restauranteuniversitario;

import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.Fragment;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.GridView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;


/**
 * Created by Felipe Podolan Oliveira.
 * Fragment for the screen that shows the available queues.
 */
public class QueuesFragment extends Fragment {

    /**
     * TAG for logging
     */
    private final String TAG = "QueuesFragment";

    /**
     * The main layout of this fragment
     */
    LinearLayout layout;

    /**
     * Handler to keep updating the screen
     */
    Handler handler;

    /**
     * Empty constructor required for fragments
     */
    public QueuesFragment() {
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
        return inflater.inflate(R.layout.fragment_queues, container, false);
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
        final RelativeLayout relativeLayout = (RelativeLayout) getActivity().findViewById(R.id.queues_relative_layout);

        //initialize layout
        layout = (LinearLayout) getActivity().findViewById(R.id.queues_linear_layout);

        handler = new Handler();

        //instantiate the GridView for the attendance result
        final GridView gridView = new GridView(getActivity());
        final ArrayList<String[]> list = new ArrayList<>();

        //instantiate the adapter class where each view is a queues_item layout resource
        final QueuesAdapter adapter = new QueuesAdapter(getActivity(), list);
        //set params
        GridView.LayoutParams layoutParams = new GridView.LayoutParams(
                GridView.LayoutParams.MATCH_PARENT, GridView.LayoutParams.MATCH_PARENT);
        gridView.setLayoutParams(layoutParams);
        gridView.setNumColumns(1);
        //set adapter
        gridView.setAdapter(adapter);

        final JSONObject urlParams = new JSONObject();
        try {
            urlParams.put("status", "AVALIABLE");
            urlParams.put("extra", "STATISTICS");
        } catch (JSONException e) {
            e.printStackTrace();
        }

        handler.postDelayed(new Runnable() {
            public void run() {
                Log.i(TAG, "Entered refreshing spinner");
                relativeLayout.setVisibility(View.VISIBLE);
                API.getQueues(getActivity(), urlParams, new API.GetQueuesCallback() {
                    @Override
                    public void onSuccess(ArrayList<Queue> queues) {
                        handler.removeCallbacksAndMessages(null);
                        list.clear();
                        for(Queue queue: queues) {
                            ArrayList<Statistic> statistics = queue.getStatistics();
                            String statisticsStr = "";
                            for(int i = 0; i < statistics.size(); i++) {
                                String time = statistics.get(i).getTime_window();
                                String tickets = statistics.get(i).getFree_tickets();
                                statisticsStr += time + "h: " + tickets + " vagas\n";
                            }
                            //add collected data to adapter's list
                            String[] splitted =  queue.getAttendance().split("\\s+");
                            String attendance = splitted[0] + " " + splitted[1] + "\n"
                                    + splitted[2] + "\n"
                                    + "Início: " + splitted[3] + "\n"
                                    + "Término: " + splitted[5] + "\n";
                            String[] collected_data = {attendance, statisticsStr,
                                    queue.getDescription()};
                            list.add(collected_data);
                        }
                        if(queues.size() <= 0 && layout != null) {
                            noAttendanceMessage();
                        }
                        if(queues.size() > 0 && layout != null) {
                            layout.removeAllViews();
                            layout.addView(gridView);
                            for(String[] item: list) {
                                Log.i(TAG, item[0]);
                                Log.i(TAG, item[1]);
                                Log.i(TAG, item[2]);
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
    }

    /**
     * This method displays a message if there's no attendance available
     */
    private void noAttendanceMessage() {
        //get the layout
        RelativeLayout relativeLayout = (RelativeLayout) getActivity().findViewById(R.id.queues_relative_layout);
        relativeLayout.setVisibility(View.GONE);
        layout.setDividerPadding(10);
        //create the text view
        TextView noAttendanceTV = new TextView(getActivity());
        noAttendanceTV.setText(getString(R.string.queues_no_attendance_message));
        noAttendanceTV.setTextSize(20);
        layout.addView(noAttendanceTV);
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
        ((AppCompatActivity)getActivity()).getSupportActionBar().setTitle(getActivity().getString(R.string.available_schedules));
    }

}
