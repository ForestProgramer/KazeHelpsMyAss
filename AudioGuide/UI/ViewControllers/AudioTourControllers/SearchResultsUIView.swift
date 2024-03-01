//
//  SearchResultsUIView.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 12.01.2024.
//

import UIKit

class SearchResultsUIView: UIView {
   public let resultsLocationsColectionView : UICollectionView = {
       let layout = UICollectionViewFlowLayout()
       layout.scrollDirection = .horizontal
       let screenWidth = UIScreen.main.bounds.width
       let screenHeight = UIScreen.main.bounds.height
       let spacing : CGFloat = 10
       let procentsWidth = 0.65
       let procentsHeight = 0.085
       let totalWidth = (screenWidth - spacing) * procentsWidth
       let totalHeight = screenHeight * procentsHeight
       layout.itemSize = CGSize(width: totalWidth, height: totalHeight)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    public let insertToursLabel : UILabel = {
        let label = UILabel()
        label.font = .PoppinsFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = "Audio Tours with this location"
        return label
    }()
    public let resultsToursColectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let spacing : CGFloat = 8
        let procentsWidth = 0.65
        let procentsHeight = 0.30
        let totalWidth = (screenWidth - spacing) * procentsWidth
        let totalHeight = screenHeight * procentsHeight
        layout.itemSize = CGSize(width: totalWidth, height: totalHeight)
         
         let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
         collectionView.backgroundColor = .clear
         collectionView.translatesAutoresizingMaskIntoConstraints = false
         return collectionView
     }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hexString: "#fafafa")
        alpha = 0
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI(){
        addSubview(resultsLocationsColectionView)
        addSubview(insertToursLabel)
        addSubview(resultsToursColectionView)
        NSLayoutConstraint.activate([
            resultsLocationsColectionView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            resultsLocationsColectionView.topAnchor.constraint(equalTo: topAnchor,constant: 16),
            resultsLocationsColectionView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
            resultsLocationsColectionView.heightAnchor.constraint(equalToConstant: 105),
            
            insertToursLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            insertToursLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
            insertToursLabel.topAnchor.constraint(equalTo: resultsLocationsColectionView.bottomAnchor,constant: 16),
            
            resultsToursColectionView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            resultsToursColectionView.topAnchor.constraint(equalTo: insertToursLabel.bottomAnchor,constant: 8),
            resultsToursColectionView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
            resultsToursColectionView.heightAnchor.constraint(equalToConstant: 254),
        ])
    }
    
}
