package br.ufrj.ct.restauranteuniversitario;

import android.content.Context;
import android.content.pm.ActivityInfo;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.app.AppCompatActivity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Spinner;
import android.widget.TextView;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Locale;


/**
 * Fragment for the initial screen that displays the week menu of the restaurant
 */
public class MenuFragment extends Fragment {

    private Spinner hourOptions;
    private Spinner weekdaysOptions;
    private Spinner ouOptions;

    private TextView entrance;
    private TextView mainDish;
    private TextView vegetarianDish;
    private TextView guarnicao;
    private TextView sideDish;
    private TextView desert;
    private TextView drink;

    private String selectedWeekday = "";
    private String selectedOption = "";
    private String selectedOu = "";

    public MenuFragment() {
        // Required empty public constructor
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_menu, container, false);
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        hourOptions = (Spinner) getActivity().findViewById(R.id.menu_options);
        weekdaysOptions = (Spinner) getActivity().findViewById(R.id.menu_weekdays);
        ouOptions = (Spinner) getActivity().findViewById(R.id.menu_ou_spinner);
        entrance = (TextView) getActivity().findViewById(R.id.menu_entrance_et);
        mainDish = (TextView) getActivity().findViewById(R.id.menu_maindish_et);
        vegetarianDish = (TextView) getActivity().findViewById(R.id.menu_vegetariandish_et);
        guarnicao = (TextView) getActivity().findViewById(R.id.menu_guarnicao_et);
        sideDish = (TextView) getActivity().findViewById(R.id.menu_sidedish_et);
        desert = (TextView) getActivity().findViewById(R.id.menu_desert_et);
        drink = (TextView) getActivity().findViewById(R.id.menu_drink_et);

        DateFormat format = new SimpleDateFormat("dd/MM/yyyy EEE", new Locale("pt", "BR"));
        Calendar calendar = Calendar.getInstance();
        calendar.setFirstDayOfWeek(Calendar.SUNDAY);
        calendar.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);

        Calendar today = Calendar.getInstance();

        int index = 0;
        ArrayList<String> days = new ArrayList<>();
        for (int i = 0; i < 7; i++) {
            if (calendar.getTime().toString().equals(today.getTime().toString())) {
                index = i;
            }
            days.add( AppUtility.capitalize(format.format(calendar.getTime())) );
            calendar.add(Calendar.DAY_OF_MONTH, 1);
        }

        ArrayList<String> hours = new ArrayList<>();
        hours.add("Almoço");
        hours.add("Jantar");

        ArrayList<String> ous = new ArrayList<>();
        ous.add("CT");
        ous.add("Letras");
        ous.add("Central");

        final ArrayAdapter<String> weekdaysAdapter = new ArrayAdapter<>(getContext(), android.R.layout.simple_spinner_item, days);
        weekdaysOptions.setAdapter(weekdaysAdapter);
        weekdaysAdapter.notifyDataSetChanged();
        weekdaysOptions.setSelection(index);

        final ArrayAdapter<String> hoursAdapter = new ArrayAdapter<>(getContext(), android.R.layout.simple_spinner_item, hours);
        hourOptions.setAdapter(hoursAdapter);
        hoursAdapter.notifyDataSetChanged();

        final ArrayAdapter<String> ousAdapter = new ArrayAdapter<>(getContext(), android.R.layout.simple_spinner_item, ous);
        ouOptions.setAdapter(ousAdapter);
        ousAdapter.notifyDataSetChanged();

        selectedWeekday = weekdaysOptions.getSelectedItem().toString();
        selectedOption = hourOptions.getSelectedItem().toString();
        selectedOu = ouOptions.getSelectedItem().toString();
        loadData();

        weekdaysOptions.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                selectedWeekday = adapterView.getItemAtPosition(i).toString();
                loadData();
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });

        hourOptions.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                selectedOption = adapterView.getSelectedItem().toString();
                loadData();
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });

        ouOptions.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                selectedOu = adapterView.getSelectedItem().toString();
                loadData();
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });

    }

    private void loadData() {
        entrance.setText(selectedWeekday + " - " + selectedOption + " - " + selectedOu);
        mainDish.setText(selectedWeekday + " - " + selectedOption + " - " + selectedOu);
        vegetarianDish.setText(selectedWeekday + " - " + selectedOption + " - " + selectedOu);
        guarnicao.setText(selectedWeekday + " - " + selectedOption + " - " + selectedOu);
        sideDish.setText(selectedWeekday + " - " + selectedOption + " - " + selectedOu);
        desert.setText(selectedWeekday + " - " + selectedOption + " - " + selectedOu);
        drink.setText(selectedWeekday + " - " + selectedOption + " - " + selectedOu);
    }

    /**
     * This method is called when the fragment is resumed
     */
    @Override
    public void onResume() {
        super.onResume();
        ((AppCompatActivity)getActivity()).getSupportActionBar().setTitle(getActivity().getString(R.string.app_main_label));
    }
}
