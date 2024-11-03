//
//  DescCollectionViewCell.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 05.03.2024.
//

import UIKit
import SDWebImage
class DescCollectionViewCell: UICollectionViewCell {
    static let identifier  = "DescCollectionViewCell"
    let tourImageView : UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let visualEffectView: UIVisualEffectView = {
        // Створення ефекту, який буде використовуватися для ефекту візуалізації
        let blurEffect = UIBlurEffect(style: .dark)
        
        // Ініціалізація UIVisualEffectView з використанням ефекту
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.translatesAutoresizingMaskIntoConstraints = false
        return effectView
    }()
    let locationGuideLabel : UILabel = {
        let label = UILabel()
        label.font = .PoppinsFont(ofSize: 14,weight: .medium)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let durationTourImageView : UIImageView = {
       let imageView = UIImageView(image: UIImage(named: "tourTimeIcon"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let durationLabel : UILabel = {
        let label = UILabel()
        label.font = .PoppinsFont(ofSize: 12,weight: .ultraLight)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let locationTourImageView : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "locationIcon2"))
         imageView.contentMode = .scaleAspectFit
         imageView.translatesAutoresizingMaskIntoConstraints = false
         return imageView
     }()
    let distanceLabel : UILabel = {
        let label = UILabel()
        label.font = .PoppinsFont(ofSize: 12,weight: .ultraLight)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let priceImageView : UIImageView = {
       let imageView = UIImageView(image: UIImage(named: "priceBackGroundIcon"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let priceLabel : UILabel = {
        let label = UILabel()
        label.font = .PoppinsFont(ofSize: 14,weight: .ultraLight)
        label.textColor = UIColor(hexString: "#973939")
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUpUI(){
        addSubview(tourImageView)
        addSubview(visualEffectView)
        visualEffectView.contentView.addSubview(locationGuideLabel)
        visualEffectView.contentView.addSubview(durationTourImageView)
        visualEffectView.contentView.addSubview(durationLabel)
        visualEffectView.contentView.addSubview(locationTourImageView)
        visualEffectView.contentView.addSubview(distanceLabel)
        visualEffectView.contentView.addSubview(priceImageView)
        priceImageView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            tourImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tourImageView.topAnchor.constraint(equalTo: topAnchor),
            tourImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tourImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            visualEffectView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 8),
            visualEffectView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -8),
            visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -8),
            visualEffectView.heightAnchor.constraint(equalToConstant: 73),
            
            locationGuideLabel.leadingAnchor.constraint(equalTo: visualEffectView.leadingAnchor,constant: 8),
            locationGuideLabel.trailingAnchor.constraint(equalTo: visualEffectView.trailingAnchor,constant: -8),
            locationGuideLabel.topAnchor.constraint(equalTo: visualEffectView.topAnchor,constant: 8),
            
            durationTourImageView.leadingAnchor.constraint(equalTo: visualEffectView.leadingAnchor,constant: 8),
            durationTourImageView.bottomAnchor.constraint(equalTo: visualEffectView.bottomAnchor,constant: -5.5),
            durationTourImageView.heightAnchor.constraint(equalToConstant: 14),
            durationTourImageView.widthAnchor.constraint(equalToConstant: 14),
            
            durationLabel.centerYAnchor.constraint(equalTo: durationTourImageView.centerYAnchor),
            durationLabel.leadingAnchor.constraint(equalTo: durationTourImageView.trailingAnchor,constant: 4),
            
            locationTourImageView.centerYAnchor.constraint(equalTo: durationLabel.centerYAnchor),
            locationTourImageView.leadingAnchor.constraint(equalTo: durationLabel.trailingAnchor,constant: 8),
            locationTourImageView.heightAnchor.constraint(equalToConstant: 14),
            locationTourImageView.widthAnchor.constraint(equalToConstant: 14),
            
            distanceLabel.centerYAnchor.constraint(equalTo: locationTourImageView.centerYAnchor),
            distanceLabel.leadingAnchor.constraint(equalTo: locationTourImageView.trailingAnchor,constant: 4),
            
            priceImageView.trailingAnchor.constraint(equalTo: visualEffectView.trailingAnchor, constant: 0),
            priceImageView.bottomAnchor.constraint(equalTo: visualEffectView.bottomAnchor, constant: 0),
            priceImageView.widthAnchor.constraint(equalToConstant: 212 * 0.245),
            priceImageView.heightAnchor.constraint(equalToConstant: 73 * 0.315),
            
            priceLabel.centerYAnchor.constraint(equalTo: priceImageView.centerYAnchor),
            priceLabel.centerXAnchor.constraint(equalTo: priceImageView.centerXAnchor),
        ])
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        visualEffectView.layer.cornerRadius = 10
        visualEffectView.clipsToBounds = true
        contentView.clipsToBounds = true
        contentView.layer.masksToBounds = true
        tourImageView.clipsToBounds = true
        tourImageView.layer.cornerRadius = 20
        contentView.layer.cornerRadius = 20
    }
    public func configure(with tour : AudioTour){
        if let url = URL(string: "https://devapi.test.vn.ua/storage/" + tour.photoName){
            tourImageView.sd_setImage(with: url)
        }
        locationGuideLabel.text = tour.name
        durationLabel.text = tour.duration
        distanceLabel.text = tour.distance + " km"
        priceLabel.text = tour.price
    }
}
