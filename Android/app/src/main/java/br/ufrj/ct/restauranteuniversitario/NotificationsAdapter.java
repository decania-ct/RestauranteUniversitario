package br.ufrj.ct.restauranteuniversitario;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;

/**
 * Created by felipe on 08/08/17.
 */

public class NotificationsAdapter extends BaseAdapter {

    ArrayList<String> result;
    private static LayoutInflater inflater = null;

    public NotificationsAdapter(Context context, ArrayList<String> items) {
        result = items;
        inflater = (LayoutInflater)context.
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
        TextView title;
        ImageView imageView;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        final NotificationsAdapter.Holder holder = new NotificationsAdapter.Holder();

        //inflates the grid element which is the view_item layout
        convertView = inflater.inflate(R.layout.notifications_item, null);

        //text view within view_item layout
        holder.title = (TextView) convertView.findViewById(R.id.notifications_item_tv);
        holder.title.setText(result.get(position));

        holder.imageView = (ImageView) convertView.findViewById(R.id.notifications_item_iv);
        holder.imageView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                result.remove(position);
                notifyDataSetChanged();
            }
        });


        return convertView;
    }
}
