//
//  ResultUICoCollectionViewCell.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 06.02.2024.
//

import UIKit
import SDWebImage
import SkeletonView
class ResultUICoCollectionViewCell: UICollectionViewCell {
    static let identifier = "ResultUICoCollectionViewCell"
    let resultImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        return imageView
    }()
    let resultTitleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .PoppinsFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    let iconStreet : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "locationIcon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let resulStreetLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .PoppinsFont(ofSize: 10, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.isSkeletonable = true
        isSkeletonable = true
        setUPContraints()
    }
    required init?(coder: NSCoder) {
        fatalError("Unexprected error")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.size.height / 7
        layer.masksToBounds = true
    }
    private func setUPContraints(){
        addSubview(resultImageView)
        addSubview(resultTitleLabel)
        addSubview(iconStreet)
        addSubview(resulStreetLabel)
        NSLayoutConstraint.activate([
            resultImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            resultImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            resultImageView.topAnchor.constraint(equalTo: topAnchor),
            resultImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            resultImageView.widthAnchor.constraint(equalToConstant: 84),
            
            resultTitleLabel.leadingAnchor.constraint(equalTo: resultImageView.trailingAnchor,constant: 4),
            resultTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            resultTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            resultTitleLabel.heightAnchor.constraint(equalToConstant: 42),
            
            iconStreet.leadingAnchor.constraint(equalTo: resultImageView.trailingAnchor,constant: 4),
            iconStreet.topAnchor.constraint(equalTo: resultTitleLabel.bottomAnchor,constant: 5),
            iconStreet.widthAnchor.constraint(equalToConstant: 12),
            iconStreet.heightAnchor.constraint(equalToConstant: 12),
            
            resulStreetLabel.leadingAnchor.constraint(equalTo: iconStreet.trailingAnchor,constant: 1.5),
            resulStreetLabel.centerYAnchor.constraint(equalTo: iconStreet.centerYAnchor),
            resulStreetLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
    }
    public func setup(with location : Location) {
        print("Location url : \(location.photoName) ")
        let urlImage = location.photoName
        if let url = URL(string: urlImage){
            print("Succes URl")
            resultImageView.sd_setImage(with: url,completed: nil)
        }
        resultTitleLabel.text = location.name
        resulStreetLabel.text = location.street
        
    }
}
