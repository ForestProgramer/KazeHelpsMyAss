//
//  AGLocationCollectionViewCell.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 14.02.2022.
//

import UIKit
import SDWebImage
class AGLocationCollectionViewCell: UICollectionViewCell {
    static let identifier = "AGLocationCollectionViewCell"
    static let resultIdentifier = "ResultIdentifier"
    @IBOutlet weak var locationsIconsImageView: UIImageView!
    @IBOutlet weak var nameLocationLabel: UILabel!
    @IBOutlet weak var adressLocationLabel: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    func setup(with location : Location) {
        print("Location url : \(location.photoName) ")
        let urlImage = location.photoName
        if let url = URL(string: urlImage){
            print("Succes URl")
            locationsIconsImageView.sd_setImage(with: url) { image, error, _, _ in
                if let error = error{
                    print("Image error : \(error)")
                }else{
                    self.locationsIconsImageView.image = image
                }
            }
        }
        nameLocationLabel.text = location.name
        adressLocationLabel.text = location.street
        
    }
}

