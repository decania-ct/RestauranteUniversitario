//
//  SchedulesViewController.swift
//  RestauranteUniversitario
//
//  Created by Felipe Podolan Oliveira on 06/04/17.
//  Copyright © 2017 Felipe Podolan Oliveira. All rights reserved.
//

import UIKit
import Toast_Swift

/**
 Controller for the screen that displays the available queues
 */
class QueuesViewController: UITableViewController {
    
    /// The array of items to update the UITable of queues
    var items: NSMutableArray = []
    
    /// A boolean value that is set to true if there are any queues available and to false otherwise
    var hasQueues: Bool = false
    
    /// the gradient view added as background
    var gradientView: GradientView? = nil
    
    /// View which contains the loading text and the spinner
    let loadingView = UIView()
    
    /// Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    
    /// Text shown during load the TableView
    let loadingLabel = UILabel()
    
    /// Timer for the update of the table
    var timer: Timer = Timer()
    
    /**
     Called after the controller's view is loaded into memory.
     This method is called after the view controller has loaded its view hierarchy into memory. This method is called regardless of whether the view hierarchy was loaded from a nib file or created programmatically in the loadView() method. You usually override this method to perform additional initialization on views that were loaded from nib files
     */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /**
     Notifies the view controller that its view is about to be added to a view hierarchy.
     This method is called before the view controller's view is about to be added to a view hierarchy and before any animations are configured for showing the view. You can override this method to perform custom tasks associated with displaying the view. For example, you might use this method to change the orientation or style of the status bar to coordinate with the orientation or style of the view being presented. If you override this method, you must call super at some point in your implementation.
     For more information about the how views are added to view hierarchies by a view controller, and the sequence of messages that occur, see Supporting Accessibility.
     - Note:
     If a view controller is presented by a view controller inside of a popover, this method is not invoked on the presenting view controller after the presented controller is dismissed.
     - Parameters:
        - animated: If true, the view is being added to the window using an animation.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        // call didBecomeActive method
        didBecomeActive()
        
        // remove the table separators
        self.tableView.separatorStyle = .none
        
        // make the row height resizes automatically
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 250
    }
    
    /**
     Sent to the view controller when the app receives a memory warning.
     Your app never calls this method directly. Instead, this method is called when the system determines that the amount of available memory is low.
     You can override this method to release any additional memory used by your view controller. If you do, your implementation of this method must call the super implementation at some point.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     This method is called whenever the view becomes active.
     */
    func didBecomeActive() {
        // remove remained itens
        self.items = []
        self.tableView.reloadData()
        
        if(!self.loadingLabel.isDescendant(of: self.tableView)) {
            // calculate size and add loading indicator
            let size = CGSize(width: self.tableView.frame.width, height: self.tableView.frame.height)
            self.addLoadingIndicator(to: size)
        }
        
        if(!timer.isValid) {
            timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(didBecomeActive), userInfo: nil, repeats: true)
        }
        
        if(AppUtility.isConnectedToNetwork()) {
            
            var urlParams: Dictionary<String, String> = [:]
            urlParams["status"] = "AVALIABLE"
            urlParams["extra"] = "STATISTICS"
            API.getQueues(urlParams: urlParams, success: {queues in
                self.timer.invalidate()
                if(queues.count > 0) {
                    self.hasQueues = true
                    
                    for i in 0..<queues.count {
                        let queue = queues[i]
                        print(queue.attendance)
                        self.items.add(queue)
                    }
                }
                else {
                    let noQueues: String = "No Queues Message".localized
                    self.items.add(noQueues)
                    self.hasQueues = false
                }
                
                // reload the table data
                self.tableView.reloadData()
                
            }, failure: {errorMessage in
                DispatchQueue.main.async {
                    //let style = ToastStyle()
                    //self.scrollView.makeToast(errorMessage, duration: 5.0, position: .bottom, style: style)
                }
            })
        }
        else {
            print("Device not online")
        }
    }
    
    /**
     Notifies the view controller that its view is about to be removed from a view hierarchy.
     This method is called in response to a view being removed from a view hierarchy. This method is called before the view is actually removed and before any animations are configured.
     Subclasses can override this method and use it to commit editing changes, resign the first responder status of the view, or perform other relevant tasks. For example, you might use this method to revert changes to the orientation or style of the status bar that were made in the viewDidAppear(_:) method when the view was first presented. If you override this method, you must call super at some point in your implementation.
     - Parameters:
        - animated: If true, the disappearance of the view is being animated.
     */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    /**
     Asks the data source to return the number of sections in the table view.
     - Parameters:
        - tableView: An object representing the table view requesting this information.
     - Returns: The number of sections in tableView. The default value is 1.
    */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /**
     Tells the data source to return the number of rows in a given section of a table view.
     - Parameters:
        - tableView: The table-view object requesting this information.
        - section: An index number identifying a section in tableView.
     Returns: The number of rows in section.
    */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    /**
     Asks the data source for a cell to insert in a particular location of the table view.
     The returned UITableViewCell object is frequently one that the application reuses for performance reasons. You should fetch a previously created cell object that is marked for reuse by sending a dequeueReusableCell(withIdentifier:) message to tableView. Various attributes of a table cell are set automatically based on whether the cell is a separator and on information the data source provides, such as for accessory views and editing controls.
     - Parameters:
        - tableView: A table-view object requesting the cell.
        - indexPath: An index path locating a row in tableView.
     - Returns: An object inheriting from UITableViewCell that the table view can use for the specified row. An assertion is raised if you return nil.
    */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // instantiate the cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QueuesTableViewCell", for: indexPath) as? QueuesTableViewCell  else {
            fatalError("The dequeued cell is not an instance of SchedulesTableViewCell.")
        }
        
        // remove the loading indicator
        self.removeLoadingIndicator()
        
        // remove the background of the cell, aka make it invisible so the gradient background can be added
        cell.leftView?.backgroundColor = UIColor(white: 1, alpha: 0.0)
        cell.rightView?.backgroundColor = UIColor(white: 1, alpha: 0.0)
        
        // if there are available queues
        if (hasQueues) {
            // set each view element of the cell with the metadata
            cell.noQueuesLabel.text = ""
            cell.dataLabel.text = "Queues Data Label".localized
            cell.descriptionLabel.text = "Queues Description Label".localized
            cell.hourLabel.text = "Queues Date Time Label".localized
            
            // create the gradient colors
            let color1 = AppUtility.hexStringToUIColor(hex: "#029100")
            let color2 = AppUtility.hexStringToUIColor(hex: "#FF9400")
            
            // create the gradient view and add it as a subview of the cell
            gradientView = GradientView(addTo: cell, colors: [color1, color2], locations: [0.0, 1.0], isTicket: false)
            cell.addSubview(gradientView!)
            
            // get the data from the queue
            //let json = items[indexPath.row] as! [String: Any]
            let queue = items[indexPath.row] as! Queue
            
            //store and format the data in local variables
            let type: String = queue.type
            let ou: String = queue.ou
            let dateStartArray = queue.date_start.components(separatedBy: " ")
            let dateStart: String = dateStartArray[1] + "h"
            let dateEnd: String = queue.date_end + "h"
            let date: String = dateStartArray[0]
            
            //handle the statistics
            var statisticsStr: String = ""
            
            for i in 0..<queue.statistics.count {
                let freeTickets = queue.statistics[i].free_tickets
                //let freeTicketsStr = freeTickets.stringValue
                let timeWindow = queue.statistics[i].time_window
                statisticsStr += timeWindow + "h: " + freeTickets + " vagas\n"
            }
            
            // set each view element of the cell with the data
            cell.dataDataLabel.text = type + " " + ou + "\n" + date + "\n" + "Start".localized + ": " + dateStart + "\n" + "End".localized + ": " + dateEnd
            cell.hourDataLabel.text = statisticsStr
            cell.descriptionDataLabel.text = queue.description
        }
        //if there are no schedules
        else {
            // add the noSchedules label to the view and set all metadata to empty
            cell.noQueuesLabel.text = items[indexPath.row] as? String
            cell.dataLabel.text = ""
            cell.dataDataLabel.text = ""
            cell.descriptionLabel.text = ""
            cell.descriptionDataLabel.text = ""
            cell.hourLabel.text = ""
            cell.hourDataLabel.text = ""
            // remove the gradient view if it remains
            if(gradientView != nil) {
                gradientView?.removeFromSuperview()
            }
        }
        return cell
    }
    
    /**
     Notifies the container that the size of its view is about to change.
     UIKit calls this method before changing the size of a presented view controller’s view. You can override this method in your own objects and use it to perform additional tasks related to the size change. For example, a container view controller might use this method to override the traits of its embedded child view controllers. Use the provided coordinator object to animate any changes you make.
     If you override this method in your custom view controllers, always call super at some point in your implementation so that UIKit can forward the size change message appropriately. View controllers forward the size change message to their views and child view controllers. Presentation controllers forward the size change to their presented view controller.
     - Parameters:
        - size: The new size for the container’s view.
        - coordinator: The transition coordinator object managing the size change. You can use this object to animate your changes or get information about the transition that is in progress.
     */
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if(!self.loadingLabel.isHidden) {
            removeLoadingIndicator()
            addLoadingIndicator(to: size)
        }
    }
    
    /**
     This method adds the loading indicator to the table view while the data is being loaded.
     */
    func addLoadingIndicator(to size: CGSize) {
        let width: CGFloat = 120
        let height: CGFloat = 30
        let y = (size.height / 2) - (height / 2)
        let x = (size.width / 2) - (width / 2)
        self.loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        // Sets loading text
        self.loadingLabel.textColor = UIColor.gray
        self.loadingLabel.textAlignment = NSTextAlignment.center
        self.loadingLabel.text = "Loading Label".localized
        self.loadingLabel.isHidden = false
        self.loadingLabel.frame = CGRect(x: 0,y: 0,width: 140,height: 30)
        
        // Sets spinner
        self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.spinner.frame = CGRect(x: 0,y: 0,width: 8,height: 30)
        self.spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(self.spinner)
        loadingView.addSubview(self.loadingLabel)
        
        self.tableView.addSubview(loadingView)
    }
    
    /**
     This method removes the loading indicator after the data has been loaded
     */
    func removeLoadingIndicator() {
        if(!self.loadingLabel.isHidden) {
            self.spinner.stopAnimating()
            self.spinner.hidesWhenStopped = true
            self.loadingLabel.isHidden = true
            self.loadingView.removeFromSuperview()
        }
    }
}
