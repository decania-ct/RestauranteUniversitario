//
//  OptionsTableViewController.swift
//  RestauranteUniversitario
//
//  Created by Felipe Podolan Oliveira on 02/08/17.
//  Copyright © 2017 Felipe Podolan Oliveira. All rights reserved.
//

import UIKit
/**
 Controller for the screen that displays some extra options in the app.
 */
class OptionsTableViewController: UITableViewController {

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
     This method is called whenever the view becomes active.
     */
    func didBecomeActive() {
        tableView.tableFooterView = UIView(frame: .zero)
        //hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.title = "Options Title".localized
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
        //make the navigation bar backgroud transparent and handle the back button color
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar?.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar?.shadowImage = UIImage()
        bar?.tintColor = AppUtility.hexStringToUIColor(hex: "#029100")
        bar?.backgroundColor = UIColor(white: 1, alpha: 1.0)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(white: 1, alpha: 1.0)
    }

    /**
     Sent to the view controller when the app receives a memory warning.
     Your app never calls this method directly. Instead, this method is called when the system determines that the amount of available memory is low.
     You can override this method to release any additional memory used by your view controller. If you do, your implementation of this method must call the super implementation at some point.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        return 3
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OptionsTableViewCell", for: indexPath) as? OptionsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of OptionsTableViewCell.")
        }
        switch indexPath.row {
        case 0:
            cell.label.text = "Options Notifications".localized
            cell.icon.image = UIImage(named: "icons8-appointment_reminders")
            break
        case 1:
            cell.label.text = "Options Hours".localized
            cell.icon.image = UIImage(named: "icons8-clock-1")
            break
        case 2:
            cell.label.text = "Options Rating".localized
            cell.icon.image = UIImage(named: "icons8-filled_star")
            break
        default:
            break
        }
       return cell
    }
    
    /**
     Tells the delegate that the specified row is now selected.
     The delegate handles selections in this method. One of the things it can do is exclusively assign the check-mark image (checkmark) to one row in a section (radio-list style). This method isn’t called when the isEditing property of the table is set to true (that is, the table view is in editing mode). See "Managing Selections" in Table View Programming Guide for iOS for further information (and code examples) related to this method.
     - Parameters:
        - tableView: A table-view object informing the delegate about the new row selection.
        - indexPath: An index path locating the new selected row in tableView.
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            self.performSegue(withIdentifier: "NotificationsSegue", sender: self)
            break
        case 1:
            self.performSegue(withIdentifier: "HoursSegue", sender: self)
            break
        case 2:
            self.performSegue(withIdentifier: "RatingSegue", sender: self)
            break
        default:
            break
        }
    }
}
