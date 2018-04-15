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
import android.widget.ListView;

import java.util.ArrayList;


/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link HoursFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link HoursFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class HoursFragment extends Fragment {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;

    private OnFragmentInteractionListener mListener;

    public HoursFragment() {
        // Required empty public constructor
    }

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment HoursFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static HoursFragment newInstance(String param1, String param2) {
        HoursFragment fragment = new HoursFragment();
        Bundle args = new Bundle();
        args.putString(ARG_PARAM1, param1);
        args.putString(ARG_PARAM2, param2);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            mParam1 = getArguments().getString(ARG_PARAM1);
            mParam2 = getArguments().getString(ARG_PARAM2);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_hours, container, false);
    }

    // TODO: Rename method, update argument and hook method into UI event
    public void onButtonPressed(Uri uri) {

    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        final ListView listView = (ListView) getActivity().findViewById(R.id.hours_listView);
        ArrayList<String[]> list = new ArrayList<>();
        String[] option1 = {"RU CENTRAL", "Almoço: 11:30h às 14:00h\nJantar: 17:30h às 20:00h",
                "Almoço: 12:00h às 14:00h\nJantar: 17:00h às 19:15h",
        "Alunos da UFRJ: R$ 2,00\nServidores da UFRJ: R$ 6,00"};
        list.add(option1);

        String[] option2 = {"RU CT", "Almoço: 11:30h às 14:00h\nJantar: 17:30h às 20:00h",
                "Almoço: 12:00h às 14:00h\nJantar: 17:00h às 19:15h",
                "Alunos da UFRJ: R$ 2,00\nServidores da UFRJ: R$ 6,00"};
        list.add(option2);

        String[] option3 = {"RU Letras", "Almoço: 11:30h às 14:00h\nJantar: 17:30h às 20:00h",
                "Almoço: 12:00h às 14:00h\nJantar: 17:00h às 19:15h",
                "Alunos da UFRJ: R$ 2,00\nServidores da UFRJ: R$ 6,00"};
        list.add(option3);

        String[] option4 = {"RU IFCS/PV", "Almoço: 11:30h às 14:00h\nJantar: 17:30h às 20:00h",
                "Almoço: 12:00h às 14:00h\nJantar: 17:00h às 19:15h",
                "Alunos da UFRJ: R$ 2,00\nServidores da UFRJ: R$ 6,00"};
        list.add(option4);

        HoursAdapter adapter = new HoursAdapter(getActivity(), list);
        listView.setAdapter(adapter);
    }


    /**
     * This interface must be implemented by activities that contain this
     * fragment to allow an interaction in this fragment to be communicated
     * to the activity and potentially other fragments contained in that
     * activity.
     * <p>
     * See the Android Training lesson <a href=
     * "http://developer.android.com/training/basics/fragments/communicating.html"
     * >Communicating with Other Fragments</a> for more information.
     */
    public interface OnFragmentInteractionListener {
        // TODO: Update argument type and name
        void onFragmentInteraction(Uri uri);
    }

    /**
     * This method is called when the fragment is resumed
     */
    @Override
    public void onResume() {
        super.onResume();
        ((AppCompatActivity)getActivity()).getSupportActionBar().setTitle(getActivity().getString(R.string.options));
    }
}
