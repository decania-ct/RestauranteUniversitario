//
//  HoursTableViewController.swift
//  RestauranteUniversitario
//
//  Created by Felipe Podolan Oliveira on 02/08/17.
//  Copyright © 2017 Felipe Podolan Oliveira. All rights reserved.
//

/**
 This is an UIApplication extension for the status bar
 */
extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

import UIKit
/**
 Controller for the screen that displays the hours and the pricing
 */
class HoursTableViewController: UITableViewController {
    
    /// the array of OUs
    var items = [String]()

    /**
     Called after the controller's view is loaded into memory.
     This method is called after the view controller has loaded its view hierarchy into memory. This method is called regardless of whether the view hierarchy was loaded from a nib file or created programmatically in the loadView() method. You usually override this method to perform additional initialization on views that were loaded from nib files
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        //add the method didBecomeActive as a observer (listener) everytime the aplication becomes active
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        // call didBecomeActive method
        didBecomeActive()
    }
    
    /**
     This method is called everytime the view becomes active.
     */
    func didBecomeActive() {
        //show the navigation bar
        navigationController?.setNavigationBarHidden(false, animated: true)
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        self.title = ""
        bar?.backItem?.title = "Navigation Bar Back Button Title".localized
        //make the background of the navigation bar transparent
        bar?.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar?.shadowImage = UIImage()
        bar?.tintColor = AppUtility.hexStringToUIColor(hex: "#029100")
        bar?.backgroundColor = UIColor(white: 1, alpha: 1.0)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(white: 1, alpha: 1.0)
        
        //add the OUs to the items array
        items.append("RU CENTRAL")
        items.append("RU CT")
        items.append("RU Letras")
        items.append("RU IFCS/PV")
        
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
        self.title = "Navigation Bar Back Button Title".localized
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
        // #warning Incomplete implementation, return the number of rows
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HoursTableViewCell", for: indexPath) as? HoursTableViewCell  else {
            fatalError("The dequeued cell is not an instance of HoursTableViewCell.")
        }
        // get the data from the array
        cell.restaurantName.text = items[indexPath.row]
        
        // set each view element of the cell with the data
        cell.restaurantName.textColor = AppUtility.hexStringToUIColor(hex: "#029100")
        cell.studentPrice.text = "2,00"
        cell.workerPrice.text = "6,00"
        cell.weekLunch.text = "11:00h às 14:00h"
        cell.weekDinner.text = "17:30h às 20:00h"
        cell.weekendLunch.text = "12:00h às 14:00h"
        cell.weekendDinner.text = "17:00h às 19:15h"
        return cell
    }

}
