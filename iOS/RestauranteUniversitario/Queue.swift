import UIKit

/**
 This is the Queue class, with same attributes as the backend.
 */

class Queue {
    /**
     * The current status of the queue
     */
    var status: String
    
    /**
     * The tolerance of the queue
     */
   var tolerance: String
    
    /**
     * The type of the queue
     */
    var type: String
    
    /**
     * The ou where the queue is allocated
     */
    var ou: String
    
    /**
     * The amount of billed tickets of the queue
     */
    var billed_tickets: String
    
    /**
     * The amount of cancelled tickets of the queue
     */
    var canceled_tickets: String
    
    /**
     * The capacity of the queue
     */
    var capacity: String
    
    /**
     * The amount of closed tickets of the queue
     */
    var closed_tickets: String
    
    /**
     * The amount of created tickets for the queue
     */
    var created_tickets: String
    
    /**
     * The date when the queue was created
     */
    var date_created: String
    
    /**
     * The date when the queue was deleted
     */
    var date_deleted: String
    
    /**
     * The date when the queue was/will be ended
     */
    var date_end: String
    
    /**
     * The date when the queue was last deleted
     */
    var date_modified: String
    
    /**
     * The date when the queue was/will be opened
     */
    var date_open: String
    
    /**
     * The date when the queue was/will be started
     */
    var date_start: String
    
    /**
     * The delay of the queue
     */
    var delay: String
    
    /**
     * The description of the queue
     */
    var description: String
    
    /**
     * The amount of expired tickets of the queue
     */
    var expired_tickets: String
    
    /**
     * The id of the queue
     */
    var id_queues: String
    
    /**
     * The amount of issued tickets of the queue
     */
    var issued_tickets: String
    
    /**
     * The current quantity of tickets of the queue
     */
    var qtd: String
    
    /**
     * The attendance string of the queue
     * This field doesn't come from the backend
     */
    var attendance: String
    
    /**
     * The statistics of the queue
     */
    var statistics = [Statistic]()
    
    /**
     Empty constructor
     */
    init() {
        self.status = ""
        tolerance = ""
        type = ""
        ou = ""
        billed_tickets = ""
        canceled_tickets = ""
        capacity = ""
        closed_tickets = ""
        created_tickets = ""
        date_created = ""
        date_deleted = ""
        date_end = ""
        date_modified = ""
        date_open = ""
        date_start = ""
        delay = ""
        description = ""
        expired_tickets = ""
        id_queues = ""
        issued_tickets = ""
        qtd = ""
        attendance = ""
        statistics = [Statistic]()
    }
}
