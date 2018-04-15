package br.ufrj.ct.restauranteuniversitario;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.ActivityInfo;
import android.graphics.Bitmap;
import android.support.v4.app.FragmentManager;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.Toast;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.ImageRequest;
import com.google.gson.Gson;

import me.grantland.widget.AutofitTextView;

public class TicketActivity extends AppCompatActivity {

    /**
     * The ticket object whose data is going to be displayed
     */
    private Ticket ticket;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_ticket);

        //get the layout elements
        AutofitTextView date = (AutofitTextView) findViewById(R.id.ticket_date_allocated_text_view);
        AutofitTextView attendance = (AutofitTextView) findViewById(R.id.ticket_attendance_text_view);
        AutofitTextView CPF = (AutofitTextView) findViewById(R.id.ticket_identity_text_view);
        final ImageView imageView = (ImageView) findViewById(R.id.ticket_photo_image_view);
        ImageView QRCodeIV = (ImageView) findViewById(R.id.ticket_QRCode_image_view);
        Bitmap QRCode = null;

        //the fragment is destroyed and recreated, thus we need to get the ticket from the Gson stored in the device
        if(ticket == null) {
            Gson gson = new Gson();
            Intent intent = getIntent();
            String ticketJson = intent.getStringExtra("ticket");
            Log.i("TicketFragment", ticketJson);
            ticket = gson.fromJson(ticketJson, Ticket.class);
            String ticketId = ticket.getTicketId();
            SharedPreferences sharedPref2 =
                    getSharedPreferences(getString(R.string.cancel_token_preference), Context.MODE_PRIVATE);
            String cancelToken = sharedPref2.getString(ticketId, "");
            ticket.setCancel_token(cancelToken);
        }

        //now that it is certain that the ticket isn't null
        if(ticket != null) {

            //prepare the request to get the user_photo from SIGA. So far, only the url is stored
            ImageRequest imageRequest = new ImageRequest(ticket.getFoto(), new Response.Listener<Bitmap>() {
                @Override
                public void onResponse(Bitmap response) {
                    DisplayMetrics metrics = new DisplayMetrics();
                    getWindowManager().getDefaultDisplay().getMetrics(metrics);
                    double width = (metrics.widthPixels) * 0.30 ;
                    double height = (double)response.getHeight() / (double) response.getWidth() * width;
                    Bitmap resized = Bitmap.createScaledBitmap(response,
                            (int)(width), (int)(height), true);
                    imageView.setImageBitmap(resized);
                }
            }, 0, 0, ImageView.ScaleType.CENTER_CROP, null, new Response.ErrorListener() {
                @Override
                public void onErrorResponse(VolleyError error) {
                    Log.i("Result Schedule", error.toString());
                }
            });
            //send the request to SIGA
            RUSingleton.getmInstance(this).addToRequestQueue(imageRequest);

            //set the layout elements data
            date.setText(ticket.getDate_allocated());
            attendance.setText(ticket.getAttendance());
            CPF.setText(ticket.getUser_id());

            //handle the QR Code
            DisplayMetrics metrics = new DisplayMetrics();
            getWindowManager().getDefaultDisplay().getMetrics(metrics);
            double size = (metrics.heightPixels) * 0.35 ;
            QRCode = AppUtility.encodeAsBitmap(ticket.getUser_id() + "--" + ticket.getQueue_id()
                    + "--" + ticket.getTicketId(), (int) size);
            QRCodeIV.setImageBitmap(QRCode);
        }

        //get the cancel image view
        ImageView cancelIV = (ImageView) findViewById(R.id.ticket_delete_image_view);
        //add a click listener to the cancel image view
        cancelIV.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                //create a dialog to ensure that the user wants to delete the ticket
                AlertDialog.Builder builder = new AlertDialog.Builder(TicketActivity.this);
                builder.setTitle(getString(R.string.ticket_dialog_delete_ticket_title));
                builder.setMessage(getString(R.string.ticket_dialog_delete_ticket_message));
                builder.setCancelable(true);
                builder.setPositiveButton(
                        getString(R.string.dialog_yes_option),
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int id) {
                                if(ticket.getCancel_token().isEmpty()) {
                                    Toast.makeText(getApplicationContext(), getString(R.string.toast_cancel_in_other_device_message), Toast.LENGTH_LONG).show();
                                }
                                else {
                                    //Call the API updateStatus method
                                    API.updateStatus(Ticket.statusEnum.CANCELED, getApplicationContext(), ticket, new API.TicketUpdaterCallback() {
                                        //if the response code is 200
                                        @Override
                                        public void onSuccess(Ticket.statusEnum status) {
                                            //go to ticket search fragment
                                            //FragmentManager ft = getSupportFragmentManager();
                                            //ft.popBackStack();
                                            Intent intent = new Intent(getApplicationContext(), MainActivity.class);
                                            startActivity(intent);

                                            //make a toast with the ticket status
                                            Toast.makeText(getApplicationContext(), getString(R.string.toast_update_ticket_status_canceled_message),
                                                    Toast.LENGTH_LONG).show();
                                        }

                                        //if the response is an error
                                        @Override
                                        public void onError(String errorMessage) {
                                            Toast.makeText(getApplicationContext(), errorMessage, Toast.LENGTH_LONG).show();
                                        }
                                    });
                                }
                            }
                        });
                builder.setNegativeButton(
                        getString(R.string.dialog_no_option),
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int id) {
                                dialog.cancel();
                            }
                        });
                AlertDialog alert = builder.create();
                alert.show();
            }
        });
    }
}
