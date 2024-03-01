//
//  AGCafeCollectionViewCell.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 14.02.2022.
//

import UIKit

class AGCafeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var pointCafeLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setup(with cafe : Cafe) {
        imageView.image = UIImage(named: cafe.photoName)
        pointCafeLabel.text = cafe.rating
    }
}
