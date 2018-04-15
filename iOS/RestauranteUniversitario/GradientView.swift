//
//  GradientView.swift
//  RestauranteUniversitario
//
//  Created by Felipe Podolan Oliveira on 10/07/17.
//  Copyright © 2017 Felipe Podolan Oliveira. All rights reserved.
//

import UIKit
/**
 This class creates a gradient view with a set of colors.
*/
class GradientView: UIView {
    /// The gradient layer to be added to the view
    private var gradient = CAGradientLayer()
    
    /**
     Init (constructor)
     - Parameters:
        - parentView: The view to which the gradient is going to be added.
        - colors: The gradient colors.
        - locations: The locations of the colors in the view.
        - isTicket: True if the gradient is being added to a ticket view. False otherwire.
    */
    init(addTo parentView: UIView, colors: [UIColor], locations: [NSNumber], isTicket: Bool){
        
        super.init(frame: CGRect(x: 0, y: 0, width: 1, height: 2))
        restorationIdentifier = "__ViewWithGradient"
        
        for subView in parentView.subviews {
            if let subView = subView as? GradientView {
                if subView.restorationIdentifier == restorationIdentifier {
                    subView.removeFromSuperview()
                    break
                }
            }
        }
        
        let cgColors = colors.map { (color) -> CGColor in
            return color.cgColor
        }
        
        gradient.frame = parentView.frame
        gradient.colors = cgColors
        gradient.locations = locations
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        backgroundColor = .clear
        
        parentView.addSubview(self)
        parentView.layer.insertSublayer(gradient, at: 0)
        parentView.backgroundColor = .clear
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if(!isTicket) {
            gradient.frame = CGRect(x: -8.0, y: -2.0, width: parentView.frame.size.width+8.0, height: parentView.frame.size.height+2.0)
            parentView.layer.cornerRadius = 20.0
            parentView.layer.borderWidth = 5
            parentView.layer.borderColor = UIColor.white.cgColor
        }
        
        clipsToBounds = true
        parentView.layer.masksToBounds = true
        
    }
    
    /**
     init (constructor)
     - Parameters:
        - aDecoder: an NSCoder object
    */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Lays out subviews.
     The default implementation of this method does nothing on iOS 5.1 and earlier. Otherwise, the default implementation uses any constraints you have set to determine the size and position of any subviews.
     Subclasses can override this method as needed to perform more precise layout of their subviews. You should override this method only if the autoresizing and constraint-based behaviors of the subviews do not offer the behavior you want. You can use your implementation to set the frame rectangles of your subviews directly.
     You should not call this method directly. If you want to force a layout update, call the setNeedsLayout() method instead to do so prior to the next drawing update. If you want to update the layout of your views immediately, call the layoutIfNeeded() method.
    */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let parentView = superview {
            gradient.frame = parentView.bounds
        }
    }
    
    /**
     Unlinks the view from its superview and its window, and removes it from the responder chain.
     If the view’s superview is not nil, the superview releases the view.
     Calling this method removes any constraints that refer to the view you are removing, or that refer to any view in the subtree of the view you are removing.
     - Important:
     Never call this method from inside your view’s draw(_:) method.
    */
    override func removeFromSuperview() {
        super.removeFromSuperview()
        gradient.removeFromSuperlayer()
    }
}
