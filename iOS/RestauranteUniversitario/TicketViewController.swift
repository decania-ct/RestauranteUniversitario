//
//  TicketViewController.swift
//  RestauranteUniversitario
//
//  Created by Felipe Podolan Oliveira on 06/07/17.
//  Copyright © 2017 Felipe Podolan Oliveira. All rights reserved.
//

import UIKit
import Toast_Swift

/**
 Controller for the screen that displays the ticket
 */
class TicketViewController: UIViewController, CAAnimationDelegate {
    /// The ticket that holds the data to be loaded
    var ticket: NSDictionary = [:]
    /// The attendance of this ticket
    var attendance = ""
    /// The inner UIView (only used for toast and to be set transparent)
    @IBOutlet weak var innerView: UIView!
    /// The view for the user photo
    @IBOutlet weak var photoIV: UIImageView!
    /// The user id label
    @IBOutlet weak var userIdLabel: UILabel!
    /// The trash UIImageView to delete the ticket
    @IBOutlet weak var trashIV: UIImageView!
    /// The allocated hour label
    @IBOutlet weak var hourLabel: UILabel!
    /// The attendance label
    @IBOutlet weak var attendanceLabel: UILabel!
    /// The QRCode UIImageView
    @IBOutlet weak var qrCodeIV: UIImageView!
    /// UIView of the left side of screen (only used to be set transparent)
    @IBOutlet weak var viewLeft: UIView!
    /// UIView of the right side of screen (only used to be set transparent)
    @IBOutlet weak var viewRight: UIView!
    /// The RU label
    @IBOutlet weak var restaurantName: UILabel!
    /// The eTicket label
    @IBOutlet weak var eTicket: UILabel!
    /// The date and time label for the allocated date and hour
    @IBOutlet weak var dateTimeHeader: UILabel!
    /// The attendance label
    @IBOutlet weak var attendanceLabelHeader: UILabel!
    /// The "rotation" UIImageView
    @IBOutlet weak var refreshImage: UIImageView!
    /// The "rotation" label
    @IBOutlet weak var rotateMessage: UILabel!
    /// The instance of the gradientView to be added to or removed from the background
    var gradientView: GradientView? = nil
    
    /**
     Called after the controller's view is loaded into memory.
     This method is called after the view controller has loaded its view hierarchy into memory. This method is called regardless of whether the view hierarchy was loaded from a nib file or created programmatically in the loadView() method. You usually override this method to perform additional initialization on views that were loaded from nib files
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        didBecomeActive()
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
        print(ticket)
        //add the method didBecomeActive as a observer (listener) everytime the aplication becomes active
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        //make the right and left views backgrounds transparent
        self.viewRight?.backgroundColor = UIColor(white: 1, alpha: 0.0)
        self.viewLeft?.backgroundColor = UIColor(white: 1, alpha: 0.0)
        //call didBecomeActive when the view will appears for the first time
        didBecomeActive()
        
    }
    
    /**
     This method is called everytime the view becomes active.
     */
    func didBecomeActive() {
        //let bar = self.navigationController?.navigationBar
        print("Did become active")
        // show the navigation bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        // determine the orientation and call the appropriate method for each orientation
        if(UIDevice.current.orientation.isLandscape) {
            print("IS LANDSCAPE")
            loadLandscape()
        }
        else {
            print("IS PORTRAIT")
            loadPortrait()
        }
    }
    
    /**
     This method is called when the orientation of the screen is landscape.
    */
    func loadLandscape() {
        // Handle the navigation bar title and back button
        self.navigationController?.navigationBar.backItem?.title = "Navigation Bar Back Button Title".localized
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor(white: 1, alpha: 0.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        rotateMessage.text = ""
        
        // add the ticket metadata
        restaurantName.text = "Ticket Restaurant Name".localized
        eTicket.text = "Ticket e-ticket".localized
        dateTimeHeader.text = "Ticket Date Time".localized
        attendanceLabelHeader.text = "Ticket Attendance".localized
        
        //get the data from the ticket
        let user_id = ticket["user_id"] as! String
        userIdLabel.text = user_id
        //handle the dates
        let dateFormatter = DateFormatter()
        var dateAllocated = ticket["date_allocated"] as! String
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
        let dateAllocatedDate = dateFormatter.date(from: dateAllocated)
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        dateAllocated = dateFormatter.string(from: dateAllocatedDate!) + "h"
        //set the hour label with the data
        hourLabel.text = dateAllocated
        //handle the attendance
        let splittedAttendance = self.attendance.components(separatedBy: " ")
        self.attendance = splittedAttendance[0] + " " + splittedAttendance[1]
        attendanceLabel.text = self.attendance
        //get more data from the ticket
        let ticketId = ticket["id_ticket"] as! NSNumber
        let ticketIdStr = ticketId.stringValue
        let queueId = ticket["queue_id"] as! NSNumber
        let queueIdStr = queueId.stringValue
        //build the QRCode
        qrCodeIV.image = AppUtility.generateQRCode(from: "\(user_id)--\(queueIdStr)--\(ticketIdStr)")
        //download the user photo
        let photoURL = ticket["foto"] as! String
        if let checkedUrl = URL(string: photoURL) {
            photoIV.contentMode = .center
            downloadImage(url: checkedUrl)
        }
        //add the method imageTapped to the trash icon image when it's tapped
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        trashIV.image = AppUtility.resizeImage(image: UIImage(named: "delete_icon")!, targetSize:  CGSize(width: 50, height: 50))
        trashIV.isUserInteractionEnabled = true
        trashIV.addGestureRecognizer(tapGestureRecognizer)
        
        //add the gradient view to the background as a subview
        let color1 = AppUtility.hexStringToUIColor(hex: "#029100")
        let color2 = AppUtility.hexStringToUIColor(hex: "#FF9400")
        innerView.backgroundColor = AppUtility.hexStringToUIColor(hex: "#029100")
        gradientView = GradientView(addTo: innerView, colors: [color1, color2], locations: [0.0, 1.0], isTicket: true)
        innerView.addSubview(gradientView!)
    }
    
    /**
     This method is called when the orientation of the screen is landscape.
     */
    func loadPortrait() {
        // empty all data from the labels
        userIdLabel.text = ""
        hourLabel.text = ""
        attendanceLabel.text = ""
        restaurantName.text = ""
        eTicket.text = ""
        dateTimeHeader.text = ""
        attendanceLabelHeader.text = ""
        
        // show the navigation bar with the appropriate back button color
        self.navigationController?.navigationBar.backItem?.title = "Navigation Bar Back Button Title".localized
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor(white: 1, alpha: 0.0)
        self.navigationController?.navigationBar.tintColor = AppUtility.hexStringToUIColor(hex: "#029100")
        
        // make the background color white
        self.innerView?.backgroundColor = UIColor(white: 1, alpha: 0.0)
        // empty all the images
        photoIV.image = UIImage()
        qrCodeIV.image = UIImage()
        trashIV.image = UIImage()
        
        // get the "rotate" image and do the animation
        let size = CGSize(width: 250, height: 250)
        refreshImage.image = AppUtility.resizeImage(image: UIImage(named: "reload")!, targetSize: size)
        self.refreshImage.rotate360Degrees(completionDelegate: self)
        // add the text beneath the image
        rotateMessage.text = "Rotate Message".localized
    }
    
    /**
     This method is called whenever the trash image is tapped.
    */
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
        let cpf = ticket["user_id"] as! String
        let queueId = ticket["queue_id"] as! NSNumber
        let queueIdStr = queueId.stringValue
        let ticketId = ticket["id_ticket"] as! NSNumber
        let ticketIdStr = ticketId.stringValue
        let ticketObj = Ticket(user_id: cpf, queue: queueIdStr)
        var cancelToken: String = ""
        if (UserDefaults.standard.string(forKey: ticketIdStr) != nil) {
            cancelToken =  UserDefaults.standard.string(forKey: ticketIdStr)!
        }
        ticketObj.cancel_token = cancelToken
        //ticketObj.setTicketId(ticketId: ticketIdStr)
        
        // create the alert
        let alert = UIAlertController(title: "Alert Delete Title".localized, message: "Alert Delete Message".localized, preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Alert No Option".localized, style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Alert Yes Option".localized, style: UIAlertActionStyle.default, handler: { action in
            if(cancelToken == "") {
                let style = ToastStyle()
                self.view.makeToast("Cancel in Other Device Message".localized, duration: 5.0, position: .bottom, style: style)
            }
            else {
                API.updateStatus(newStatus: .CANCELED, ticket: ticketObj,
                                 success: { response in
                                    DispatchQueue.main.async {
                                        let style = ToastStyle()
                                        self.view.makeToast(response, duration: 5.0, position: .bottom, style: style)
                                        self.navigationController?.popToRootViewController(animated: true)
                                    }
                },
                                 failure: { onError in
                                    DispatchQueue.main.async {
                                        let style = ToastStyle()
                                        self.view.makeToast(onError, duration: 5.0, position: .bottom, style: style)
                                    }
                })
            }
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
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
     This method makes an HTTP request to get data from a given URL.
     - Parameters:
        - url: The url of the HTTP request.
        - completion: The completition callback.
        - data: The data received.
        - response: The response from the server.
        - error: The error from the server.
    */
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    /**
     This method calls the getDataFromUrl method, downloads the image from the server when it callsback and then sets the user UIView with the downloaded image.
     - Parameters:
        - url: The url of the HTTP request.
    */
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            let size = CGSize(width: 150, height: 150)
            DispatchQueue.main.async() { () -> Void in
                self.photoIV.image = AppUtility.resizeImage(image: UIImage(data: data)!, targetSize: size)
            }
        }
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
        if UIDevice.current.orientation.isLandscape {
            print("Rotated to Landscape")
            loadLandscape()
        } else {
            print("Roteted to Portrait")
            if(gradientView != nil) {
                gradientView?.removeFromSuperview()
            }
            loadPortrait()
        }
    }
    
}
