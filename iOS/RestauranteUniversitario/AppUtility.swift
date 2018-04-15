//
//  AppUtility.swift
//  RestauranteUniversitario
//
//  Created by Felipe Podolan Oliveira on 07/07/17.
//  Copyright © 2017 Felipe Podolan Oliveira. All rights reserved.
//

import UIKit
import SystemConfiguration

/**
 This is an UIView extension to do aditional configuration and methods to the UIView default class.
 */
extension UIView {
    /**
     This method allows the animation of an UIView to rotate 360 degrees.
     - Parameters:
        - duration: The duration of the animation. Aka how long it takes to rotate 360 degrees.
        - completionDelegate: the delegate of the CAAnimationDelegate.
    */
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        //build the rotation animation
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(.pi * 2.0)
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate as? CAAnimationDelegate
        }
        // add the rotation to the view
        self.layer.add(rotateAnimation, forKey: nil)
    }
    
    /**
     This method adds a gradient background to an UIView.
     - Parameters:
        - colors: the colors of the gradient.
        - locations: the location that the gradient will be added in the view
        - isTicket: a boolean that is true if it's being added to the TicketControllerView and false otherwise.
     */
    func addGradient(colors: [UIColor], locations: [NSNumber], isTicket: Bool) {
        addSubview(GradientView(addTo: self, colors: colors, locations: locations, isTicket: isTicket))
    }
    
    /**
     This method is used to add a label to an UIView. It is used for the "Carregando..." message to be displayed properly in the middle of the parent view.
     - Parameters:
        - text: the text to be added which for this application is always "Carregando...".
    */
    func addAdaptativeLabel(text: String) {
        // screen width and height:
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        // creates the label
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        label.text = text
        
        // you can change the content mode:
        label.contentMode = UIViewContentMode.scaleAspectFill
        
        self.addSubview(label)
        self.sendSubview(toBack: label)
    }
}

/**
 This struct provides utilities for the application that might be used by other classes and structs.
 */
struct AppUtility {
    
    /**
     Convert an hexadecimal string to an UIColor object.
     - Parameters:
        - hex: the hexadecimal string to be encoded.
     - Returns: The UIColor object of the hexadecimal color.
    */
    static func hexStringToUIColor (hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // removes the # character if it begins with it
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        //verify if the number of characters is 6
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    /**
     This method encodes a string to a QRCode image.
     - Parameters:
        - string: the string to be encoded.
     - Returns: UIImage of the QRCode encoding the string.
    */
    static func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        //build the image
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.applying(transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
    /**
     This method saves the identity value typed in a given text field, if a given switch is on
     - Parameters:
        - textFieldId: the text field where the identity is being typed
        - switchIdentity: the switch that gives the user the option to save the identity or not
    */
    static func saveIdentity(_ textField: UITextField, _ switchIdentity: UISwitch) {
        //save the identity if the switch changes to on or an empty value if it changes to off
        if switchIdentity.isOn {
            UserDefaults.standard.set(textField.text, forKey: "User Identity")
        }
        else {
            UserDefaults.standard.set("", forKey: "User Identity")
        }
    }
    
    /**
     This method adds a listener to the switch which gives to the user the option to save the identity value typed in a given text field
     - Parameters:
        - textID: the text field where the identity is being typed
        - switchButton: the switch that gives the user the option to save the identity or not
    */
    static func switchChangeListener(_ switchButton: UISwitch, _ textID: UITextField) {
        //save the identity if the switch changes to on or an empty value if it changes to off
        if switchButton.isOn {
            UserDefaults.standard.set(textID.text, forKey: "User Identity")
        }
        else {
            UserDefaults.standard.set("", forKey: "User Identity")
        }
    }
    
    /**
     This method retrieves the identity saved in the device and puts it in the textField, it also sets the given switch to on if there are any identity saved or to off otherwise
     - Parameters:
        - textFieldId: the text field where the identity is set
        - switchIdentity: the switch that gives the user the option to save the identity or not
     */
    static func retrieveIdentity(_ textField: UITextField, _ switchIdentity: UISwitch) {
        //get the saved identity
        let savedCPF = UserDefaults.standard.string(forKey: "User Identity")

        //set the saved identity in the text field
        textField.text = savedCPF
        
        //change the switch to on if there are any identity saved or to off otherwise
        if(savedCPF != nil) {
            if !(savedCPF?.isEmpty)! {
                switchIdentity.setOn(true, animated: false)
            }
            else {
                switchIdentity.setOn(false, animated: false)
            }
        }
    }
    /**
        This method modifies the appearance of the switch buttons to a color that suits better the app and to a smaller sizer
     - Parameters:
        - switchIdentity: the switch to be modified
     */
    static func modifySwitchAppearance(_ switchIdentity: UISwitch) {
        //change the color
        switchIdentity.onTintColor = AppUtility.hexStringToUIColor(hex: "#029100")
        //decrease the size
        switchIdentity.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    }
    
    /**
     This method resizes an UIImage to another UIImage of a given size keeping the aspect ratio.
     - Parameters:
        - image: The UIImage to be resized
        - targetSize: The desired size of the image
     - Returns: UIImage resized with the given size
    */
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    static func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
    
}
