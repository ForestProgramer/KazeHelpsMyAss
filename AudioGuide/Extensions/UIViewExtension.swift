//
//  UIViewExtension.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 07.03.2024.
//

import UIKit

extension UIView {
    var viewBeforeWindow: UIView? {
        if let superview = superview, superview is UIWindow {
            return self
        }
        return superview?.viewBeforeWindow
    }
    
    var allSubviews: [UIView] {
        return subviews.flatMap { [$0] + $0.allSubviews }
    }
    
}
