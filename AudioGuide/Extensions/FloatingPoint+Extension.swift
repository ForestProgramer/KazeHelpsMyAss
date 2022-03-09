//
//  FloatingPoint+Extension.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 09.03.2022.
//

import Foundation

extension FloatingPoint {
    func toRadians() -> Self {
        return self * .pi / 180
    }
    
    func toDegrees() -> Self {
        return self * 180 / .pi
    }
}
