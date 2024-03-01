//
//  AGLocationTableViewCell.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 21.02.2022.
//

import UIKit

class AGLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIImageView!
    static let identifier = "AGLocationTableViewCell"
    let itemImageView : UIImageView = {
       let imageView = UIImageView(image: UIImage(named: "locationImage"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let locationName : UILabel = {
       let locationName = UILabel()
        locationName.translatesAutoresizingMaskIntoConstraints = false
        locationName.font = UIFont.PoppinsFont(ofSize: 14)
        locationName.text = "Dominican Church"
        return locationName
    }()
    let locImage : UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName:"location.north.circle"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        return imageView
    }()
    let adressLocation : UILabel = {
       let locationName = UILabel()
        locationName.translatesAutoresizingMaskIntoConstraints = false
        locationName.font = UIFont(name: "Poppins-Regular", size: 10)
        locationName.text = "Museum sq., 12"
        return locationName
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addElemntsOnCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    private func addElemntsOnCell(){
        contentView.layer.borderWidth = 0
        contentView.backgroundColor = UIColor(hexString: "#FAFAFA")
        contentView.addSubview(itemImageView)
        contentView.addSubview(locationName)
        contentView.addSubview(locImage)
        contentView.addSubview(adressLocation)
        
        NSLayoutConstraint.activate([
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            itemImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            itemImageView.widthAnchor.constraint(equalToConstant: 84),
            
            locationName.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor,constant: 4),
            locationName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            locationName.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            locImage.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 4),
            locImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.5),
            locImage.widthAnchor.constraint(equalToConstant: 12),
            locImage.heightAnchor.constraint(equalToConstant: 12),
            
            adressLocation.centerYAnchor.constraint(equalTo: locImage.centerYAnchor),
            adressLocation.leadingAnchor.constraint(equalTo: locImage.trailingAnchor,constant: 2)
        ])
    }

    func setup() {
       
    }
}
