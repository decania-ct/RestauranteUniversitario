package br.ufrj.ct.restauranteuniversitario;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;

/**
 * Created by felipe on 07/08/17.
 */

public class OptionsAdapter extends BaseAdapter {
    ArrayList<String> result;
    ArrayList<Drawable> images;
    Context context;

    private static LayoutInflater inflater = null;

    public OptionsAdapter(Context context, ArrayList<String> items, ArrayList<Drawable> images) {
        result = items;
        this.images = images;
        this.context = context;
        inflater = ( LayoutInflater )context.
                getSystemService(Context.LAYOUT_INFLATER_SERVICE);

    }

    @Override
    public int getCount() {
        return result.size();
    }

    @Override
    public Object getItem(int index) {
        return result.get(index);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    public class Holder {
        ImageView image;
        TextView text;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        Holder holder = new Holder();
        View rowView;

        //inflates the grid element which is the view_item layout
        rowView = inflater.inflate(R.layout.options_item, null);

        //text view within view_item layout
        holder.image = (ImageView) rowView.findViewById(R.id.options_iv);
        holder.text =  (TextView) rowView.findViewById(R.id.options_tv);
        holder.image.setImageDrawable(images.get(position));
        holder.text.setText(result.get(position));

        return rowView;
    }
}
