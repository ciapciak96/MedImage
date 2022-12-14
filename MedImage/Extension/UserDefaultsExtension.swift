//
//  UserDefaultsExtension.swift
//  MedImage
//
//  Created by Vanda S. on 30/11/2022.
//

import UIKit

extension UserDefaults {
    
    private enum UserDefaultsKeys: String {
        case hasOnboarded
    }
    
    var hasOnboarded: Bool {
        get {
            bool(forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
        
        set {
            setValue(newValue, forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
    }
}
