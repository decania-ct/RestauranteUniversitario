package br.ufrj.ct.restauranteuniversitario;

import com.google.gson.Gson;

/**
 * Created by Felipe Podolan Oliveira on 20/03/17.
 * This is the Ticket class, with same attributes as the backend.
 * The attributes are named in a maner that it facilitates the conversion
 * of a Ticket object and a ticket json (received from the backend) by using
 * the Gson library.
 */

public class Ticket {
    /**
     * The type of the ticket
     */
    private String type;
    /**
     * The date which the ticket has been billed
     */
    private String date_billed;
    /**
     * The date which the ticket has been canceled
     */
    private String date_canceled;
    /**
     * The date which the ticket has been closed
     */
    private String date_closed;
    /**
     * The date which the ticket has been created
     */
    private String date_created;
    /**
     * The date which the ticket has been modified
     */
    private String date_modified;
    /**
     * The date which the ticket has been requested
     */
    private String date_requested;
    /**
     * The phone number of the user who requested the ticket
     */
    private String phone_number;
    /**
     * The id of the ticket
     */
    private String id_ticket;
    /**
     * The id of the user who requested ticket
     */
    private String user_id;
    /**
     * The string attendance of the ticket (related to the queue id)
     * This field doesn't come from the backend
     */
    private String attendance;
    /**
     * The queue id which the ticket has been allocated
     */
    private String queue_id;
    /**
     * The date which the ticket has been allocated
     */
    private String date_allocated;
    /**
     * The cancel token of the ticket
     */
    private String cancel_token;
    /**
     * The message of the ticket
     */
    private String message;
    /**
     * The status of the ticket. Gson won't do this conversion automatically.
     */
    private statusEnum status;
    /**
     * The photo of the user who requested the ticket
     */
    private String foto;
    /**
     * the status enum with the possible status of a ticket
     */
    enum statusEnum {PENDING, BILLED, CANCELED, EXPIRED, CLOSED;}

    /**
     * Empty constructor. The status is automatically set to PENDING.
     */
    public Ticket() {
        this.status = statusEnum.PENDING;
    }

    /**
     * This method return the message of the ticket
     * @return String of the message of the ticket
     */
    public String getMessage(){
        return message;
    }

    /**
     * This method gets the ticket id
     * @return String of the ticket id
     */
    public String getTicketId() {
        return id_ticket;
    }

    /**
     * This method gets the user id
     * @return String of the user id
     */
    public String getUser_id() {
        return user_id;
    }

    /**
     * This method gets the queue id
     * @return String of the queue id
     */
    public String getQueue_id() {
        return queue_id;
    }

    /**
     * This method gets the date allocated
     * @return String of the date allocated
     */
    public String getDate_allocated() {
        return date_allocated;
    }

    /**
     * This method gets the attendance
     * @return String of the attendance
     */
    public String getAttendance() {
        return attendance;
    }

    /**
     * This method gets the cancel token
     * @return String of the cancel token
     */
    public String getCancel_token() {return cancel_token;}

    /**
     * This method gets the photo url
     * @return String of the photo url
     */
    public String getFoto() {
        return foto;
    }

    /**
     * This method gets the status
     * @return statusEnum of the status of the ticket
     */
    public statusEnum getStatus() {
        return status;
    }

    public void setStatus(Ticket.statusEnum status) {
        this.status = status;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public void setAttendance(String attendance) {
        String[] splitted_attendance = attendance.split("\\s+");
        String type = splitted_attendance[0];
        String ou = splitted_attendance[1];
        this.attendance = type + " " + ou;
    }

    /**
     * This method sets the queue id of the ticket
     * @param queue_id the queue_id to be set
     */
    public void setQueue_id(String queue_id) {
        this.queue_id = queue_id;
    }

    /**
     * This method sets the date allocated of the ticket
     * @param date_allocated the date allocated to be set
     */
    public void setDate_allocated(String date_allocated) {
        this.date_allocated = date_allocated;
    }

    /**
     * This method sets the cancel token of the ticket
     * @param cancel_token the cancel token to be set
     */
    public void setCancel_token(String cancel_token) {
        this.cancel_token = cancel_token;
    }

    /**
     * This method sets the message of the ticket
     * @param message the message to be set
     */
    public void setMessage(String message) {
        this.message = message;
    }

    /**
     * This method sets the id of the ticket
     * @param id_ticket the id to be set
     */
    public void setId_ticket(String id_ticket) {
        this.id_ticket = id_ticket;
    }

    /**
     * This method overrides the toString method used to convert the Ticket object to a string
     * @return String representation of the Ticket object
     */
    @Override
    public String toString() {
        Gson gson = new Gson();
        return gson.toJson(this);
    }
}
