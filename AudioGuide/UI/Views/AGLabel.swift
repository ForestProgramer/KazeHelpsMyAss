//
//  AGLabel.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 01.02.2022.
//

import UIKit

class AGLabel: UILabel {

    @IBInspectable var lineSpace: CGFloat = 0 {
        didSet {
            self.updateText()
        }
    }
    
    @IBInspectable var lineHeight: CGFloat = -1 {
        didSet {
            self.updateText()
        }
    }
    @IBInspectable var kernSpace: CGFloat = 0 {
        didSet {
            self.updateText()
        }
    }
    
    @IBInspectable var forceUppercase: Bool = false {
        didSet {
            self.updateText()
        }
    }
    
    @IBInspectable var throughLine: Bool = false {
        didSet {
            self.updateText()
        }
    }
    
    @IBInspectable var boldString: String? = nil  {
        didSet {
            self.updateText()
        }
    }
    
    override var text: String? {
        didSet {
            self.updateText()
        }
    }

    private func updateText() {
        if let text = self.text {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpace
            if self.lineHeight >= 0 {
                paragraphStyle.maximumLineHeight = self.lineHeight
                paragraphStyle.minimumLineHeight = self.lineHeight
            }
            paragraphStyle.alignment = self.textAlignment
            paragraphStyle.lineBreakMode = self.lineBreakMode
            let attributedString = NSMutableAttributedString(string: self.forceUppercase ? text.uppercased() : text, attributes: [NSAttributedString.Key.font: self.font, NSAttributedString.Key.foregroundColor: self.textColor, NSAttributedString.Key.kern: self.kernSpace, NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.strikethroughStyle: self.throughLine ? NSUnderlineStyle.single.rawValue : 0, NSAttributedString.Key.strikethroughColor: self.textColor])
            if let boldString = self.boldString {
                let range = (text as NSString).range(of: boldString)
                attributedString.addAttributes( [NSAttributedString.Key.font: UIFont.PoppinsFont(ofSize: 16, weight: .semibold)], range: range)
            }
            self.attributedText = attributedString
        } else {
            self.attributedText = nil
        }
    }

}

