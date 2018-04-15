/**
 * Created by Felipe Podolan Oliveira on 17/12/2017.
 * This is the Statistic class, with same attributes as the backend.
 * The attributes are named in a manner that it facilitates the conversion
 * of a Statistic object and a statistic json (received from the backend) by using
 * the Gson library.
 */

class Statistic {
    /**
     * The time window of the statistic
     */
    var time_window: String
    
    /**
     * The amount of free tickets of the statistic
     */
    var free_tickets: String
    
    /**
     Empty constructor
     */
    init() {
        self.time_window = ""
        self.free_tickets = ""
    }
}
