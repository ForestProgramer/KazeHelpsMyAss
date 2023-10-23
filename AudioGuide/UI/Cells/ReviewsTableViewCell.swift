//
//  ReviewsTableViewCell.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 12.10.2023.
//

import UIKit

class ReviewsTableViewCell: UITableViewCell {

    var userReviewName : UILabel = {
        var label = UILabel(frame: CGRect(x: 7, y: 0, width: 200, height: 24))
        label.frame = CGRect(x: 7, y: 0, width: 200, height: 24)
        label.text = "Andrii Smith"
        label.textColor = UIColor(hexString: "973939")
        label.font = UIFont(name: "Poppins", size: 16)
        return label
    }()
    var userRateImageView : UIImageView = {
        var image = UIImageView(image: UIImage(named: "Mark"))
        image.frame = CGRect(x: 8, y: 29, width: 62, height: 10.17)
        image.contentMode = .scaleAspectFit
        return image
    }()
    var userCommentLabel : UILabel = {
        var label = UILabel(frame: CGRect(x: 8, y: 45, width: 80, height: 15))
        label.text = "It`s a nice place"
        label.textColor = UIColor(hexString: "3D3E42")
        label.font = UIFont(name: "Poppins", size: 10)
        return label
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUp()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setUp(){
        let horizontalInset: CGFloat = 20.0
        let verticalInset: CGFloat = 10.0
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset))
        self.layer.cornerRadius = self.bounds.height / 4
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hexString: "52555A").cgColor
        self.addSubview(userReviewName)
        self.addSubview(userRateImageView)
        self.addSubview(userRateImageView)
        self.addSubview(userCommentLabel)
    }
}
