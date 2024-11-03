//
//  DateComponentsFormatterExtension.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 17.04.2024.
//

import Foundation
extension DateComponentsFormatter{
    static let abbreviated : DateComponentsFormatter = {
        print("Initializing DateComponentsFormatter.abbreviated")
        let formatter = DateComponentsFormatter ()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter
    }()
    static let positional: DateComponentsFormatter = {
        print("Ilitializing DateComponentsFormatter.positional")
        let formatter = DateComponentsFormatter ()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
}
