//
//  AGCuideCollectionViewCell.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 14.02.2022.
//

import UIKit

class AGCuideCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setup() {
        self.imageView.image = UIImage(named: "guide_cell_icon")
    }
}
