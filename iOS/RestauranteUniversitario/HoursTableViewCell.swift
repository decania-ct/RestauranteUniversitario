//
//  HoursTableViewCell.swift
//  RestauranteUniversitario
//
//  Created by Felipe Podolan Oliveira on 02/08/17.
//  Copyright © 2017 Felipe Podolan Oliveira. All rights reserved.
//

import UIKit

class HoursTableViewCell: UITableViewCell {

    /// The restaurante name label
    @IBOutlet var restaurantName: UILabel!
    /// The week lunch label
    @IBOutlet var weekLunch: UILabel!
    /// The week dinner label
    @IBOutlet var weekDinner: UILabel!
    /// The weekend lunch label
    @IBOutlet var weekendLunch: UILabel!
    /// THe weekend dinner label
    @IBOutlet var weekendDinner: UILabel!
    /// The student price label
    @IBOutlet var studentPrice: UILabel!
    /// The worker price label
    @IBOutlet var workerPrice: UILabel!
    
    /**
     Prepares the receiver for service after it has been loaded from an Interface Builder archive, or nib file.
     The nib-loading infrastructure sends an awakeFromNib message to each object recreated from a nib archive, but only after all the objects in the archive have been loaded and initialized. When an object receives an awakeFromNib message, it is guaranteed to have all its outlet and action connections already established.
     You must call the super implementation of awakeFromNib to give parent classes the opportunity to perform any additional initialization they require. Although the default implementation of this method does nothing, many UIKit classes provide non-empty implementations. You may call the super implementation at any point during your own awakeFromNib method.
     - Note:
     During Interface Builder’s test mode, this message is also sent to objects instantiated from loaded Interface Builder plug-ins. Because plug-ins link against the framework containing the object definition code, Interface Builder is able to call their awakeFromNib method when present. The same is not true for custom objects that you create for your Xcode projects. Interface Builder knows only about the defined outlets and actions of those objects; it does not have access to the actual code for them.
     During the instantiation process, each object in the archive is unarchived and then initialized with the method befitting its type. Objects that conform to the NSCoding protocol (including all subclasses of UIView and UIViewController) are initialized using their initWithCoder: method. All objects that do not conform to the NSCoding protocol are initialized using their init method. After all objects have been instantiated and initialized, the nib-loading code reestablishes the outlet and action connections for all of those objects. It then calls the awakeFromNib method of the objects. For more detailed information about the steps followed during the nib-loading process, see Nib Files in Resource Programming Guide.
     - Important:
     Because the order in which objects are instantiated from an archive is not guaranteed, your initialization methods should not send messages to other objects in the hierarchy. Messages to other objects can be sent safely from within an awakeFromNib method.
     Typically, you implement awakeFromNib for objects that require additional set up that cannot be done at design time. For example, you might use this method to customize the default configuration of any controls to match user preferences or the values in other controls. You might also use it to restore individual controls to some previous state of your application.
     */
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    /**
     Sets the selected state of the cell, optionally animating the transition between states.
     The selection affects the appearance of labels, image, and background. When the selected state of a cell is true, it draws the background for selected cells (Reusing Cells) with its title in white.
     - Parameters:
        - selected: true to set the cell as selected, false to set it as unselected. The default is false.
        - animated: true to animate the transition between selected states, false to make the transition immediate.
     */
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
