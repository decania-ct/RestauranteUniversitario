//
//  Ticket.swift
//  RestauranteUniversitario
//
//  Created by Felipe Podolan Oliveira on 23/05/17.
//  Copyright © 2017 Felipe Podolan Oliveira. All rights reserved.
//

import UIKit

/**
 This is the Ticket class, with same attributes as the backend.
 */
class Ticket {
    /// The id of the ticket
    var ticketId: String
    
    /// The user id
    var user_id: String
    
    /// The string attendance of the ticket (related to the queue id). This field doesn't come from the backend
    var attendance: String
    
    /// The queue id which the ticket has been allocated
    var queue: String
    
    /// The date which the ticket has been allocated
    var date_allocated: String
    
    /// The cancel token of the ticket
    var cancel_token: String
    
    /// The message of the ticket
    var message: String = ""
    
    /// The status of the ticket
    var currentStatus: Status = Status.PENDING
    
    /// The status enum with the possible status of a ticket
    enum Status: String {
        /// The ticket is PENDING
        case PENDING
        /// The ticket has been BILLED
        case BILLED
        /// The ticket has been CANCELED
        case CANCELED
        /// The ticket has EXPIRED
        case EXPIRED
        /// The ticket is CLOSED
        case CLOSED
    }
    
    /**
     Empty constructor
    */
    init() {
        self.ticketId = ""
        self.user_id = ""
        self.attendance = ""
        self.queue = ""
        self.date_allocated = ""
        self.cancel_token = ""
    }
    
    /**
     Constructor with user id and queue id
     - Parameters:
         - user_id: the user id of the user who allocated the tickets
         - queue: the queue id in which the ticket has been allocated
    */
    init(user_id: String, queue: String) {
        self.ticketId = ""
        self.user_id = user_id
        self.attendance = ""
        self.queue = queue
        self.date_allocated = ""
        self.cancel_token = ""
    }
    
}
