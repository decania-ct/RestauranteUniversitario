//
//  SecondViewController.swift
//  RestauranteUniversitario
//
//  Created by Felipe Podolan Oliveira on 29/03/17.
//  Copyright © 2017 Felipe Podolan Oliveira. All rights reserved.
//

import UIKit
import Toast_Swift

/**
 Controller for the screen that allocates a ticket
 */
class TicketAllocatorViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    /// UITextField for the user to type the identity
    @IBOutlet weak var textID: UITextField!
    
    /// UIPicker for the user to pick the attendance string, which is related to a queue id
    @IBOutlet weak var pickerAttendance: UIPickerView!
    
    /// UIPicketTime for the user to select the requested time in the queue
    @IBOutlet weak var pickerTime: UIDatePicker!
    
    /// UIButton for the user to send the data to the server
    @IBOutlet weak var buttonSend: UIButton!
    
    /// UISwitch that allows the user to decide either if he or she whants to save the identity or not
    @IBOutlet weak var switchIdentity: UISwitch!
    
    /// UIScrollView that holds all of the other UIViews
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// Array which is the data source for the picker attendance
    var pickerDataSource = [String]()
    
    /// the queue id
    var queue_id: String = ""
    
    /// Dictionary that maps each attendance to a queue id
    var dictionary = [String: String]()
    
    /// View which contains the loading text and the spinner
    let loadingView = UIView()
    
    /// Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    
    /// Text shown during load the TableView
    let loadingLabel = UILabel()
    
    /// Timer for the update of the pickerview
    var timer: Timer = Timer()
    
    /**
     Called after the controller's view is loaded into memory.
     This method is called after the view controller has loaded its view hierarchy into memory. This method is called regardless of whether the view hierarchy was loaded from a nib file or created programmatically in the loadView() method. You usually override this method to perform additional initialization on views that were loaded from nib files
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        //add the method sendFunction to the sendButton
        buttonSend.addTarget(self, action: #selector(self.sendFunction), for: .touchUpInside)
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
        //call didBecomeActive when the view will appears for the first time
        didBecomeActive()
    }

    /**
     Sent to the view controller when the app receives a memory warning.
     Your app never calls this method directly. Instead, this method is called when the system determines that the amount of available memory is low.
     You can override this method to release any additional memory used by your view controller. If you do, your implementation of this method must call the super implementation at some point.
    */
    override func didReceiveMemoryWarning() {
        timer.invalidate()
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     This method is called everytime the view becomes active.
    */
    func didBecomeActive() {
        //hide the navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        //add a listener to hide the keyboard when the user clicks outside of it
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TicketAllocatorViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        if(!timer.isValid) {
            timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(reloadAttendancePickerData), userInfo: nil, repeats: true)
        }
        
        //reload data
        reloadTimePicker()
        reloadAttendancePickerData()
        
        //add listener to both the user identity text field and switch
        self.textID.addTarget(self, action: #selector(saveIdentity(_:)), for: .editingChanged)
        self.switchIdentity.addTarget(self, action: #selector(switchChangeListener(_:)), for: .valueChanged)
        
        //retrieve the user identity if there is any saved
        AppUtility.retrieveIdentity(textID, switchIdentity)
        
        //modify the switch appearance
        AppUtility.modifySwitchAppearance(switchIdentity)
    }
    
    /**
     This method dimiss the keyboard when the user clicks outside of it
    */
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    /**
     This method adds the listener to the user identity switch
    */
    func switchChangeListener(_ switchButton: UISwitch) {
        AppUtility.switchChangeListener(switchButton, textID)
    }
    
    /**
     This method saves the identity.
    */
    func saveIdentity(_ textField: UITextField) {
        AppUtility.saveIdentity(textField, switchIdentity)
    }
    
    /**
     This method reloads the time picker so it will show the current time.
    */
    func reloadTimePicker() {
        self.pickerTime.reloadInputViews()
        self.pickerTime.setDate(Date(timeIntervalSinceNow: 60), animated: false)
    }
    
    /**
     This method reloads the data of the picker attendance and of the dictionary that relates each attendance to a queue id.
    */
    func reloadAttendancePickerData() {
        print("Entered reload attendance picker data")
        //empty collected data if there is any from both the data source and the dictionary
        self.pickerDataSource = [String]()
        self.dictionary = [String: String]()
        
        //reload the picker
        self.pickerAttendance.reloadAllComponents()
        
        //add the load indicator if not already added
        if(!self.loadingLabel.isDescendant(of: pickerAttendance)) {
            let size = CGSize(width: UIScreen.main.bounds.width ,height: self.pickerAttendance.frame.height)
            self.addLoadingIndicator(to: size)
        }
        
        //only do the request if the device is connected to the internet
        if(AppUtility.isConnectedToNetwork()) {
            var urlParams: Dictionary<String, String> = [:]
            urlParams["status"] = "AVALIABLE"
            urlParams["extra"] = ""
            API.getQueues(urlParams: urlParams, success: {queues in
                // set the data source and delegate as self
                self.pickerAttendance.dataSource = self
                self.pickerAttendance.delegate = self
                
                //empty collected data if there is any from both the data source and the dictionary
                self.pickerDataSource = [String]()
                self.dictionary = [String: String]()
                if(queues.count > 0) {
                    //if there is any queue being returned, remove the loading indicator
                    self.removeLoadingIndicator()
                    //stop updating the attendance picker
                    self.timer.invalidate()
                    
                    for i in 0..<queues.count {
                        let queue = queues[i]
                        print(queue.attendance)
                        
                        //add the attendance string to the data source
                        self.pickerDataSource.append(queue.attendance)
                        //add the attendance string as key and the queue id as value to the dictionary
                        self.dictionary[queue.attendance] = queue.id_queues as String
                    }
                    
                    //relaod the picker
                    self.pickerAttendance.reloadAllComponents()
                }
                
            }, failure: {errorMessage in
                DispatchQueue.main.async {
                    let style = ToastStyle()
                    self.scrollView.makeToast(errorMessage, duration: 5.0, position: .bottom, style: style)
                }
            })
        }
        else {
            print("Device not online")
        }
    }

    /**
     This method is called whenever the user hits the send button.
    */
    func sendFunction() {
        if textID.text != "" {
            if pickerDataSource.count > 0 {
                //get the params from the view
                let user_id: String = self.textID.text!
                let attendance = self.pickerDataSource[self.pickerAttendance.selectedRow(inComponent: 0)]
                queue_id = self.dictionary[attendance]!
                
                //get and format the date
                let date = self.pickerTime.date
                let splitted = String(describing: date).components(separatedBy:  " ")
                let dateStr = splitted[0]
                let components = self.pickerTime.calendar.dateComponents([.hour, .minute], from: self.pickerTime.date)
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "pt_BR")
                dateFormatter.dateFormat = "xxxxx"
                let dateZone = Date()
                let stringZone = dateFormatter.string(from: dateZone)
                let hourStr = dateStr + "T" + String(format: "%02d",components.hour!) + ":" + String(format: "%02d", components.minute!) + ":00" + stringZone
                
                let params = ["user_id": user_id, "date_requested": hourStr, "queue_id": queue_id, "phone_number": ""] as Dictionary<String, String>
                
                //call the allocate ticket method from the API class
                API.allocateTicket(params: params, success: {response, ticket in
                    DispatchQueue.main.async {
                        let style = ToastStyle()
                        self.scrollView.makeToast(response, duration: 5.0, position: .bottom, style: style)
                    }
                }, failure: { errorMessage in
                        DispatchQueue.main.async {
                        let style = ToastStyle()
                        self.scrollView.makeToast(errorMessage, duration: 5.0, position: .bottom, style: style)
                    }
                })
                
            }
            else {
                scrollView.makeToast("No Attendance Selected Message".localized)
            }
        }
        else {
            scrollView.makeToast("Invalid Id Message".localized)
        }
    }
    
    /**
     Called by the picker view when it needs the number of components.
     - Parameters:
        - pickerView: The picker view requesting the data.
     - Returns: The number of components (or “columns”) that the picker view should display.
    */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /**
     Called by the picker view when it needs the number of rows for a specified component.
     - Parameters:
        - pickerView: The picker view requesting the data.
        - component: A zero-indexed number identifying a component of pickerView. Components are numbered left-to-right.
     - Returns: The number of rows for the component.
    */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    /**
     Called by the picker view when it needs the title to use for a given row in a given component.
     If you implement both this method and the pickerView(_:attributedTitleForRow:forComponent:) method, the picker view prefers the pickerView(_:attributedTitleForRow:forComponent:) method. However, if that method returns nil, the picker view falls back to using the string returned by this method.
     - Parameters:
        - pickerView: An object representing the picker view requesting the data.
        - row: A zero-indexed number identifying a row of component. Rows are numbered top-to-bottom.
        - component: A zero-indexed number identifying a component of pickerView. Components are numbered left-to-right.
     - Returns: The string to use as the title of the indicated component row.
    */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    /**
     Called by the picker view when it needs the view to use for a given row in a given component.
     If the previously used view (the view parameter) is adequate, return that. If you return a different view, the previously used view is released. The picker view centers the returned view in the rectangle for row.
     - Parameters:
        - pickerView: An object representing the picker view requesting the data.
        - row: A zero-indexed number identifying a row of component. Rows are numbered top-to-bottom.
        - component: A zero-indexed number identifying a component of pickerView. Components are numbered left-to-right.
        - view: A view object that was previously used for this row, but is now hidden and cached by the picker view.
     - Returns: A view object to use as the content of row. The object can be any subclass of UIView, such as UILabel, UIImageView, or even a custom view.
    */
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        // get the label
        var label = view as! UILabel!
        //if it's nil, create a new label
        if label == nil {
            label = UILabel()
        }
        // get the data (string to be show)
        let data = pickerDataSource[row]
        //add the attributes to the label
        let title = NSAttributedString(string: data, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightRegular)])
        //add aditional configuration
        label?.attributedText = title
        label?.textAlignment = .center
        return label!
    }
    
    /**
     Notifies the view controller that its view is about to be removed from a view hierarchy.
     This method is called in response to a view being removed from a view hierarchy. This method is called before the view is actually removed and before any animations are configured.
     Subclasses can override this method and use it to commit editing changes, resign the first responder status of the view, or perform other relevant tasks. For example, you might use this method to revert changes to the orientation or style of the status bar that were made in the viewDidAppear(_:) method when the view was first presented. If you override this method, you must call super at some point in your implementation.
     - Parameters:
        - animated: If true, the disappearance of the view is being animated.
    */
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
        super.viewWillDisappear(animated)
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
        if(pickerAttendance != nil && !self.loadingLabel.isHidden) {
            removeLoadingIndicator()
            addLoadingIndicator(to: size)
        }
    }
    
    /**
     This method adds the loading indicator to the attendance picker while the data is being loaded.
    */
    func addLoadingIndicator(to size: CGSize) {
        //calculates the frame of the view
        let width: CGFloat = 120
        let height: CGFloat = 30
        let y = (pickerAttendance.frame.height / 2) - (height / 2)
        let x = (size.width / 2) - (width / 2) - 8
        //adds the frame to the view
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
        
        pickerAttendance.addSubview(loadingView)
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

