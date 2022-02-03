//
//  UITextFieldExtension.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 01.02.2022.
//

import UIKit

extension UITextField {
    var clearButton: UIButton? {
        return value(forKey: "clearButton") as? UIButton
    }

    var clearButtonTintColor: UIColor? {
        get {
            return clearButton?.tintColor
        }
        set {
            let image =  clearButton?.imageView?.image?.withRenderingMode(.alwaysTemplate)
            clearButton?.setImage(image, for: .normal)
            clearButton?.tintColor = newValue
        }
    }
}
