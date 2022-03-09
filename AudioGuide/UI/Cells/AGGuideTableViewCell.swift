//
//  AGGuideTableViewCell.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 21.02.2022.
//

import UIKit

class AGGuideTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setup() {
        self.bgView.image = UIImage(named: "guide_content_icon")
    }
}

