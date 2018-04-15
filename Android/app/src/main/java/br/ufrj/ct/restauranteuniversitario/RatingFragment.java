package br.ufrj.ct.restauranteuniversitario;

import android.content.Context;
import android.content.pm.ActivityInfo;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RatingBar;


/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link RatingFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link RatingFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class RatingFragment extends Fragment {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;

    private RatingBar appRatingBar;
    private RatingBar menuRatingBar;
    private RatingBar attendanceRatingBar;
    private EditText observations;

    private OnFragmentInteractionListener mListener;

    public RatingFragment() {
        // Required empty public constructor
    }

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment RatingFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static RatingFragment newInstance(String param1, String param2) {
        RatingFragment fragment = new RatingFragment();
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
        return inflater.inflate(R.layout.fragment_rating, container, false);
    }

    // TODO: Rename method, update argument and hook method into UI event
    public void onButtonPressed(Uri uri) {

    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        appRatingBar = (RatingBar) getActivity().findViewById(R.id.rating_appRatingBar);
        menuRatingBar = (RatingBar) getActivity().findViewById(R.id.rating_menuRatingBar);
        attendanceRatingBar = (RatingBar) getActivity().findViewById(R.id.rating_attendanceRatingBar);
        Button buttonSend = (Button) getActivity().findViewById(R.id.rating_button);
        observations = (EditText) getActivity().findViewById(R.id.rating_observationsEditText);

        appRatingBar = replaceRatingBars(appRatingBar);
        menuRatingBar = replaceRatingBars(menuRatingBar);
        attendanceRatingBar = replaceRatingBars(attendanceRatingBar);

        buttonSend.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Float appRating = appRatingBar.getRating();
                Log.i("RatingFragment APP", appRating.toString());

                Float menuRating = menuRatingBar.getRating();
                Log.i("RatingFragment MENU", menuRating.toString());

                Float attendanceRating = attendanceRatingBar.getRating();
                Log.i("RatingFragment ATTEND", attendanceRating.toString());

                Log.i("RatingFragment OBS", observations.getText().toString());
            }
        });


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

    private RatingBar replaceRatingBars(RatingBar bar) {
        ViewGroup parent = (ViewGroup) bar.getParent();
        int index = parent.indexOfChild(bar);
        parent.removeView(bar);

        RatingBar ratingBarReplacement = new CustomRatingBar(getActivity(), null);
        bar.setNumStars(5);
        ratingBarReplacement.setMax(5);

        parent.addView(ratingBarReplacement, index);
        return ratingBarReplacement;
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
