//
//  AGInfrastructureTableViewCell.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 10.02.2022.
//

import UIKit

class AGInfrastructureTableViewCell: UITableViewCell {

    @IBOutlet private weak var content: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setup(index: Bool) {
        self.content.image = index ? UIImage(named: "popArt_icon") : UIImage(named: "lviv_icon")
    }
}
