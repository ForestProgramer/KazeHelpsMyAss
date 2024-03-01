//
//  ResultTourUICoCollectionViewCell.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 06.02.2024.
//

import UIKit
import SkeletonView
class ResultTourUICoCollectionViewCell: UICollectionViewCell {
    static let identifier = "ResultTourUICoCollectionViewCell"
    let resultTourImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        return imageView
    }()
    //MARK: BluredView
    let bluredView : UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let tourTitleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .PoppinsFont(ofSize: 15, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    let descView : UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let durationIcon : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "tourTimeIcon")
        return imageView
    }()
    let durationTourLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .PoppinsFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    let distanceIcon : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "locationIcon")
        return imageView
    }()
    let distanceTourLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .PoppinsFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    //End
    let priceView : UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let priceImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "priceBackGroundIcon")
        imageView.clipsToBounds = true
        return imageView
    }()
    let priceLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .PoppinsFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hexString: "#973939")
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isSkeletonable = true
        contentView.isSkeletonable = true
        setUPContraints()
    }
    required init?(coder: NSCoder) {
        fatalError("Unexprected error")
    }
    private func setUPContraints(){
        addSubview(resultTourImageView)
        addSubview(bluredView)
        bluredView.contentView.addSubview(tourTitleLabel)
        bluredView.contentView.addSubview(priceView)
        priceView.addSubview(priceImageView)
        priceView.addSubview(priceLabel)
        bluredView.contentView.addSubview(descView)
        descView.addSubview(durationIcon)
        descView.addSubview(durationTourLabel)
        descView.addSubview(distanceIcon)
        descView.addSubview(distanceTourLabel)
//        addSubview(resulStreetLabel)
        NSLayoutConstraint.activate([
            resultTourImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            resultTourImageView.topAnchor.constraint(equalTo: topAnchor),
            resultTourImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            resultTourImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            bluredView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            bluredView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            bluredView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            bluredView.topAnchor.constraint(equalTo: topAnchor, constant: 173),
            
            tourTitleLabel.leadingAnchor.constraint(equalTo: bluredView.leadingAnchor,constant: 8),
            tourTitleLabel.topAnchor.constraint(equalTo: bluredView.topAnchor,constant: 4),
            tourTitleLabel.trailingAnchor.constraint(equalTo: bluredView.trailingAnchor,constant: -8),
            tourTitleLabel.bottomAnchor.constraint(equalTo: bluredView.bottomAnchor,constant: -27),
            
            priceView.leadingAnchor.constraint(equalTo: bluredView.leadingAnchor,constant: 180),
            priceView.topAnchor.constraint(equalTo: tourTitleLabel.bottomAnchor,constant: 4),
            priceView.bottomAnchor.constraint(equalTo: bluredView.bottomAnchor),
            priceView.trailingAnchor.constraint(equalTo: bluredView.trailingAnchor),
            
            
            priceImageView.leadingAnchor.constraint(equalTo: priceView.leadingAnchor),
            priceImageView.topAnchor.constraint(equalTo: priceView.topAnchor),
            priceImageView.trailingAnchor.constraint(equalTo: priceView.trailingAnchor),
            priceImageView.bottomAnchor.constraint(equalTo: priceView.bottomAnchor),
            
            priceLabel.centerYAnchor.constraint(equalTo: priceView.centerYAnchor),
            priceLabel.centerXAnchor.constraint(equalTo: priceView.centerXAnchor),
            
            descView.leadingAnchor.constraint(equalTo: bluredView.leadingAnchor,constant: 8),
            descView.bottomAnchor.constraint(equalTo: bluredView.bottomAnchor,constant: -4),
            descView.topAnchor.constraint(equalTo: tourTitleLabel.bottomAnchor,constant: 4),
            descView.trailingAnchor.constraint(equalTo: bluredView.trailingAnchor,constant: -20),
            
            durationIcon.leadingAnchor.constraint(equalTo: descView.leadingAnchor),
            durationIcon.centerYAnchor.constraint(equalTo: descView.centerYAnchor),
            durationIcon.heightAnchor.constraint(equalToConstant: 12),
            durationIcon.widthAnchor.constraint(equalToConstant: 12),
            
            durationTourLabel.leadingAnchor.constraint(equalTo: durationIcon.trailingAnchor,constant: 4),
            durationTourLabel.centerYAnchor.constraint(equalTo: durationIcon.centerYAnchor),
            
            
            distanceIcon.leadingAnchor.constraint(equalTo: durationTourLabel.trailingAnchor,constant: 8),
            distanceIcon.centerYAnchor.constraint(equalTo: descView.centerYAnchor),
            distanceIcon.heightAnchor.constraint(equalToConstant: 12),
            distanceIcon.widthAnchor.constraint(equalToConstant: 12),
            
            distanceTourLabel.leadingAnchor.constraint(equalTo: distanceIcon.trailingAnchor,constant: 4),
            distanceTourLabel.centerYAnchor.constraint(equalTo: distanceIcon.centerYAnchor),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 20 // Радіус круга вашої contentView
        layer.masksToBounds = true// Приховати контент, який виходить за межі радіус
        resultTourImageView.layer.masksToBounds = true
        bluredView.layer.cornerRadius = 12 // Радіус круга вашої bluredView
        bluredView.layer.masksToBounds = true
    }
    
    func setup(with guide: AudioTour) {
        if let url = URL(string: guide.photoName){
            resultTourImageView.sd_setImage(with: url, completed: nil)
        }
        tourTitleLabel.text = guide.name
        durationTourLabel.text = guide.duration + " m"
        distanceTourLabel.text = guide.distance + " km"
        priceLabel.text = "$" + guide.price
        
        resultTourImageView.clipsToBounds = true
    }
}
