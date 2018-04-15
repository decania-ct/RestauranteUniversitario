package br.ufrj.ct.restauranteuniversitario;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import java.util.ArrayList;

/**
 * Created by Felipe Podolan Oliveira.
 * This Adapter extends the BaseAdapter in order to add grid elements to the GridView in the QueuesFragment.
 */
public class QueuesAdapter extends BaseAdapter {

    /**
     * The array containing the items to be placed in each view
     */
    private ArrayList<String[]> items;
    /**
     * The context of the application
     */
    Context context;
    /**
     * the layout inflater to inflate each items layout
     */
    private static LayoutInflater inflater = null;

    /**
     * Constructor
     * @param context the context of the application
     * @param items the array list of items to be placed in each view
     */
    public QueuesAdapter(Context context, ArrayList<String[]> items) {
        this.items = items;
        this.context = context;
        inflater = ( LayoutInflater )context.
                getSystemService(Context.LAYOUT_INFLATER_SERVICE);

    }

    /**
     * This method gets the number of items
     * @return int with the number of items
     */
    @Override
    public int getCount() {
        return items.size();
    }

    /**
     * This method gets an item within a particular index
     * @param index the index of the item to be gotten
     * @return Object of the item gotten
     */
    @Override
    public Object getItem(int index) {
        return items.get(index);
    }

    /**
     * This method gets the position of a item
     * @param position the position of the item
     * @return long position of the item
     */
    @Override
    public long getItemId(int position) {
        return position;
    }

    /**
     * This inner class is used to facilitate the setting of the data in the layout
     */
    public class Holder {
        TextView data;
        TextView statistics;
        TextView description;
    }

    /**
     * This is the main method of the adapter. It gets each view and sets the data within its elements
     * @param position the position of the view
     * @param convertView the view itself
     * @param parent the parent of the view
     * @return View modified with the data set within it
     */
    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        Holder holder = new Holder();
        View rowView;

        //inflates the grid element which is the queues_item layout
        rowView = inflater.inflate(R.layout.queues_item, null);

        //get each text view within queues_item layout
        holder.data = (TextView) rowView.findViewById(R.id.queues_item_data_text_view);
        holder.statistics =  (TextView) rowView.findViewById(R.id.queues_item_statistics_text_view);
        holder.description =  (TextView) rowView.findViewById(R.id.view_item_description_text_view);
        //set the data on each text view
        holder.data.setText(items.get(position)[0]);
        holder.statistics.setText(items.get(position)[1]);
        holder.description.setText(items.get(position)[2]);

        return rowView;
    }

}