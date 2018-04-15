package br.ufrj.ct.restauranteuniversitario;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import java.util.ArrayList;

/**
 * Created by Felipe Podolan Oliveira on 08/08/17.
 */

public class HoursAdapter extends BaseAdapter  {

    ArrayList<String[]> result;
    private static LayoutInflater inflater = null;

    public HoursAdapter(Context context, ArrayList<String[]> items) {
        result = items;
        inflater = (LayoutInflater)context.
                getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }

    @Override
    public int getCount() {
        return result.size();
    }

    @Override
    public Object getItem(int position) {
        return position;
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    public class Holder {
        TextView title;
        TextView week;
        TextView weekend;
        TextView values;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        Holder holder = new Holder();
        View rowView;

        //inflates the grid element which is the view_item layout
        rowView = inflater.inflate(R.layout.hours_item, null);

        //text view within view_item layout
        holder.title = (TextView) rowView.findViewById(R.id.hours_title);
        holder.week = (TextView) rowView.findViewById(R.id.hours_week);
        holder.weekend =  (TextView) rowView.findViewById(R.id.hours_weekend);
        holder.values = (TextView) rowView.findViewById(R.id.hours_pricing);
        holder.title.setText(result.get(position)[0]);
        holder.week.setText(result.get(position)[1]);
        holder.weekend.setText(result.get(position)[2]);
        holder.values.setText(result.get(position)[3]);

        return rowView;
    }
}
