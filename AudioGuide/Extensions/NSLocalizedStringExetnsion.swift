//
//  NSLocalizedStringExetnsion.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 01.02.2022.
//

import Foundation

class UVLocalizedString {
    
    class func localizedString(_ key: String, comment: String = "") -> String {
        if let lang = UserDefaults.currentLocate, let path = Bundle.main.path(forResource: lang, ofType: "lproj"), let bundle = Bundle(path: path) {
                return NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: comment)
        }
        return NSLocalizedString(key, comment: comment)
    }
}
