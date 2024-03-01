//
//  PurchaseTableViewCell.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 31.12.2023.
//

import UIKit

class PurchaseTableViewCell: UITableViewCell {
    static let identifier = "PurchaseTableViewCell"
    let purchaseImageView : UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    let mainTitle : UILabel = {
        let title = UILabel()
        title.text = ""
        title.font = UIFont.PoppinsFont(ofSize: 14)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    let typeTitle : UILabel = {
        let title = UILabel()
        title.text = ""
        title.font = UIFont.PoppinsFont(ofSize: 10)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    let dateTitle : UILabel = {
        let title = UILabel()
        title.text = ""
        title.font = UIFont.PoppinsFont(ofSize: 10)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    let priceTitle : UILabel = {
        let title = UILabel()
        title.text = ""
        title.font = UIFont.PoppinsFont(ofSize: 14)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUp()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUp()
    }
    private func setUp(){
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = true
        contentView.addSubview(purchaseImageView)
        contentView.addSubview(mainTitle)
        contentView.addSubview(typeTitle)
        contentView.addSubview(dateTitle)
        contentView.addSubview(priceTitle)
        NSLayoutConstraint.activate([
            purchaseImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            purchaseImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            purchaseImageView.widthAnchor.constraint(equalToConstant: 84),
            purchaseImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            mainTitle.leadingAnchor.constraint(equalTo: purchaseImageView.trailingAnchor,constant: 8),
            mainTitle.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            typeTitle.leadingAnchor.constraint(equalTo: purchaseImageView.trailingAnchor,constant: 8),
            typeTitle.topAnchor.constraint(equalTo: mainTitle.bottomAnchor,constant: 2),
            
            dateTitle.leadingAnchor.constraint(equalTo: purchaseImageView.trailingAnchor,constant: 8),
            dateTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            priceTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            priceTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
        ])
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(with purchase : Purchase){
        if let image = UIImage(named: purchase.imageName){
            purchaseImageView.image = image
        }
        mainTitle.text = purchase.name
        typeTitle.text = purchase.type
        dateTitle.text = purchase.date
        priceTitle.text = purchase.price
    }

}
