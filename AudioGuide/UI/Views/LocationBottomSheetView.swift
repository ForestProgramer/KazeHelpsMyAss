//
//  LocationBottomSheetView.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 05.03.2024.
//

import UIKit
import Cosmos
final class LocationBottomSheetView : UIView{
    public var reviewsCollectionViewHeightConstraint: NSLayoutConstraint!
    public var ContainerWriteHeightConstraint: NSLayoutConstraint!
    public var reviewsViewTopAnchorConstraint: NSLayoutConstraint!
    let typeLabel : UILabel = {
       let label = UILabel()
        label.font = .PoppinsFont(ofSize: 12,weight: .regular)
        label.textColor = UIColor(hexString: "#3D3E42")
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    public let rateImageView : CosmosView = {
       let cosmos = CosmosView()
        cosmos.settings.filledImage = UIImage(named: "filledStar")?.withRenderingMode(.alwaysOriginal)
        cosmos.settings.emptyImage = UIImage(named: "emptyStar")?.withRenderingMode(.alwaysOriginal)
        cosmos.settings.starSize = 14
        cosmos.settings.updateOnTouch = false
        cosmos.translatesAutoresizingMaskIntoConstraints = false
        return cosmos
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
    let locationGuideImageView : UIImageView = {
       let imageView = UIImageView(image: UIImage(named: "locationIcon"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(hexString: "#3D3E42")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let locationGuideLabel : UILabel = {
        let label = UILabel()
         label.font = .PoppinsFont(ofSize: 12,weight: .light)
         label.textColor = UIColor(hexString: "#3D3E42")
         label.textAlignment = .left
         label.text = "L. Ukrainky St., 1"
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
    let locationInAudioGuidesLabel : UILabel = {
        let label = UILabel()
         label.font = .PoppinsFont(ofSize: 20,weight: .medium)
         label.textColor = UIColor(hexString: "#3D3E42")
         label.textAlignment = .left
         label.text = "Location in audio guides:"
         label.numberOfLines = 0
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    public let toursCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // Змінюємо орієнтацію прокрутки на горизонтальну
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let itemHeightPercentage: CGFloat = 0.289
        let itemHeight = screenHeight * itemHeightPercentage
        let itemWidthtPercentage: CGFloat = 0.58
        let itemWidth = screenWidth * itemWidthtPercentage
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
        addSubview(locationGuideImageView)
        addSubview(locationGuideLabel)
        addSubview(overViewBtn)
        addSubview(reviewsBtn)
        addSubview(overView)
        overView.addSubview(overviewLabel)
        overView.addSubview(locationInAudioGuidesLabel)
        overView.addSubview(toursCollectionView)
        addSubview(reviewsView)
        reviewsView.addSubview(containerWriteComment)
        reviewsView.addSubview(reviewsCollectionView)
        NSLayoutConstraint.activate([
            typeLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            typeLabel.topAnchor.constraint(equalTo: topAnchor,constant: 24),
            
            rateImageView.centerYAnchor.constraint(equalTo: typeLabel.centerYAnchor),
            rateImageView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -30),
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
            
            locationGuideImageView.leadingAnchor.constraint(equalTo: durationLabel.trailingAnchor, constant: 8),
            locationGuideImageView.centerYAnchor.constraint(equalTo: durationLabel.centerYAnchor),
            locationGuideImageView.heightAnchor.constraint(equalToConstant: 16),
            locationGuideImageView.widthAnchor.constraint(equalToConstant: 16),
            
            locationGuideLabel.leadingAnchor.constraint(equalTo: locationGuideImageView.trailingAnchor,constant: 4),
            locationGuideLabel.centerYAnchor.constraint(equalTo: locationGuideImageView.centerYAnchor),
            
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
            reviewsCollectionView.trailingAnchor.constraint(equalTo: reviewsView.trailingAnchor),
            
            overView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overView.topAnchor.constraint(equalTo: overViewBtn.bottomAnchor,constant: 10),
            overView.trailingAnchor.constraint(equalTo: trailingAnchor),
            overView.bottomAnchor.constraint(equalTo: toursCollectionView.bottomAnchor,constant: 20),
            
            overviewLabel.leadingAnchor.constraint(equalTo: overView.leadingAnchor, constant: 16),
            overviewLabel.trailingAnchor.constraint(equalTo: overView.trailingAnchor, constant: -16),
            overviewLabel.topAnchor.constraint(equalTo: overView.topAnchor, constant: 10),

            locationInAudioGuidesLabel.leadingAnchor.constraint(equalTo: overView.leadingAnchor, constant: 16),
            locationInAudioGuidesLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 16),
            
            toursCollectionView.leadingAnchor.constraint(equalTo: overView.leadingAnchor,constant: 0),
            toursCollectionView.trailingAnchor.constraint(equalTo: overView.trailingAnchor,constant: 0),
            toursCollectionView.topAnchor.constraint(equalTo: locationInAudioGuidesLabel.bottomAnchor, constant: 8),
            toursCollectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.289 + 20)
        ])
        reviewsCollectionViewHeightConstraint = reviewsCollectionView.heightAnchor.constraint(equalToConstant: 10)
        reviewsCollectionViewHeightConstraint.isActive = true
        ContainerWriteHeightConstraint = containerWriteComment.heightAnchor.constraint(equalToConstant: 121)
        ContainerWriteHeightConstraint.isActive = true
        if let isFreeVersion = UserDefaults.isFreeVersion {
            containerWriteComment.isHidden = isFreeVersion ? true : false
            reviewsViewTopAnchorConstraint = isFreeVersion ? reviewsCollectionView.topAnchor.constraint(equalTo: reviewsView.topAnchor) : reviewsCollectionView.topAnchor.constraint(equalTo: containerWriteComment.bottomAnchor)
            reviewsViewTopAnchorConstraint.isActive = true
        }else{
            containerWriteComment.isHidden = false
            reviewsViewTopAnchorConstraint = reviewsCollectionView.topAnchor.constraint(equalTo: containerWriteComment.bottomAnchor)
            reviewsViewTopAnchorConstraint.isActive = true
        }
    }
}
