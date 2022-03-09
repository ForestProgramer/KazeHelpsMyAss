//
//  AGIntrastingTableViewCell.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 09.02.2022.
//

import UIKit

class AGIntrastingTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: AGLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func setup(item: String) {
        self.titleLabel.text = item
    }

}
