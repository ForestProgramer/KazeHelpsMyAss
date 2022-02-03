//
//  DictionaryExtension.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 01.02.2022.
//

import Foundation

extension Dictionary {
    
    func toJsonString() -> String? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: []) {
            if let jsonString = String(data: jsonData, encoding: String.Encoding.ascii) {
                return jsonString
            }
            return nil
        }
        return nil
    }
}
