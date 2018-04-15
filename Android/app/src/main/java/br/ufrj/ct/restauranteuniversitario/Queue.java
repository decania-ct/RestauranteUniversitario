package br.ufrj.ct.restauranteuniversitario;

import com.google.gson.Gson;

import java.util.ArrayList;

/**
 * Created by felipe on 06/12/2017.
 * This is the Queue class, with same attributes as the backend.
 * The attributes are named in a manner that it facilitates the conversion
 * of a Queue object and a queue json (received from the backend) by using
 * the Gson library.
 */

public class Queue {
    /**
     * The current status of the queue
     */
    private String status;

    /**
     * The tolerance of the queue
     */
    private String tolerance;

    /**
     * The type of the queue
     */
    private String type;

    /**
     * The ou where the queue is allocated
     */
    private String ou;

    /**
     * The amount of billed tickets of the queue
     */
    private String billed_tickets;

    /**
     * The amount of cancelled tickets of the queue
     */
    private String canceled_tickets;

    /**
     * The capacity of the queue
     */
    private String capacity;

    /**
     * The amount of closed tickets of the queue
     */
    private String closed_tickets;

    /**
     * The amount of created tickets for the queue
     */
    private String created_tickets;

    /**
     * The date when the queue was created
     */
    private String date_created;

    /**
     * The date when the queue was deleted
     */
    private String date_deleted;

    /**
     * The date when the queue was/will be ended
     */
    private String date_end;

    /**
     * The date when the queue was last deleted
     */
    private String date_modified;

    /**
     * The date when the queue was/will be opened
     */
    private String date_open;

    /**
     * The date when the queue was/will be started
     */
    private String date_start;

    /**
     * The delay of the queue
     */
    private String delay;

    /**
     * The description of the queue
     */
    private String description;

    /**
     * The amount of expired tickets of the queue
     */
    private String expired_tickets;

    /**
     * The id of the queue
     */
    private String id_queues;

    /**
     * The amount of issued tickets of the queue
     */
    private String issued_tickets;

    /**
     * The current quantity of tickets of the queue
     */
    private String qtd;

    /**
     * The attendance string of the queue
     * This field doesn't come from the backend
     */
    private String attendance;

    /**
     * The statistics of the queue
     */
    private ArrayList<Statistic> statistics;

    /**
     * Empty constructor
     */
    public Queue() {

    }

    /**
     * This method gets the status
     * @return String of the status
     */
    public String getStatus() {
        return status;
    }

    /**
     * This method gets the tolerance
     * @return String of the tolerance
     */
    public String getTolerance() {
        return tolerance;
    }

    /**
     * This method gets the type
     * @return String of the type
     */
    public String getType() {
        return type;
    }

    /**
     * This method gets the ou
     * @return String of the ou
     */
    public String getOu() {
        return ou;
    }

    /**
     * This method gets the amount of billed tickets
     * @return String of the amount of billed tickets
     */
    public String getBilled_tickets() {
        return billed_tickets;
    }

    /**
     * This method gets the amount of cancelled tickets
     * @return String of the amount of cancelled tickets
     */
    public String getCanceled_tickets() {
        return canceled_tickets;
    }

    /**
     * This method gets the capacity
     * @return String of the capacity
     */
    public String getCapacity() {
        return capacity;
    }

    /**
     * This method gets the amount of closed tickets
     * @return String of the amount of closed tickets
     */
    public String getClosed_tickets() {
        return closed_tickets;
    }

    /**
     * This method gets the amount of created tickets
     * @return String of the amount of created tickets
     */
    public String getCreated_tickets() {
        return created_tickets;
    }

    /**
     * This method gets the date created
     * @return String of the date created
     */
    public String getDate_created() {
        return date_created;
    }

    /**
     * This method gets the date deleted
     * @return String of the date deleted
     */
    public String getDate_deleted() {
        return date_deleted;
    }

    /**
     * This method gets the date end
     * @return String of the date end
     */
    public String getDate_end() {
        return date_end;
    }

    /**
     * This method gets the date modified
     * @return String of the date modified
     */
    public String getDate_modified() {
        return date_modified;
    }

    /**
     * This method gets the date open
     * @return String of the date open
     */
    public String getDate_open() {
        return date_open;
    }

    /**
     * This method gets the date start
     * @return String of the date start
     */
    public String getDate_start() {
        return date_start;
    }

    /**
     * This method gets the delay
     * @return String of the delay
     */
    public String getDelay() {
        return delay;
    }

    /**
     * This method gets the description
     * @return String of the description
     */
    public String getDescription() {
        return description;
    }

    /**
     * This method gets the amount of expired tickets
     * @return String of the amount of expired tickets
     */
    public String getExpired_tickets() {
        return expired_tickets;
    }

    /**
     * This method gets the id
     * @return String of the id
     */
    public String getId_queues() {
        return id_queues;
    }

    /**
     * This method gets the amount of issued tickets
     * @return String of the amount of issued tickets
     */
    public String getIssued_tickets() {
        return issued_tickets;
    }

    /**
     * This method gets the quantity of tickets
     * @return String of the quantity of tickets
     */
    public String getQtd() {
        return qtd;
    }

    /**
     * This method gets the attendance
     * @return String of the attendance
     */
    public String getAttendance() {
        return attendance;
    }

    /**
     * This method gets the statistics
     * @return JSONArray of the statistics
     */
    public ArrayList<Statistic> getStatistics() {
        return statistics;
    }

    /**
     * This method sets the status of the queue
     * @param status the status to be set
     */
    public void setStatus(String status) {
        this.status = status;
    }

    /**
     * This method sets the tolerance of the queue
     * @param tolerance the tolerance to be set
     */
    public void setTolerance(String tolerance) {
        this.tolerance = tolerance;
    }

    /**
     * This method sets the type of the queue
     * @param type the type to be set
     */
    public void setType(String type) {
        this.type = type;
    }

    /**
     * This method sets the ou of the queue
     * @param ou the ou to be set
     */
    public void setOu(String ou) {
        this.ou = ou;
    }

    /**
     * This method sets the amount of billed tickets of the queue
     * @param billed_tickets the the amount of billed tickets to be set
     */
    public void setBilled_tickets(String billed_tickets) {
        this.billed_tickets = billed_tickets;
    }

    /**
     * This method sets the amount of cancelled tickets of the queue
     * @param canceled_tickets the amount of cancelled tickets to be set
     */
    public void setCanceled_tickets(String canceled_tickets) {
        this.canceled_tickets = canceled_tickets;
    }

    /**
     * This method sets the capacity of the queue
     * @param capacity the capacity to be set
     */
    public void setCapacity(String capacity) {
        this.capacity = capacity;
    }

    /**
     * This method sets the amount of closed tickets of the queue
     * @param closed_tickets the the amount of closed tickets to be set
     */
    public void setClosed_tickets(String closed_tickets) {
        this.closed_tickets = closed_tickets;
    }

    /**
     * This method sets the amount of created tickets of the queue
     * @param created_tickets the amount of created tickets to be set
     */
    public void setCreated_tickets(String created_tickets) {
        this.created_tickets = created_tickets;
    }

    /**
     * This method sets the date when the queue was created
     * @param date_created the date when the queue was created to be set
     */
    public void setDate_created(String date_created) {
        this.date_created = date_created;
    }

    /**
     * This method sets the date when the queue was deleted
     * @param date_deleted the date when the queue was deleted to be set
     */
    public void setDate_deleted(String date_deleted) {
        this.date_deleted = date_deleted;
    }

    /**
     * This method sets the date when the queue was/will be ended
     * @param date_end the date when the queue was/will be ended to be set
     */
    public void setDate_end(String date_end) {
        this.date_end = date_end;
    }

    /**
     * This method sets the date when the queue was/will be modified
     * @param date_modified the date when the queue was/will be modified to be set
     */
    public void setDate_modified(String date_modified) {
        this.date_modified = date_modified;
    }

    /**
     * This method sets the date when the queue was/will be opened
     * @param date_open the date when the queue was/will be opened to be set
     */
    public void setDate_open(String date_open) {
        this.date_open = date_open;
    }

    /**
     * This method sets the date when the queue was/will be started
     * @param date_start the date when the queue was/will be started to be set
     */
    public void setDate_start(String date_start) {
        this.date_start = date_start;
    }

    /**
     * This method sets the delay of the queue
     * @param delay the delay to be set
     */
    public void setDelay(String delay) {
        this.delay = delay;
    }

    /**
     * This method sets the description of the queue
     * @param description the description to be set
     */
    public void setDescription(String description) {
        this.description = description;
    }

    /**
     * This method sets the amount of expired tickets of the queue
     * @param expired_tickets the amount of expired tickets to be set
     */
    public void setExpired_tickets(String expired_tickets) {
        this.expired_tickets = expired_tickets;
    }

    /**
     * This method sets the id of the queue
     * @param id_queues the id to be set
     */
    public void setId_queues(String id_queues) {
        this.id_queues = id_queues;
    }

    /**
     * This method sets the amount of issued tickets of the queue
     * @param issued_tickets the amount of issued tickets to be set
     */
    public void setIssued_tickets(String issued_tickets) {
        this.issued_tickets = issued_tickets;
    }

    /**
     * This method sets the quantity of tickets of the queue
     * @param qtd the quantity of tickets to be set
     */
    public void setQtd(String qtd) {
        this.qtd = qtd;
    }

    /**
     * This method sets the attendance of the queue
     * @param attendance the attendance to be set
     */
    public void setAttendance(String attendance) {
        this.attendance = attendance;
    }

    /**
     * This method sets the statistics of the queue
     * @param statistics the statistics to be set
     */
    public void setStatistics(ArrayList<Statistic> statistics) {
        this.statistics = statistics;
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
