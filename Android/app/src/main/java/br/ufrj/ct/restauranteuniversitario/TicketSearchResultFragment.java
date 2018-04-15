package br.ufrj.ct.restauranteuniversitario;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.ActivityInfo;
import android.os.Bundle;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;

import android.support.v7.app.AppCompatActivity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.ListView;

import com.google.gson.Gson;

import java.util.ArrayList;

/**
 * Created by Felipe Podolan Oliveira.
 * Fragment for the screen that shows a list of ticket if more than one that fulfills the criteria is found.
 */
public class TicketSearchResultFragment extends android.support.v4.app.Fragment {

    /**
     * Array List with the tickets to be shown
     */
    private ArrayList<Ticket> tickets;
    /**
     * The attendance string of the tickets
     */
    private String attendance;

    /**
     * The fragment layout
     */
    LinearLayout layout;

    /**
     * Empty constructor required for fragments
     */
    public TicketSearchResultFragment() {
        // Required empty public constructor
    }

    /**
     * This method sets the array list of tickets with a given array list
     * @param tickets the array list given to set the class field
     */
    public void setTickets(ArrayList<Ticket> tickets) {
        this.tickets = tickets;
    }

    /**
     * This method sets the attendande with a given attendance string
     * @param attendance attendance string given to set the class field
     */
    public void setAttendance (String attendance) {
        this.attendance = attendance;
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
        return inflater.inflate(R.layout.fragment_ticket_search_result, container, false);
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

        //get the layout
        layout = (LinearLayout) getActivity().findViewById(R.id.ticket_search_result_layout);

        //check if the array list exists
        if(tickets != null) {
            //create a list view and its adapter
            final ListView listView = new ListView(getActivity());
            TicketsListAdapter ticketsAdapter = new TicketsListAdapter(getActivity(), tickets);
            listView.setAdapter(ticketsAdapter);

            //sets list view click listener
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                    Ticket ticket = (Ticket) adapterView.getItemAtPosition(i);
                    Gson gson = new Gson();
                    String ticketJson = gson.toJson(ticket);

                    Intent intent = new Intent(getActivity().getApplicationContext(), TicketActivity.class);
                    intent.putExtra("ticket", ticketJson);
                    startActivity(intent);
                }
            });

            //add the list view to the layout
            layout.addView(listView);
            ticketsAdapter.notifyDataSetChanged();
        }
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
