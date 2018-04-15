//
//  API.swift
//  RestauranteUniversitario
//
//  Created by Felipe Podolan Oliveira on 03/08/17.
//  Copyright © 2017 Felipe Podolan Oliveira. All rights reserved.
//

import UIKit
import DeviceKit

/**
 This struct is responsible for making the calls to the RU API. Each method represents a different route of the API and the interfaces allow the callbacks.
 */
struct API {
    
    static var checkTokenCounter: Int = 0
    
    /// The base API URL to which the routes will be added
    public static let base_url: String = "API URL".localized
    
    /**
     This method makes a HTTP request to the API to check if the JWT token saved in the device (if there is any) is a valid token. Route: GET /status/token.
     
     - Parameters:
        - success: the success callback when the response code is 200
        - failure: the failure callback when the response is an error
    */
    public static func checkToken(success: @escaping (() -> Void),
                                  failure: @escaping((_ onError:String) -> Void)) {
        //Getting the route of the API, using the saved API base url string
        let app_server_url: String = "\(base_url)status/token"
        
        //Creating the request. This is a GET HTTP string request of the given URL.
        let url: URL = URL(string: app_server_url)!
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        
        //Handling the headers of the request
        //Getting the JWT token
        var jwtToken: String = ""
        if(UserDefaults.standard.string(forKey: "JWT Token".localized) != nil) {
            jwtToken = UserDefaults.standard.string(forKey: "JWT Token".localized)!
        }
        request.addValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json charset=utf-8", forHTTPHeaderField: "Accept")
        
        //create the session
        let session = URLSession.shared
        
        //create the task behaviour
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            // get the error
            guard error == nil else {
                return
            }
            
            //get the response
            if let response = response {
                let httpResponse = response as! HTTPURLResponse
                print("response code = \(httpResponse.statusCode)")
                //switch among the possible response code
                switch (httpResponse.statusCode) {
                //if the response code is 200, call sucess callback
                case 200:
                    checkTokenCounter = 0
                    success()
                    break
                //if the responso is an error, the JWT isn't valid. Ask for a new one.
                default:
                    if(checkTokenCounter < 10) {
                        checkTokenCounter = checkTokenCounter + 1
                        print(checkTokenCounter)
                        //wait for 4s and then ask for a new JWT token
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                            //success callback of POST clients/token calls success callback of GET status/token
                            getToken(success: { success() },
                                     //failure callback of POST clients/token calls failure callback of GET status/token
                                failure: { onError in failure(onError) } )
                        })
                    }
                    else {
                        
                    }
                    break
                }
            }
            
        })
        
        //resume the task, send to API
        task.resume()
    }
    
    
    /**
     This method makes an HTTP request to the API to ask for a new JWT token. Route: POST clients/token
     - Parameters:
        - success: the success callback when the response code is 200
        - failure: the failure callback when the response is an error
    */
    public static func getToken(success: @escaping (() -> Void),
                                failure: @escaping((_ onError:String) -> Void)) {
        //Getting the route of the API, using the saved API base url string
        let app_server_url: String = "\(base_url)clients/token"
        
        //Creating the request
        let url: URL = URL(string: app_server_url)!
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        
        //Handling the body of the request
        //getting the device info
        let device = Device()
        let deviceString = device.description
        
        //getting the fcm_token
        var fcmToken: String = ""
        if (UserDefaults.standard.string(forKey: "Firebase Token".localized) != nil) {
            fcmToken = UserDefaults.standard.string(forKey: "Firebase Token".localized)!
        }
        
        //prepare the body params of the request
        let params = ["device": fcmToken, "subject": deviceString, "app": "Firebase App".localized] as Dictionary<String, String>
        //convert the dictionary to a json object
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        //Handling the headers of the request
        request.addValue("application/json charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json charset=utf-8", forHTTPHeaderField: "Accept")
        
        //create the session
        let session = URLSession.shared
        
        //create the task behaviour
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            //get the error
            guard error == nil else {
                return
            }
            
            //get the response
            if let response = response {
                let httpResponse = response as! HTTPURLResponse
                
                //switch among the possible response code
                switch (httpResponse.statusCode) {
                //if the response code is 200, call sucess callback
                case 200:
                    /*
                     * Wait for 4s and check if the received token is valid using route GET /status/token
                     *
                     * NOTE: the token is sent through a push message (which is manipulated within the AppDelegate class) and thus
                     * when the checkToken method is called it might have not been received yet. This causes a loop behaviour between these
                     * two methods until the token is received and the GET status/token request receives a 200 code response
                     */
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                        checkToken(success: {success()}, failure: {onError in
                            print(onError)
                            failure(onError)})
                    })
                    break
                default:
                    /* if the response is an error, the this method failed to request the token.
                     * This might happen for many reasons such as there is no fcm_token registered
                     * in the device yet, thus we ask for the token again, after waiting 4s.
                     */
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                        print("Get Token failed. Try again!")
                        getToken(success: {success()}, failure: {onError in failure(onError)})
                    })
                    break
                }
                
            }
        })
        
        //resume the task, send to API
        task.resume()
    }
    
    /**
     This method makes an HTTP request to the API to update a ticket in a queue. Route: PUT queues/:queue_id/tickets/:user_id
     - Parameters:
        - newStatus: the new status of the ticket
        - ticket: the ticket object to be updated
        - success: the success callback when the response code is 200
        - failure: the failure callback when the response is an error
    */
    public static func updateStatus(newStatus: Ticket.Status, ticket: Ticket,
                                    success: @escaping ((_ response: String) -> Void),
                                    failure: @escaping((_ onError:String) -> Void)) {
        checkTokenCounter = 0
        //Before doing the request, check if the stored JWT token is valid calling GET status/token route
        checkToken(success: {
            //get the info from the ticket object
            ticket.currentStatus = newStatus
            let queue = ticket.queue
            let id = ticket.user_id
            
            //Getting the route of the API, using the saved API base url string
            let app_server_url: String = "\(base_url)queues/\(queue)/tickets/\(id)"
            
            //Creating the request
            let url: URL = URL(string: app_server_url)!
            var request: URLRequest = URLRequest(url: url)
            request.httpMethod = "PUT"
            
            //Handling the body of the request
            let params = ["status": String(describing: newStatus), "cancel_token": ticket.cancel_token] as Dictionary<String, String>
            //convert the dictionary to a json object
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
            
            //Handling the headers of the request
            //getting the JWT token
            let jwtToken: String = UserDefaults.standard.string(forKey: "JWT Token".localized)!
            request.addValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
            
            request.addValue("application/json charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json charset=utf-8", forHTTPHeaderField: "Accept")
            
            //create the session
            let session = URLSession.shared
            
            //create the task
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                
                //get the error
                guard error == nil else {
                    return
                }
                
                //get the data
                guard let data = data else {
                    return
                }
                
                DispatchQueue.main.async {
                    do {
                        //create json object from data
                        if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                            print(json)
                            success("Ticket Success Cancel Message".localized)
                        }
                    } catch let error {
                        //if the response is an error
                        print(error.localizedDescription)
                        //get the error description or details/message
                        var description = error.localizedDescription
                        if let data = description.data(using: .utf8) {
                            do {
                                let jsonError = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                                description = jsonError?["details"] as! String
                                if(description == "") {
                                    description = jsonError?["message"] as! String
                                }
                            } catch {
                                
                            }
                        }
                        //call failure callback
                        failure(description)
                    }
                }
            })
            //resume the task, send to API
            task.resume()
            
        }, failure: {onError in })
    }
    
    /**
     This method makes an HTTP request to the API to allocate a ticket in a queue. Route: POST queues/:queue_id
     - Parameters:
         - params: the params gotten from the interface to be sent in the body of the request
         - success: the success callback when the response code is 200
         - failure: the failure callback when the response is an error
     */
    public static func allocateTicket(params: Dictionary<String, String>,
                                      success: @escaping ((_ response: String, _ ticket: Ticket) -> Void),
                                      failure: @escaping((_ onError:String) -> Void) ) {
        checkTokenCounter = 0
        //Before doing the request, check if the stored JWT token is valid calling GET status/token route
        checkToken(success: {
            //Getting the route of the API, using the saved API base url string
            let app_server_url = base_url + "queues/" + params["queue_id"]!
            
            //Creating the request
            let url: URL = URL(string: app_server_url)!
            var request: URLRequest = URLRequest(url: url)
            request.httpMethod = "POST"
            
            //convert the dictionary to a json object
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
            
            //Handling the headers of the request
            //getting the JWT token
            let jwtToken: String = UserDefaults.standard.string(forKey: "JWT Token".localized)!
            request.addValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
            
            request.addValue("application/json charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json charset=utf-8", forHTTPHeaderField: "Accept")
            
            //create the session
            let session = URLSession.shared
            
            //create the task
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                
                //get the error
                guard error == nil else {
                    return
                }
                
                //get the data
                guard let data = data else {
                    return
                }
                
                DispatchQueue.main.async {
                    do {
                        //create json object from data
                        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
                        print(json)
                        var message = ""
                        //ceate a ticket object
                        let ticketObj: Ticket = Ticket()
                        //the json from the response body should have a key "result"
                        if let result = json["result"] as? String {
                            //if value of key result is success, set the fields of the ticket with the data and  call success callback
                            if(result == "success") {
                                let ticket = json["ticket"] as! NSDictionary
                                var dateAllocated = ticket["date_allocated"] as! String
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
                                let dateAllocatedDate = dateFormatter.date(from: dateAllocated)
                                dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                                dateAllocated = dateFormatter.string(from: dateAllocatedDate!)
                                print(dateAllocated)
                                let inner_message = ticket["message"] as! String
                                ticketObj.date_allocated = dateAllocated
                                message = "Agendamos à(s) " + dateAllocated + "h.\n" + inner_message
                                ticketObj.message = message
                                ticketObj.queue = params["queue_id"]!
                                ticketObj.user_id = params["user_id"]!
                                let ticket_id = ticket["id_ticket"]! as! NSNumber
                                ticketObj.ticketId = ticket_id.stringValue
                                ticketObj.cancel_token = ticket["cancel_token"]! as! String
                                print("ticket_id " + ticketObj.ticketId)
                                print("cancel_token " + ticketObj.cancel_token)
                                UserDefaults.standard.set(ticketObj.cancel_token, forKey: ticketObj.ticketId)
                                print(message)
                            }
                            else {
                                //if value of key result isn't "success", get the error details/message and call failure callback
                                message = json["details"] as! String
                                if(message == "") {
                                    message = json["message"] as! String
                                }
                                print(message)
                                //call failure callback
                                failure(message)
                            }
                        }
                        else {
                            message = json["details"] as! String
                            if(message == "") {
                                message = json["message"] as! String
                            }
                            print(message)
                        }
                        success(message, ticketObj)
                    } catch let error {
                        //if the response is an error
                        var message = error.localizedDescription
                        print(error.localizedDescription)
                        //get the error description or details/message
                        var description = error.localizedDescription
                        if let data = description.data(using: .utf8) {
                            do {
                                let jsonError = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                                message = jsonError?["details"] as! String
                                if(description == "") {
                                    description = jsonError?["message"] as! String
                                }
                            } catch {
                                
                            }
                        }
                        failure(message)
                    }
                }
            })
            //resume the task, send to API
            task.resume()
        }, failure: {onError in })
        
        
    }
    
    /**
     This method makes an HTTP request to the API to search for a ticket in a queue. Route: GET queues/:queue_id/tickets/:user_id
     - Parameters:
         - attendance: the attendance string is a string that is related to a single queue
         - ticket: the ticket object to be searched
         - success: the success callback when the response code is 200
         - failure: the failure callback when the response is an error
     */
    public static func searchTicket(attendance: String, ticket: Ticket,
                                    success: @escaping((_ tickets: NSMutableArray) -> Void),
                                    failure: @escaping((_ onError:String) -> Void) ) {
        checkTokenCounter = 0
        //Before doing the request, check if the stored JWT token is valid calling GET status/token route
        checkToken(success: {
            //Getting the route of the API, using the saved API base url string
            let app_server_url = base_url + "queues/" + ticket.queue + "/tickets/" + ticket.user_id
            
            //Creating the request
            let url: URL = URL(string: app_server_url)!
            var request: URLRequest = URLRequest(url: url)
            request.httpMethod = "GET"
            
            //Handling the headers of the request
            //getting the JWT token
            let jwtToken: String = UserDefaults.standard.string(forKey: "JWT Token".localized)!
            request.addValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
            
            request.addValue("application/json charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json charset=utf-8", forHTTPHeaderField: "Accept")
            
            //create the session
            let session = URLSession.shared
            
            //create the task
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                
                //get the error
                guard error == nil else {
                    return
                }
                
                //get the data
                guard let data = data else {
                    return
                }
                
                DispatchQueue.main.async {
                    do {
                        //create json object from data
                        let temp: NSMutableArray = []
                        
                        if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                            //the json from the response body should have a key "result"
                            let result = json["result"] as! String
                            if(result == "success") {
                                //if value of key result is success, set the fields of the ticket with the data and  call success callback if there are any pending tickets
                                let tickets = json["tickets"] as! NSMutableArray
                                var hasPendingTickets = false
                                
                                temp.addObjects(from: tickets as! [Any])
                                
                                for i in 0..<tickets.count {
                                    let ticket = tickets[i] as! NSDictionary
                                    let status = ticket["status"] as! String
                                    if(status == "PENDING") {
                                        hasPendingTickets = true
                                    }
                                    else {
                                        temp.remove(ticket)
                                    }
                                }
                                
                                if(hasPendingTickets) {
                                    success(temp)
                                } else {
                                    //if there are no pending tickets, call the failure callback
                                    failure("No Ticket Found Message".localized)
                                }
                            }
                        }
                    } catch let error {
                        //if the response is an error
                        var message = error.localizedDescription
                        print(error.localizedDescription)
                        //get the error description or details/message
                        var description = error.localizedDescription
                        if let data = description.data(using: .utf8) {
                            do {
                                let jsonError = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                                message = jsonError?["details"] as! String
                                if(description == "") {
                                    description = jsonError?["message"] as! String
                                }
                            } catch {
                                
                            }
                        }
                        failure(message)
                    }
                }
            })
            
            //resume the task, send to API
            task.resume()
        }, failure: {onError in })
    }
    
    
    /**
     This method makes an HTTP request to the API to get queues. Route: GET /queues
     - Parameters:
     - urlParams: the params of the URL
     - success: the success callback when the response code is 200
     - failure: the failure callback when the response is an error
     */
    public static func getQueues(urlParams: Dictionary<String, String>,
                                    success: @escaping((_ queues: [Queue]) -> Void),
                                    failure: @escaping((_ onError:String) -> Void) ) {
        checkTokenCounter = 0
        //Before doing the request, check if the stored JWT token is valid calling GET status/token route
        checkToken(success: {
            var status: String = ""
            var extra: String = ""
            if(urlParams["status"] != "") {
                status = "status=" + urlParams["status"]!
            }
            if(urlParams["extra"] != "") {
                extra = "extra=" + urlParams["extra"]!
            }
            //Getting the route of the API, using the saved API base url string
            var app_server_url = base_url + "queues"
            if(status != "") {
                app_server_url += "?" + status
                if(extra != "") {
                    app_server_url += "&" + extra
                }
            }
            else {
                app_server_url += "?" + extra
            }
            
            //Creating the request
            let url: URL = URL(string: app_server_url)!
            var request: URLRequest = URLRequest(url: url)
            request.httpMethod = "GET"
            
            //Handling the headers of the request
            //getting the JWT token
            let jwtToken: String = UserDefaults.standard.string(forKey: "JWT Token".localized)!
            request.addValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
            
            request.addValue("application/json charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json charset=utf-8", forHTTPHeaderField: "Accept")
            
            //create the session
            let session = URLSession.shared
            
            //create the task
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                
                //get the error
                guard error == nil else {
                    return
                }
                
                //get the data
                guard let data = data else {
                    return
                }
                
                DispatchQueue.main.async {
                    do {
                        //create json object from data
                        if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                            if(json.count > 0) {
                                var queues: [Queue] = [Queue]()
                                for i in 0..<json.count {
                                    //for each queue, get it's data and create the attendance string
                                    let queue: Queue = Queue()
                                    queue.type = json[i]["type"] as! String
                                    queue.ou = json[i]["ou"] as! String
                                    let tolerance = json[i]["tolerance"] as! NSNumber
                                    queue.tolerance = tolerance.stringValue as String
                                    let billed_tickets = json[i]["billed_tickets"] as! NSNumber
                                    queue.billed_tickets = billed_tickets.stringValue as String
                                    let capacity  = json[i]["capacity"] as! NSNumber
                                    queue.capacity = capacity.stringValue as String
                                    let delay = json[i]["delay"] as! NSNumber
                                    queue.delay = delay.stringValue as String
                                    queue.description = json[i]["description"] as! String
                                    if(json[i]["statistics"] != nil) {
                                        let statisticsArray = json[i]["statistics"] as! [[String: Any]]
                                        for ii in 0..<statisticsArray.count {
                                            let statistic: Statistic = Statistic()
                                            statistic.time_window = statisticsArray[ii]["time_window"] as! String
                                            statistic.free_tickets = statisticsArray[ii]["free_tickets"] as! String
                                            queue.statistics.append(statistic)
                                        }
                                    }
                                    let dateStart = json[i]["date_start"] as! String
                                    let dateEnd = json[i]["date_end"] as! String
                                    let queueIdN: NSNumber = json[i]["id_queues"] as! NSNumber
                                    queue.id_queues = queueIdN.stringValue as String
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
                                    let dateStartDate = dateFormatter.date(from: dateStart)
                                    let dateEndDate = dateFormatter.date(from: dateEnd)
                                    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                                    queue.date_start = dateFormatter.string(from: dateStartDate!)
                                    dateFormatter.dateFormat = "HH:mm"
                                    queue.date_end = dateFormatter.string(from: dateEndDate!)
                                    //create the attendance string
                                    queue.attendance = "\(queue.type) \(queue.ou) \(queue.date_start)h às \(queue.date_end)h"
                                    queues.append(queue)
                                }
                                success(queues)
                            }
                        }
                    } catch let error {
                        print(error.localizedDescription)
                        //get the error description or details/message
                        var description = error.localizedDescription
                        var message: String = ""
                        if let data = description.data(using: .utf8) {
                            do {
                                let jsonError = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                                message = jsonError?["details"] as! String
                                if(description == "") {
                                    description = jsonError?["message"] as! String
                                }
                            } catch {
                                
                            }
                        }
                        failure(message)
                    }
                }
            })
            //resume the task, send to API
            task.resume()
        }, failure: {onError in })
    }
    
    
}
