//
//  UserReviewsCollectionViewCell.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 11.03.2024.
//

import UIKit
import Cosmos
class UserReviewsCollectionViewCell: UICollectionViewCell {
    static let identifier = "UserReviewsCollectionViewCell"
    private let reviewerName : UILabel = {
        let label = UILabel()
        label.font = UIFont.PoppinsFont(ofSize: 18,weight: .regular)
        label.textColor = UIColor(hexString: "#973939")
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let dateCreatedComment : UILabel = {
        let label = UILabel()
        label.font = .PoppinsFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(hexString: "#52555A")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    public let rateImageView : CosmosView = {
       let cosmos = CosmosView()
        cosmos.settings.filledImage = UIImage(named: "filledStar")?.withRenderingMode(.alwaysOriginal)
        cosmos.settings.emptyImage = UIImage(named: "emptyStar")?.withRenderingMode(.alwaysOriginal)
        cosmos.settings.starSize = 14
        cosmos.settings.updateOnTouch = true
        cosmos.translatesAutoresizingMaskIntoConstraints = false
        return cosmos
    }()
    private let commentTextLabel : UILabel = {
        let label = UILabel()
        label.font = .PoppinsFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(hexString: "#3D3E42")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUIElements()
    }
    private func setUpUIElements(){
        addSubview(reviewerName)
        addSubview(dateCreatedComment)
        addSubview(rateImageView)
        addSubview(commentTextLabel)
        NSLayoutConstraint.activate([
            reviewerName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            reviewerName.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            
            dateCreatedComment.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dateCreatedComment.topAnchor.constraint(equalTo: reviewerName.bottomAnchor, constant: 0),
            
            rateImageView.centerYAnchor.constraint(equalTo: reviewerName.centerYAnchor),
            rateImageView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -30),
            rateImageView.heightAnchor.constraint(equalToConstant: 16),
            rateImageView.widthAnchor.constraint(equalToConstant: 68),
            
            commentTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            commentTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -36),
            commentTextLabel.topAnchor.constraint(equalTo: dateCreatedComment.bottomAnchor, constant: 4),
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func configureReview(with comment : UsersComments){
        reviewerName.text = comment.userData.name
        dateCreatedComment.text = comment.createdAt
        commentTextLabel.text = comment.comment
        if let rating = comment.rating{
            rateImageView.rating = Double(rating)
        }
    }
}
