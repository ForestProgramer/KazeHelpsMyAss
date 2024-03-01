//
//  AudioTourCollectionViewCell.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 28.12.2023.
//

import UIKit
import SkeletonView
class AudioTourCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var tourImageView: UIImageView!
    @IBOutlet weak var tourNameLabel: UILabel!
    @IBOutlet weak var timeTourLabel: UILabel!
    @IBOutlet weak var distanceTourLabel: UILabel!
    @IBOutlet weak var priceTourLabel: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        contentView.layer.cornerRadius = 20
        layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
        contentView.isSkeletonable = true
        blurView.layer.cornerRadius = 12
        blurView.clipsToBounds = true
        timeTourLabel.textColor = .white
        distanceTourLabel.textColor = .white
    }
    @IBAction func didTapLikeBtn(_ sender: Any) {
    }
    func setup(with guide: AudioTour ) {
        if let url = URL(string: guide.photoName){
            print("Done photo")
            tourImageView.sd_setImage(with: url, completed: nil)
        }
        print("tourDurationLabel : \(guide.duration)")
        tourNameLabel.text = guide.name
        timeTourLabel.text = guide.duration + " m"
        distanceTourLabel.text = guide.distance + " km"
        priceTourLabel.text = "$" + guide.price
    }
}
