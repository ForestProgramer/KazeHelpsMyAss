//
//  DateExtension.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 01.02.2022.
//

import Foundation

extension Date {
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    static func timestampString(timeInterval: TimeInterval) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.maximumUnitCount = 0
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: timeInterval)
    }
}

extension TimeInterval{
    
    func stringFromTimeInterval() -> String {
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        return String(format: "%3d",ms)
    }
}
