//
//  RatingViewController.swift
//  RestauranteUniversitario
//
//  Created by Felipe Podolan Oliveira on 02/08/17.
//  Copyright © 2017 Felipe Podolan Oliveira. All rights reserved.
//

import UIKit

/**
 Controller for the screen that displays the rating
 */
class RatingViewController: UIViewController, FloatRatingViewDelegate  {

    /// The text field of the observations rating
    @IBOutlet weak var observationsRatingView: UITextField!
    
    /// The send button to send the data to the API
    @IBOutlet weak var buttonSend: UIButton!
    
    /// The rating view (stars) for the app
    @IBOutlet weak var appRatingView: FloatRatingView!
    
    /// The rating view for the menu
    @IBOutlet weak var menuRatingView: FloatRatingView!
    
    /// The rating view for the attendance
    @IBOutlet weak var attendanceRatingView: FloatRatingView!
    
    /// Constrains for the keyboard (so that the screen goes up when they keyboard appears)
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    /**
     Called after the controller's view is loaded into memory.
     This method is called after the view controller has loaded its view hierarchy into memory. This method is called regardless of whether the view hierarchy was loaded from a nib file or created programmatically in the loadView() method. You usually override this method to perform additional initialization on views that were loaded from nib files
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // add the sendFunction when the button is touched
        buttonSend.addTarget(self, action: #selector(self.sendFunction), for: .touchUpInside)
        // add the observer (listener) keyboardNotification when the keyboard appears
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    /**
     Deinit (destructor)
    */
    deinit {
        // remove the observer
        NotificationCenter.default.removeObserver(self)
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
     This method is called everytime the view becomes active.
     */
    func didBecomeActive() {
        // show navigation bar
        navigationController?.setNavigationBarHidden(false, animated: false)
        // handle navigation bar title and back button
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        self.title = ""
        bar?.backItem?.title = "Navigation Bar Back Button Title".localized
        bar?.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar?.shadowImage = UIImage()
        bar?.tintColor = AppUtility.hexStringToUIColor(hex: "#029100")
        bar?.backgroundColor = UIColor(white: 1, alpha: 0.0)
        
        // add observer (listener) to the screen to dismiss the keyboard when the user clicks outside of it
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RatingViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        // change images of all rating views to be the yellow star and add aditiional configuration to all of them
        self.appRatingView.emptyImage = UIImage(named: "icons8-star")
        self.appRatingView.fullImage = UIImage(named: "icons8-filled_star")
        // Optional params
        self.appRatingView.delegate = self
        self.appRatingView.contentMode = UIViewContentMode.scaleAspectFit
        self.appRatingView.maxRating = 5
        self.appRatingView.minRating = 1
        self.appRatingView.rating = 0
        self.appRatingView.editable = true
        self.appRatingView.halfRatings = false
        self.appRatingView.floatRatings = false
        
        self.menuRatingView.emptyImage = UIImage(named: "icons8-star")
        self.menuRatingView.fullImage = UIImage(named: "icons8-filled_star")
        // Optional params
        self.menuRatingView.delegate = self
        self.menuRatingView.contentMode = UIViewContentMode.scaleAspectFit
        self.menuRatingView.maxRating = 5
        self.menuRatingView.minRating = 1
        self.menuRatingView.rating = 0
        self.menuRatingView.editable = true
        self.menuRatingView.halfRatings = false
        self.menuRatingView.floatRatings = false
        
        self.attendanceRatingView.emptyImage = UIImage(named: "icons8-star")
        self.attendanceRatingView.fullImage = UIImage(named: "icons8-filled_star")
        // Optional params
        self.attendanceRatingView.delegate = self
        self.attendanceRatingView.contentMode = UIViewContentMode.scaleAspectFit
        self.attendanceRatingView.maxRating = 5
        self.attendanceRatingView.minRating = 1
        self.attendanceRatingView.rating = 0
        self.attendanceRatingView.editable = true
        self.attendanceRatingView.halfRatings = false
        self.attendanceRatingView.floatRatings = false
        
        // Segmented control init
        //self.appRatingSegmentControl.selectedSegmentIndex = 1
        
    }
    /**
     This method dismiss the keyboard
    */
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
     Sent to the view controller when the app receives a memory warning.
     Your app never calls this method directly. Instead, this method is called when the system determines that the amount of available memory is low.
     You can override this method to release any additional memory used by your view controller. If you do, your implementation of this method must call the super implementation at some point.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     This method is called when the rating type has changed.
     - Parameters:
        - sender: The segmend control
    */
    @IBAction func ratingTypeChanged(_ sender: UISegmentedControl) {
        self.appRatingView.halfRatings = sender.selectedSegmentIndex==1
        self.appRatingView.floatRatings = sender.selectedSegmentIndex==2
    }
    
    /**
     Returns the rating value as the user pans.
     - Parameters:
        - ratingView: The rating view being updated
        - rating: The current value of the rate
    */
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
        //self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    
    /**
     Returns the rating value when touch events end.
     - Parameters:
        - ratingView: The rating view being updated
        - rating: The current value of the rate
    */
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        //self.updatedLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    
    /**
     This method is called whenever the user hits the send button.
     */
    func sendFunction() {
        print(appRatingView.rating)
        print(menuRatingView.rating)
        print(attendanceRatingView.rating)
    }
    
    /**
     This method makes the screen goes up the same height of the keyboard when the keyboard appears
    */
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }

}
