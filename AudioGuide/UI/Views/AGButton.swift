//
//  AGButton.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 01.02.2022.
//

import UIKit
import NoticeObserveKit

class AGButton: UIButton {

    @IBInspectable var gradientBgColor1: UIColor = UIColor(named: "AccentColor")!
    @IBInspectable var gradientBgColor2: UIColor = UIColor(named: "AccentColor")!
    @IBInspectable var gradientBgColor3: UIColor = UIColor(named: "AccentColor")!
    @IBInspectable var gradientBgColor4: UIColor = UIColor(named: "AccentColor")!
    
    @IBInspectable var isGradientEnabled: Bool = false {
        didSet {
            self.updateEnabled()
        }
    }
    
    @IBInspectable var buttonTitleActiveColor: UIColor = UIColor.white {
        didSet {
            self.updateEnabled()
        }
    }
    
    
    @IBInspectable var buttonTitleInactiveColor: UIColor = UIColor.white {
        didSet {
            self.updateEnabled()
        }
    }
    
    
    @IBInspectable var backgroundActiveColor: UIColor = UIColor(named: "AccentColor") ?? .red {
        didSet {
            self.backgroundColor = self.backgroundInactiveColor
        }
    }
    
    @IBInspectable var backgroundInactiveColor: UIColor = UIColor(named: "AccentHalfColor") ?? UIColor.gray {
        didSet {
            self.backgroundColor = self.backgroundInactiveColor
        }
    }
    
    @IBInspectable var buttonTitle: String? {
        didSet {
            self.updateEnabled()
        }
    }
    
    var titleFont: UIFont = UIFont.PoppinsFont(ofSize: 18) {
        didSet {
            self.updateEnabled()
        }
    }
    
    @IBInspectable var corenerRadius: CGFloat = 10 {
        didSet {
            self.layer.cornerRadius = corenerRadius
            self.clipsToBounds = true
        }
    }
    
    private let pool = NoticeObserverPool()
    private var gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.updateEnabled()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.updateEnabled()
    }
    
    override var isEnabled: Bool {
        didSet {
            self.updateEnabled()
        }
    }
    
    private func updateEnabled() {
        self.layer.cornerRadius = self.corenerRadius
        self.clipsToBounds = true
        if self.isEnabled {
            self.backgroundColor = self.backgroundActiveColor
            self.setAttributedTitle(NSAttributedString(string: self.buttonTitle ?? "", attributes: [NSAttributedString.Key.font: self.titleFont, NSAttributedString.Key.foregroundColor: self.buttonTitleActiveColor]), for: .normal)
            self.setTitleColor(self.buttonTitleActiveColor, for: .normal)
        } else {
            self.backgroundColor = self.backgroundInactiveColor
            self.setAttributedTitle(NSAttributedString(string: self.buttonTitle ?? "", attributes: [NSAttributedString.Key.font: self.titleFont, NSAttributedString.Key.foregroundColor: self.buttonTitleInactiveColor]), for: .normal)
            self.setTitleColor(self.buttonTitleInactiveColor, for: .normal)
        }
    }
}
