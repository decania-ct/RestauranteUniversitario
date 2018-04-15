package br.ufrj.ct.restauranteuniversitario;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import java.util.ArrayList;

/**
 * Created by Felipe Podolan Oliveira on 20/03/17.
 * This Adapter extends the BaseAdapter in order to add elements to the ListView in the SearchResultFragment.
 */

public class TicketsListAdapter extends BaseAdapter {

    /**
     * The context of the application
     */
    private Context context;
    /**
     * The array containing the items to be placed in each view
     */
    private ArrayList<Ticket> ticketsList = new ArrayList<>();

    /**
     * Constructor
     * @param context the context of the application
     * @param ticketsList the array list of items to be placed in each view
     */
    public TicketsListAdapter(Context context, ArrayList<Ticket> ticketsList) {
        this.context = context;
        this.ticketsList = ticketsList;
    }

    /**
     * This method gets the number of items
     * @return int with the number of items
     */
    @Override
    public int getCount() {
        return ticketsList.size();
    }

    /**
     * This method gets an item within a particular index
     * @param index the index of the item to be gotten
     * @return Object of the item gotten
     */
    @Override
    public Object getItem(int index) {
        return ticketsList.get(index);
    }

    /**
     * This method gets the position of a item
     * @param index the position of the item
     * @return long position of the item
     */
    @Override
    public long getItemId(int index) {
        return index;
    }

    /**
     * This is the main method of the adapter. It gets each view and sets the data within its elements
     * @param position the position of the view
     * @param convertView the view itself
     * @param parent the parent of the view
     * @return View modified with the data set within it
     */
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        //get the ticket correspondent to this view
        Ticket ticket = ticketsList.get(position);

        //inflate the view
        LayoutInflater inflater = (LayoutInflater) context.getSystemService(context.LAYOUT_INFLATER_SERVICE);
        View view = inflater.inflate(R.layout.ticket_item, null);

        //get the view layout elements and set them with the data
        TextView attendance = (TextView) view.findViewById(R.id.ticket_item_queues_text_view);
        attendance.setText(ticket.getAttendance());

        TextView hour = (TextView) view.findViewById(R.id.ticket_item_capital_text_view);
        hour.setText(ticket.getDate_allocated());

        return view;
    }


}
