//
//  OnBoard3View.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 01.11.2023.
//

import UIKit

class OnBoard3View: UIView {
    @IBOutlet weak var tryLatterBtn: UIButton!
    @IBOutlet weak var startTrialOrExploreAppBtn: UIButton!
    
    func setUpBtn(){
        tryLatterBtn.layer.borderColor = UIColor(hexString: "#973939").cgColor
        tryLatterBtn.layer.borderWidth = 1
        tryLatterBtn.layer.cornerRadius = 10
        startTrialOrExploreAppBtn.layer.cornerRadius = 10
    }
}
