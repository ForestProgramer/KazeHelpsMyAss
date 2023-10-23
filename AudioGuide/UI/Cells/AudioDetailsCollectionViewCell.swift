//
//  AGDetailsCollectionViewCell.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 23.02.2022.
//

import UIKit

class AudioDetailsCollectionViewCell: UICollectionViewCell {
    
    var imageView : UIImageView = {
       var image = UIImageView(frame: CGRect(x: 0, y: 0, width: 132, height: 128))
        image.contentMode = .scaleAspectFit
        return image
    }()
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setUp() {
        self.contentView.addSubview(imageView)
        if let image = UIImage(named: "otherToursImages"){
            self.imageView.image = image
        }
        
    }
}
