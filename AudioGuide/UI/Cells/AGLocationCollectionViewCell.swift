//
//  AGLocationCollectionViewCell.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 14.02.2022.
//

import UIKit

class AGLocationCollectionViewCell: UICollectionViewCell {
    
//    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var locationsIconsImageView: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup() {
        if let image = UIImage(named: "locationCell"){
            locationsIconsImageView.image = image
            }
//        contentView.backgroundColor = .blue
    }
}

