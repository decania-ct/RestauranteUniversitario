package br.ufrj.ct.restauranteuniversitario;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.os.Build;
import android.text.Editable;
import android.text.TextWatcher;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.Switch;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

/**
 * Created by Felipe Podolan Oliveira on 21/07/17.
 * This class provides utilities for the application that might be used by all classes
 */

public class AppUtility {

    /**
     * This method retrieves the user identity that is saved in the device (if there is any) and
     * sets the identity edit text with that identity. It is used in the TicketAllocatorFragment
     * and in the TicketSearcherFragment
     * @param editTextId the edit text to set with the identity
     * @param switchSaveIdentity the switch to set checked if the identity isn't empty every time
     *                           that the fragment is created
     * @param activity the application context/activity
     */
    public static void retrieveSavedIdentity(EditText editTextId, Switch switchSaveIdentity, Activity activity) {
        SharedPreferences sharedPref = activity.getPreferences(Context.MODE_PRIVATE);
        //retrieve ID if saved
        String saved_CPF = sharedPref.getString(activity.getString(R.string.saved_Id), "");
        editTextId.setText(saved_CPF);
        //if there's an ID saved, set the switch to true (default is always off)
        if(!saved_CPF.isEmpty()) {
            switchSaveIdentity.setChecked(true);
        }
    }

    /**
     * This method saves the identity typed in the edit text of either the TicketAllocatorFragment or the
     * TicketSearcherFragment if the switch is checked
     * @param editTextId the edit text in which the identity is being typed
     * @param switchSaveIdentity the switch that gives a condition to save the identity or not
     * @param activity the application context/activity
     */
    public static void saveIdentity(final EditText editTextId, final Switch switchSaveIdentity, final Activity activity) {

        SharedPreferences sharedPref = activity.getPreferences(Context.MODE_PRIVATE);
        final SharedPreferences.Editor editor = sharedPref.edit();

        //add listener to editText to save the identity
        editTextId.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            //save the text every time that something is typed in the edit text
            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                if(switchSaveIdentity.isChecked()) {
                    editor.putString(activity.getString(R.string.saved_Id), charSequence.toString());
                    editor.commit();
                }
            }

            @Override
            public void afterTextChanged(Editable editable) {

            }
        });

        //add listener to the switch
        switchSaveIdentity.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton compoundButton, boolean isChecked) {
                //save identity if switch changes to checked
                if(isChecked) {
                    editor.putString(activity.getString(R.string.saved_Id), editTextId.getText().toString());
                }
                //replace the saved identity with an empty string if the switch changes to not checked
                else {
                    editor.putString(activity.getString(R.string.saved_Id), "");
                }
                editor.commit();
            }
        });
    }

    /**
     * This method gets the current device name defined as the manufacturer plus the phone model
     * @return String with the device name
     */
    public static String getDeviceName() {
        String manufacturer = Build.MANUFACTURER;
        String model = Build.MODEL;
        if (model.startsWith(manufacturer)) {
            return capitalize(model);
        }
        return capitalize(manufacturer) + " " + model;
    }

    /**
     * This method receives a string date with a format used by the backend
     * and puts it in the format desired to be shown in the frontend
     * @param inputDate the string with the date to be formatted
     * @return String with the formatted date
     */
    public static String formatDate(String inputDate) {
        String outputDate = "";
        //creates a simple date format object with the backend format
        Locale pt_br = new Locale("pt","BR");
        SimpleDateFormat sfm = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZZZZZ", pt_br);
        sfm.setTimeZone(TimeZone.getTimeZone("Brazil/East"));
        try {
            //creates a date object using the sfm object
            Date date = sfm.parse(inputDate);
            //changes the sfm object to the frontend desired format
            sfm = new SimpleDateFormat("dd/MM/yyyy HH:mm", pt_br);
            sfm.setTimeZone(TimeZone.getTimeZone("Brazil/East"));
            //format the date to a string
            String dateStr = sfm.format(date);
            outputDate = dateStr + "h";
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return outputDate;
    }

    /**
     * This method gets a String to be encoded as a QRCode bitmap of a given size
     * @param str the string to be encoded
     * @param size the size of the returned bitmap
     * @return Bitmap of a QRCode that encodes the given String
     */
    public static Bitmap encodeAsBitmap(String str, int size)  {
        //hexadecimal of white color
        final int WHITE = 0xFFFFFFFF;
        //hexadecimal of black color
        final int BLACK = 0xFF000000;

        //created a bit matrix of the qr code
        BitMatrix result = null;
        try {
            result = new MultiFormatWriter().encode(str, BarcodeFormat.QR_CODE, size, size, null);
        } catch (IllegalArgumentException iae) {
            // Unsupported format
            return null;
        } catch (WriterException e) {
            e.printStackTrace();
        }

        //convert the bit matrix to a pixel array of WHITE's and BLACK's integers
        int width = result.getWidth();
        int height = result.getHeight();
        int[] pixels = new int[width * height];
        for (int y = 0; y < height; y++) {
            int offset = y * width;
            for (int x = 0; x < width; x++) {
                pixels[offset + x] = result.get(x, y) ? BLACK : WHITE;
            }
        }

        //create the bitmap from the pixel array
        Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        bitmap.setPixels(pixels, 0, width, 0, 0, width, height);
        return bitmap;
    }

    /**
     * Resize a Bitmap to a given width keeping its aspect ratio
     * @param input the Bitmap to be resized
     * @param width the width of the returned Bitmap
     * @return Bitmap resized to the given width keeping the original aspect ratio
     */
    public static Bitmap resizeImage(Bitmap input, double width) {
        //create scale factor
        double oldWidth = input.getWidth();
        double oldHeight = input.getHeight();
        double newHeight = oldHeight * (width/oldWidth);
        //resize bitmap
        Bitmap output = Bitmap.createScaledBitmap(input,
                (int)(width), (int)(newHeight), true);
        return output;
    }

    /**
     * method to captalize a String
     * @param line the String to be captalized
     * @return String captalized of the given String
     */
    public static String capitalize(final String line) {
        char[] chars = line.toCharArray();
        boolean found = false;
        for (int i = 0; i < chars.length; i++) {
            if (!found && Character.isLetter(chars[i])) {
                chars[i] = Character.toUpperCase(chars[i]);
                found = true;
            } else if (Character.isWhitespace(chars[i]) || chars[i]=='.' || chars[i]=='\'') {
                found = false;
            }
        }
        return String.valueOf(chars);
    }
}
