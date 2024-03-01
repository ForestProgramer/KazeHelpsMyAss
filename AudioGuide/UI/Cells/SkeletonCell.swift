//
//  SkeletonCell.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 12.01.2024.
//

//import UIKit
//
//class SkeletonCell: UICollectionViewCell, SkeletonLoadable {
//    static let identifier = "SkeletonCell"
//    let locationImage : UIView = {
//        let imageView = UIView()
//        imageView.backgroundColor = .lightGray.withAlphaComponent(0.3)
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.layer.cornerRadius = 8
//        return imageView
//    }()
//    let dublicateLocationImage : UIView = {
//        let imageView = UIView()
//        imageView.backgroundColor = .gray
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.layer.cornerRadius = 8
//        return imageView
//    }()
//    let locationImageLayer = CAGradientLayer()
//    let locationNameLabel : UIView = {
//        let label = UIView()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.backgroundColor = .lightGray.withAlphaComponent(0.3)
//        label.layer.cornerRadius = 8
//        return label
//    }()
//    let dublicateLocationNameLabel : UIView = {
//        let label = UIView()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.backgroundColor = .gray
//        label.layer.cornerRadius = 8
//        return label
//    }()
//    let locationNameLayer = CAGradientLayer()
//    let streetImage : UIView = {
//        let imageView = UIView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.backgroundColor = .lightGray.withAlphaComponent(0.3)
//        imageView.layer.cornerRadius = 3
//        return imageView
//    }()
//    let dublicateStreetImage : UIView = {
//        let imageView = UIView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.backgroundColor = .gray
//        imageView.layer.cornerRadius = 3
//        return imageView
//    }()
//    let streetImageLayer = CAGradientLayer()
//    let streetNameLabel : UIView = {
//        let label = UIView()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.backgroundColor = .lightGray.withAlphaComponent(0.3)
//        label.layer.cornerRadius = 4
//        return label
//    }()
//    let dublicateStreetNameLabel : UIView = {
//        let label = UIView()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.backgroundColor = .gray
//        label.layer.cornerRadius = 4
//        return label
//    }()
//    let streetNameLayer = CAGradientLayer()
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setUPUIElements()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    private func setUPUIElements(){
//        addSubview(locationImage)
//        addSubview(dublicateLocationImage)
//        addSubview(locationNameLabel)
//        addSubview(dublicateLocationNameLabel)
//        addSubview(streetImage)
//        addSubview(dublicateStreetImage)
//        addSubview(streetNameLabel)
//        addSubview(dublicateStreetNameLabel)
//        NSLayoutConstraint.activate([
//            locationImage.leadingAnchor.constraint(equalTo: leadingAnchor),
//            locationImage.topAnchor.constraint(equalTo: topAnchor),
//            locationImage.bottomAnchor.constraint(equalTo: bottomAnchor),
//            locationImage.widthAnchor.constraint(equalToConstant: 84),
//
//            locationNameLabel.leadingAnchor.constraint(equalTo: locationImage.trailingAnchor,constant: 4),
//            locationNameLabel.topAnchor.constraint(equalTo: topAnchor),
//            locationNameLabel.heightAnchor.constraint(equalToConstant: 42),
//            locationNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10),
//
//            streetImage.leadingAnchor.constraint(equalTo: locationImage.trailingAnchor,constant: 4),
//            streetImage.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -10),
//            streetImage.heightAnchor.constraint(equalToConstant: 12),
//            streetImage.widthAnchor.constraint(equalToConstant: 12),
//
//
//            streetNameLabel.centerYAnchor.constraint(equalTo: streetImage.centerYAnchor),
//            streetNameLabel.leadingAnchor.constraint(equalTo: streetImage.trailingAnchor,constant: 2),
//            streetNameLabel.heightAnchor.constraint(equalToConstant: 12),
//            streetNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -30),
//
//        ])
//        locationImageLayer.colors = [UIColor.gray.cgColor,UIColor.clear.cgColor]
//        locationImageLayer.locations = [0,1]
//        dublicateLocationImage.layer.mask = locationImageLayer
//
//        locationNameLayer.colors = [UIColor.gray.cgColor,UIColor.clear.cgColor]
//        locationNameLayer.locations = [0,1]
//        dublicateLocationNameLabel.layer.mask = locationNameLayer
//
//        streetImageLayer.colors = [UIColor.gray.cgColor,UIColor.clear.cgColor]
//        streetImageLayer.locations = [0,1]
//        dublicateStreetImage.layer.mask = streetImageLayer
////
//        streetNameLayer.colors = [UIColor.clear.cgColor,UIColor.gray.cgColor,UIColor.clear.cgColor]
//        streetNameLayer.locations = [0,0.5,1]
//        dublicateStreetNameLabel.layer.mask = streetNameLayer
//
//        let imagesAnimation = makeAnimation(with: contentView)
//        imagesAnimation.beginTime = 0.0
//        locationImageLayer.add(imagesAnimation, forKey: "backgroundColor")
//       streetImageLayer.add(imagesAnimation, forKey: "backgroundColor")
//
//        let titleAnimations = makeAnimation(with: contentView)
//        titleAnimations.beginTime = 0.3
//        locationNameLayer.add(titleAnimations, forKey: "backgroundColor")
//        streetNameLayer.add(titleAnimations, forKey: "backgroundColor")
//
//
//    }
//    func createShimmerGradient() -> CAGradientLayer {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [
//            UIColor.white.cgColor,
//            UIColor.lightGray.cgColor,
//            UIColor.white.cgColor
//        ]
//
//        gradientLayer.locations = [0.0, 0.5, 1.0]
//
//        // Set the gradient's direction based on your design
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//
//        return gradientLayer
//    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        dublicateLocationImage.frame = locationImage.frame
//        dublicateLocationNameLabel.frame = locationNameLabel.frame
//        dublicateStreetImage.frame = streetImage.frame
//        dublicateStreetNameLabel.frame = streetNameLabel.frame
//
//        locationImageLayer.frame = contentView.bounds
////        locationImageLayer.cornerRadius = locationImage.bounds.size.height / 4
//
//        locationNameLayer.frame = contentView.bounds
////        locationNameLayer.cornerRadius = locationNameLabel.bounds.size.height / 4
//
//        streetImageLayer.frame = contentView.bounds
////        streetImageLayer.cornerRadius = streetImage.bounds.size.height / 4
//
//        streetNameLayer.frame = contentView.bounds
////        streetNameLayer.cornerRadius = streetNameLabel.bounds.size.height / 4
//
//    }
//
//}
