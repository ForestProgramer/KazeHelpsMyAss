//
//  AGCuideCollectionViewCell.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 14.02.2022.
//

import UIKit
import SDWebImage
protocol AGGuideCollectionViewCellDelegate: AnyObject {
    func guideCellDidTapLikeButton()
}
class AGGuideCollectionViewCell: UICollectionViewCell {
    static let identifier = "AGGuideCollectionViewCell"
    weak var delegate: AGGuideCollectionViewCellDelegate?

    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var tourImageView: UIImageView!
    @IBOutlet weak var tourBlurView: UIVisualEffectView!
    @IBOutlet weak var tourNameLabel: UILabel!
    @IBOutlet weak var tourDurationLabel: UILabel!
    @IBOutlet weak var tourDistanceLabel: UILabel!
    @IBOutlet weak var tourPriceLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 20
        tourBlurView.layer.cornerRadius = 12
        tourDurationLabel.textColor = .white
        tourDistanceLabel.textColor = .white
    }
    
    @IBAction func didTapLikeBtn(_ sender: Any) {
        if let bearerToken = UserDefaults.userBearerToken as? String{
            /// now nothing to do
        }else{
            ///показуєм поп-ап
            delegate?.guideCellDidTapLikeButton()
        }
    }
    func setup(with guide: AudioTour) {
        if let url = URL(string: guide.photoName){
            print("Done photo")
            tourImageView.sd_setImage(with: url, completed: nil)
        }
        print("tourDurationLabel : \(guide.duration)")
        tourNameLabel.text = guide.name
        tourDurationLabel.text = guide.duration + " m"
        tourDistanceLabel.text = guide.distance + " km"
        tourPriceLabel.text = "$" + guide.price
        
        
    }
}
