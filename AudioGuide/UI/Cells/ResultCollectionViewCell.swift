//
//  ResultCollectionViewCell.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 12.01.2024.
//

import UIKit

class ResultCollectionViewCell: UICollectionViewCell {
    static let identifier = "ResultCollectionViewCell"
    let locationImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let locationNameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .PoppinsFont(ofSize: 14)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let streetImage : UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "pencil"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let streetNameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .PoppinsFont(ofSize: 10)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUPUIElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUPUIElements(){
        addSubview(locationImage)
        addSubview(locationNameLabel)
        addSubview(streetImage)
        addSubview(streetNameLabel)
        NSLayoutConstraint.activate([
            locationImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            locationImage.topAnchor.constraint(equalTo: topAnchor),
            locationImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            locationImage.widthAnchor.constraint(equalToConstant: 84),
            
            locationNameLabel.leadingAnchor.constraint(equalTo: locationImage.trailingAnchor,constant: 4),
            locationNameLabel.topAnchor.constraint(equalTo: topAnchor),
            locationNameLabel.heightAnchor.constraint(equalToConstant: 42),
            
            streetImage.leadingAnchor.constraint(equalTo: locationImage.trailingAnchor,constant: 4),
            streetImage.topAnchor.constraint(equalTo: locationNameLabel.bottomAnchor,constant: 3.5),
            streetImage.heightAnchor.constraint(equalToConstant: 12),
            streetImage.widthAnchor.constraint(equalToConstant: 12),
            
            streetNameLabel.centerYAnchor.constraint(equalTo: streetImage.centerYAnchor),
            streetNameLabel.leadingAnchor.constraint(equalTo: streetImage.trailingAnchor,constant: 2),
        ])
    }
    
    func setup(with location : Location) {
        
        if let image = UIImage(named: location.photoName){
            locationImage.image = image
            }
        locationNameLabel.text = location.name
        streetNameLabel.text = location.street
        
    }
}
