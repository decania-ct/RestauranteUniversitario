//
//  Localizator.swift
//  RestauranteUniversitario
//
//  Created by Felipe Podolan Oliveira on 21/11/2017.
//  Copyright © 2017 Felipe Podolan Oliveira. All rights reserved.
//

import Foundation

/**
 This class allows to get strings from the Strings plist (proprietary list) so the code's maintainability is assured.
 */
private class Localizator {
    /// A shared instance of this class
    static let sharedInstance = Localizator()
    
    /// The main dictionary from the plist
    lazy var localizableDictionary: NSDictionary! = {
        if let path = Bundle.main.path(forResource: "Strings", ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }
        fatalError("Localizable file NOT found")
    }()
    
    /**
     This method localises the string value of the given string key in the main dictionary of the plist
    */
    func localize(string: String) -> String {
        guard let localizedString = localizableDictionary.value(forKey: string) as? String else {
            assertionFailure("Missing translation for: \(string)")
            return ""
        }
        return localizedString
    }
}

/**
 This extension allow the use of the localize method from the Localizator class in strings
*/
extension String {
    /// the localized var to be added to strings (keys in the dictionay of the Strings plist)
    var localized: String {
        return Localizator.sharedInstance.localize(string: self)
    }
}
