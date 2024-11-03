//
//  TourDetailsUIView.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 27.03.2024.
//

import UIKit

class TourDetailsUIView: UIView {
    public var reviewsCollectionViewHeightConstraint: NSLayoutConstraint!
    public var ContainerWriteHeightConstraint: NSLayoutConstraint!
    public var reviewsViewHeightConstraint: NSLayoutConstraint!
    public var pointsCollectionViewHeightConstraint : NSLayoutConstraint!
    let typeLabel : UILabel = {
       let label = UILabel()
        label.font = .PoppinsFont(ofSize: 12,weight: .regular)
        label.textColor = UIColor(hexString: "#3D3E42")
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let rateImageView : UIImageView = {
       let imageView = UIImageView(image: UIImage(named: "Rate"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let locationTitleLabel : UILabel = {
       let label = UILabel()
        label.font = .PoppinsFont(ofSize: 20,weight: .medium)
        label.textColor = UIColor(hexString: "#3D3E42")
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let durationGuideImageView : UIImageView = {
       let imageView = UIImageView(image: UIImage(named: "tourTimeIcon"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(hexString: "#3D3E42")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let durationLabel : UILabel = {
       let label = UILabel()
        label.font = .PoppinsFont(ofSize: 12,weight: .light)
        label.textColor = UIColor(hexString: "#3D3E42")
        label.textAlignment = .left
        label.text = "0h 34m"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let distanceImageView : UIImageView = {
       let imageView = UIImageView(image: UIImage(named: "locationIcon"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(hexString: "#3D3E42")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let distanceLabel : UILabel = {
        let label = UILabel()
         label.font = .PoppinsFont(ofSize: 12,weight: .light)
         label.textColor = UIColor(hexString: "#3D3E42")
         label.textAlignment = .left
         label.text = "2 km"
         label.numberOfLines = 1
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    let overViewBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Overview", for: .normal)
        btn.setTitleColor(UIColor(hexString: "#3D3E42"), for: .normal)
        btn.titleLabel?.font = UIFont.PoppinsFont(ofSize: 20,weight: .medium)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    let reviewsBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Reviews", for: .normal)
        btn.setTitleColor(UIColor(hexString: "#3D3E42"), for: .normal)
        btn.titleLabel?.font = UIFont.PoppinsFont(ofSize: 18,weight: .regular)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    let overView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    let overviewLabel : UILabel = {
        let label = UILabel()
         label.font = .PoppinsFont(ofSize: 17,weight: .ultraLight)
         label.textColor = UIColor(hexString: "#3D3E42")
         label.textAlignment = .left
         label.numberOfLines = 0
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    let youWillSeeTourLabel : UILabel = {
        let label = UILabel()
         label.font = .PoppinsFont(ofSize: 20,weight: .medium)
         label.textColor = UIColor(hexString: "#3D3E42")
         label.textAlignment = .left
         label.text = "You will see:"
         label.numberOfLines = 0
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    public let pointsCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let insets: CGFloat = 32.0
        // Висота екрана айфона помножена на 0.085
        let itemHeight = UIScreen.main.bounds.height * 0.085
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - insets, height: itemHeight)
        layout.sectionInset = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    let reviewsView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()
    public let containerWriteComment : WriteCommentUIView = {
        let view = WriteCommentUIView()
        return view
    }()
    public let reviewsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // Змінюємо орієнтацію прокрутки на вертикальну
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let itemHeightPercentage: CGFloat = 0.122 // Задайте відсоток від висоти екрану для висоти елемента
        let itemHeight = screenHeight * itemHeightPercentage
        layout.itemSize = CGSize(width: screenWidth, height: itemHeight)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false // Показуємо вертикальну смугу прокрутки
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViewConstraints()
        print("Screen height : \(UIScreen.main.bounds.height)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUpViewConstraints(){
        addSubview(typeLabel)
        addSubview(rateImageView)
        addSubview(locationTitleLabel)
        addSubview(durationGuideImageView)
        addSubview(durationLabel)
        addSubview(distanceImageView)
        addSubview(distanceLabel)
        addSubview(overViewBtn)
        addSubview(reviewsBtn)
        addSubview(overView)
        overView.addSubview(overviewLabel)
        overView.addSubview(youWillSeeTourLabel)
        overView.addSubview(pointsCollectionView)
        addSubview(reviewsView)
        reviewsView.addSubview(containerWriteComment)
        reviewsView.addSubview(reviewsCollectionView)
        NSLayoutConstraint.activate([
            typeLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            typeLabel.topAnchor.constraint(equalTo: topAnchor,constant: 24),
            
            rateImageView.centerYAnchor.constraint(equalTo: typeLabel.centerYAnchor),
            rateImageView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
            rateImageView.heightAnchor.constraint(equalToConstant: 15),
            rateImageView.widthAnchor.constraint(equalToConstant: 68),
            
            locationTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor ,constant: 16),
            locationTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor ,constant: -16),
            locationTitleLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 4),
            
            durationGuideImageView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            durationGuideImageView.topAnchor.constraint(equalTo: locationTitleLabel.bottomAnchor,constant: 4),
            durationGuideImageView.heightAnchor.constraint(equalToConstant: 16),
            durationGuideImageView.widthAnchor.constraint(equalToConstant: 16),
            
            durationLabel.centerYAnchor.constraint(equalTo: durationGuideImageView.centerYAnchor),
            durationLabel.leadingAnchor.constraint(equalTo: durationGuideImageView.trailingAnchor,constant: 4),
            
            distanceImageView.leadingAnchor.constraint(equalTo: durationLabel.trailingAnchor, constant: 8),
            distanceImageView.centerYAnchor.constraint(equalTo: durationLabel.centerYAnchor),
            distanceImageView.heightAnchor.constraint(equalToConstant: 16),
            distanceImageView.widthAnchor.constraint(equalToConstant: 16),
            
            distanceLabel.leadingAnchor.constraint(equalTo: distanceImageView.trailingAnchor,constant: 4),
            distanceLabel.centerYAnchor.constraint(equalTo: distanceImageView.centerYAnchor),
            
            overViewBtn.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            overViewBtn.topAnchor.constraint(equalTo: durationGuideImageView.bottomAnchor,constant: 20),
            overViewBtn.widthAnchor.constraint(equalToConstant: 95),
            overViewBtn.heightAnchor.constraint(equalToConstant: 27),
            
            reviewsBtn.centerYAnchor.constraint(equalTo: overViewBtn.centerYAnchor),
            reviewsBtn.leadingAnchor.constraint(equalTo: overViewBtn.trailingAnchor,constant: 16),
            reviewsBtn.widthAnchor.constraint(equalToConstant: 95),
            reviewsBtn.heightAnchor.constraint(equalToConstant: 23),
            
            reviewsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            reviewsView.topAnchor.constraint(equalTo: overViewBtn.bottomAnchor,constant: 10),
            reviewsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            reviewsView.bottomAnchor.constraint(equalTo: reviewsCollectionView.bottomAnchor,constant: 20),
            
            containerWriteComment.leadingAnchor.constraint(equalTo: reviewsView.leadingAnchor),
            containerWriteComment.topAnchor.constraint(equalTo: reviewsView.topAnchor),
            containerWriteComment.trailingAnchor.constraint(equalTo: reviewsView.trailingAnchor),
            
            reviewsCollectionView.leadingAnchor.constraint(equalTo: reviewsView.leadingAnchor),
            reviewsCollectionView.topAnchor.constraint(equalTo: containerWriteComment.bottomAnchor),
            reviewsCollectionView.trailingAnchor.constraint(equalTo: reviewsView.trailingAnchor),
            
            overView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overView.topAnchor.constraint(equalTo: overViewBtn.bottomAnchor,constant: 10),
            overView.trailingAnchor.constraint(equalTo: trailingAnchor),
            overView.bottomAnchor.constraint(equalTo: pointsCollectionView.bottomAnchor,constant: 20),
            
            overviewLabel.leadingAnchor.constraint(equalTo: overView.leadingAnchor, constant: 16),
            overviewLabel.trailingAnchor.constraint(equalTo: overView.trailingAnchor, constant: -16),
            overviewLabel.topAnchor.constraint(equalTo: overView.topAnchor, constant: 10),

            youWillSeeTourLabel.leadingAnchor.constraint(equalTo: overView.leadingAnchor, constant: 16),
            youWillSeeTourLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 16),
            
            pointsCollectionView.leadingAnchor.constraint(equalTo: overView.leadingAnchor,constant: 0),
            pointsCollectionView.trailingAnchor.constraint(equalTo: overView.trailingAnchor,constant: 0),
            pointsCollectionView.topAnchor.constraint(equalTo: youWillSeeTourLabel.bottomAnchor, constant: 8),
        ])
        reviewsCollectionViewHeightConstraint = reviewsCollectionView.heightAnchor.constraint(equalToConstant: 10)
        reviewsCollectionViewHeightConstraint.isActive = true
        ContainerWriteHeightConstraint = containerWriteComment.heightAnchor.constraint(equalToConstant: 121)
        ContainerWriteHeightConstraint.isActive = true
    }
}
