//
//  FirstViewController.swift
//  RestauranteUniversitario
//
//  Created by Felipe Podolan Oliveira on 29/03/17.
//  Copyright © 2017 Felipe Podolan Oliveira. All rights reserved.
//

import UIKit

/**
 Controller for the screen that displays the week menu
 */
class MenuViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    /// UIPikerView for the weekdays
    @IBOutlet var weekdaysPickerView: UIPickerView!
    
    /// UIPikerView for the options
    @IBOutlet var optionsPickerView: UIPickerView!
    
    /// UIPikerView for the ou
    @IBOutlet var ouPickerView: UIPickerView!
    
    /// UILabel for the appetizer
    @IBOutlet var appetizerLabel: UILabel!
    
    /// UILabel for the main course
    @IBOutlet var mainCourseLabel: UILabel!
    
    /// UILabel for the vegetarian course
    @IBOutlet var vegetarianCourseLabel: UILabel!
    
    /// UILabel for the garrison
    @IBOutlet var garrisonLabel: UILabel!
    
    /// UILabel for the side dish
    @IBOutlet var sideDishLabel: UILabel!
    
    /// UILabel for the desert
    @IBOutlet var desertLabel: UILabel!
    
    /// UILabel for the drink
    @IBOutlet var drinkLabel: UILabel!
    
    /// Array which is the data source for the weekdays picker
    var weekdaysPickerDataSource = [String]()
    
    /// Array which is the data source for the options picker
    var optionsPickerDataSource: Array<String> = ["Almoço", "Jantar"]
    
    /// Array which is the data source for the ou picker
    var ouPickerDataSource: Array<String> = ["CT"]
    
    /// String to store the selected weekday
    var selectedWeekday: String = ""
    
    /// String to store the selected option
    var selectedOption: String = ""
    
    /// String to store the selected ou
    var selectedOu: String = ""
    
    /// index of the current weekday in the weekdays data source (today)
    var index: Int = -1
    
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
        // verify which pickerview and return the correct number of rows
        if(pickerView == weekdaysPickerView) {
            return weekdaysPickerDataSource.count
        }
        else if (pickerView == optionsPickerView) {
            return optionsPickerDataSource.count
        }
        else {
            return ouPickerDataSource.count
        }
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
        // verify which pickerview and return the correct title
        if(pickerView == weekdaysPickerView) {
            return weekdaysPickerDataSource[row]
        }
        else if (pickerView == optionsPickerView)  {
            return optionsPickerDataSource[row]
        }
        else {
            return ouPickerDataSource[row]
        }
    }
    
    /**
     Called by the picker view when the user selects a row in a component.
     To determine what value the user selected, the delegate uses the row index to access the value at the corresponding position in the array used to construct the component.
     - Parameters:
        - pickerView: An object representing the picker view requesting the data.
        - row: A zero-indexed number identifying a row of component. Rows are numbered top-to-bottom.
        - component: A zero-indexed number identifying a component of pickerView. Components are numbered left-to-right.
    */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //set the strings with the selected data from the pickers each time they change
        if(pickerView == weekdaysPickerView) {
            index = row
            selectedWeekday = weekdaysPickerDataSource[row]
        }
        else if (pickerView == optionsPickerView)  {
            selectedOption = optionsPickerDataSource[row]
        }
        else {
            selectedOu = ouPickerDataSource[row]
        }
        //reload the data
        loadData()
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
        //create the label
        var label = view as! UILabel!
        if label == nil {
            label = UILabel()
        }
        //get the data of the correct picker view
        var data: String
        if(pickerView == weekdaysPickerView) {
            data = weekdaysPickerDataSource[row]
        }
        else if (pickerView == optionsPickerView)   {
            data = optionsPickerDataSource[row]
        }
        else {
            data = ouPickerDataSource[row]
        }
        let title = NSAttributedString(string: data, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightRegular)])
        label?.attributedText = title
        label?.textAlignment = .center
        return label!
        
    }
    
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
        //add the method didBecomeActive as a observer (listener) everytime the aplication becomes active
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        //call didBecomeActive
        didBecomeActive()
    }
    
    /**
     This method is called everytime the view becomes active.
     */
    func didBecomeActive() {
        //set self as datasource and delegate of all pickers
        weekdaysPickerView.delegate = self
        weekdaysPickerView.dataSource = self
        optionsPickerView.delegate = self
        optionsPickerView.dataSource = self
        ouPickerView.delegate = self
        ouPickerView.dataSource = self
        
        //empty weekdays data source
        weekdaysPickerDataSource = [String]()
        
        //create the data source of the weekdays picker (current week's dates)
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        let today = calendar.startOfDay(for: Date())
        var currentDate = Date()
        var interval = TimeInterval()
        _ = calendar.dateInterval(of: .weekOfMonth, start: &currentDate, interval: &interval, for: Date())
        for i in 0..<7 {
            if(currentDate == today && index == -1) {
                index = i
            }
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "pt_BR")
            dateFormatter.dateFormat = "dd/MM/yyyy EEE"
            let date = dateFormatter.string(from: currentDate).capitalized
            weekdaysPickerDataSource.append(date)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        //always select today as the first shown date
        weekdaysPickerView.selectRow(index, inComponent: 0, animated: false)
        //set the strings with the selected data from the pickers
        if(weekdaysPickerDataSource.count > 0) {
            selectedWeekday = weekdaysPickerDataSource[weekdaysPickerView.selectedRow(inComponent: 0)]
        }
        if(optionsPickerDataSource.count > 0) {
            selectedOption = optionsPickerDataSource[optionsPickerView.selectedRow(inComponent: 0)]
        }
        if(ouPickerDataSource.count > 0) {
            selectedOu = ouPickerDataSource[ouPickerView.selectedRow(inComponent: 0)]
        }
        loadData()
    }
    
    /**
     This method is used to load the data in the view.
    */
    func loadData() {
        DispatchQueue.main.async {
            self.appetizerLabel.text = self.selectedWeekday + " - " + self.selectedOption + " - " + self.selectedOu
            self.mainCourseLabel.text = self.selectedWeekday + " - " + self.selectedOption + " - " + self.selectedOu
            self.vegetarianCourseLabel.text = self.selectedWeekday + " - " + self.selectedOption + " - " + self.selectedOu
            self.garrisonLabel.text = self.selectedWeekday + " - " + self.selectedOption + " - " + self.selectedOu
            self.sideDishLabel.text = self.selectedWeekday + " - " + self.selectedOption + " - " + self.selectedOu
            self.desertLabel.text = self.selectedWeekday + " - " + self.selectedOption + " - " + self.selectedOu
            self.drinkLabel.text = self.selectedWeekday + " - " + self.selectedOption + " - " + self.selectedOu
        }
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
    
}

