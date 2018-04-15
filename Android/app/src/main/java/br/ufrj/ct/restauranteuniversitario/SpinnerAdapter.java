package br.ufrj.ct.restauranteuniversitario;

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.ArrayList;

/**
 * Created by Felipe Podolan Oliveira on 31/10/17.
 * This class handles the spinner adapter for both the TicketAllocatorFragment and the
 * TicketSearcherFragment.
 */

public class SpinnerAdapter extends ArrayAdapter<String> {

    /**
     * The context of the application
     */
    Context context;
    /**
     * the array list of the items' data within the spinner
     */
    private ArrayList<String> items = new ArrayList<>();

    /**
     * SpinnerAdapter constructor
     * @param context the context of the application
     * @param textViewResourceId the text view resource id
     * @param items the array list of the items' data for the spinner
     */
    public SpinnerAdapter(final Context context, final int textViewResourceId, final ArrayList<String> items) {
        super(context, textViewResourceId, items);
        this.items = items;
        this.context = context;
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
        if (convertView == null) {
            LayoutInflater inflater = LayoutInflater.from(context);
            convertView = inflater.inflate(R.layout.spinner_item, parent, false);
        }

        //AutofitTextView is an added library that makes the text changes its font size to fit in the deveice screen
        TextView tv = (TextView) convertView.findViewById(R.id.spinner_item_text_view);
        tv.setText(items.get(position));
        tv.setTextColor(Color.parseColor("#000000"));
        return convertView;
    }
}
