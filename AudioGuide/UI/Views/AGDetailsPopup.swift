//
//  AGDetailsPopup.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 03.02.2022.
//

import UIKit

class AGDetailsPopup: UIView {

    var tapAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AGDetailsPopup.handleTap( _:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func handleTap(_ gestureReconizer: UITapGestureRecognizer) {
        self.tapAction?()
    }
}
