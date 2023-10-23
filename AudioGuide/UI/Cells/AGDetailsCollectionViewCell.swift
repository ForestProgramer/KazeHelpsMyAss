//
//  AGDetailsCollectionViewCell.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 13.10.2023.
//

import UIKit
class AGDetailsCollectionViewCell: UICollectionViewCell {
    
    var otherSidesimageViews : UIImageView = {
       var image = UIImageView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setup() {
        contentView.addSubview(otherSidesimageViews)
        if let image = UIImage(named: "otherToursImages"){
            self.otherSidesimageViews.image = image
        }
        
    }
}
