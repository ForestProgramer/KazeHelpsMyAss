//
//  UserDefaultsExtension.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 01.02.2022.
//

import Foundation
import UIKit

extension UserDefaults {
    
    static var isOnboard: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: "isOnboard")
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: "isOnboard")
            } else {
                UserDefaults.standard.removeObject(forKey: "isOnboard")
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isFreeVersion: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: "isFreeVersion")
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: "isFreeVersion")
            } else {
                UserDefaults.standard.removeObject(forKey: "isFreeVersion")
            }
            UserDefaults.standard.synchronize()
        }
    }
    static var isUserAuthorizationPassed: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: "isUserAuthorizationPassed")
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: "isUserAuthorizationPassed")
            } else {
                UserDefaults.standard.removeObject(forKey: "isUserAuthorizationPassed")
            }
            UserDefaults.standard.synchronize()
        }
    }
    static var userBearerToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "userBearerToken")
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: "userBearerToken")
            } else {
                UserDefaults.standard.removeObject(forKey: "userBearerToken")
            }
            UserDefaults.standard.synchronize()
        }
    }
    static var userID: String? {
        get {
            return UserDefaults.standard.string(forKey: "userID")
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: "userID")
            } else {
                UserDefaults.standard.removeObject(forKey: "userID")
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    static var userEmail: String? {
        get {
            return UserDefaults.standard.string(forKey: "userEmail")
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: "userEmail")
            } else {
                UserDefaults.standard.removeObject(forKey: "userEmail")
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    static var userOrignPassword: String? {
        get {
            return UserDefaults.standard.string(forKey: "userOrignPassword")
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: "userOrignPassword")
            } else {
                UserDefaults.standard.removeObject(forKey: "userOrignPassword")
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    static var userPassword: String? {
        get {
            return UserDefaults.standard.string(forKey: "userPassword")
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: "userPassword")
            } else {
                UserDefaults.standard.removeObject(forKey: "userPassword")
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    static var currentLocate: String? {
        get {
            return UserDefaults.standard.string(forKey: "currentLocate")
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: "currentLocate")
            } else {
                UserDefaults.standard.removeObject(forKey: "currentLocate")
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isFirstLaunchPassed: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: "isFirstLaunch")
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: "isFirstLaunch")
            } else {
                UserDefaults.standard.removeObject(forKey: "isFirstLaunch")
            }
            UserDefaults.standard.synchronize()
        }
    }
}

