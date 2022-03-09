//
//  AGDetailsCollectionViewCell.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 23.02.2022.
//

import UIKit

class AGDetailsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setup() {
        self.imageView.image = UIImage(named: "details_cell_icon")
    }
}
