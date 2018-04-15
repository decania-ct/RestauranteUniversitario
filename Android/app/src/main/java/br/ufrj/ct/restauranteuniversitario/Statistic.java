package br.ufrj.ct.restauranteuniversitario;

import com.google.gson.Gson;

/**
 * Created by felipe on 17/12/2017.
 * This is the Statistic class, with same attributes as the backend.
 * The attributes are named in a manner that it facilitates the conversion
 * of a Statistic object and a statistic json (received from the backend) by using
 * the Gson library.
 */

public class Statistic {
    /**
     * The time window of the statistic
     */
    private String time_window;

    /**
     * The amount of free tickets of the statistic
     */
    private String free_tickets;

    /**
     * Empty constructor
     */
    public Statistic() {

    }

    /**
     * This method gets the time window
     * @return String of the time window
     */
    public String getTime_window() {
        return time_window;
    }

    /**
     * This method gets the free tickets
     * @return String of the free tickets
     */
    public String getFree_tickets() {
        return free_tickets;
    }

    /**
     * This method sets the time window of the statistic
     * @param time_window the time window to be set
     */
    public void setTime_window(String time_window) {
        this.time_window = time_window;
    }

    /**
     * This method sets the amount of free tickets of the statistic
     * @param free_tickets the amount of free tickets to be set
     */
    public void setFree_tickets(String free_tickets) {
        this.free_tickets = free_tickets;
    }

    /**
     * This method overrides the toString method used to convert the Queue object to a string
     * @return String representation of the Queue object
     */
    @Override
    public String toString() {
        Gson gson = new Gson();
        return gson.toJson(this);
    }
}
