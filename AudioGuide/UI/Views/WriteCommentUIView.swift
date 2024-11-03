//
//  WriteCommentUIView.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 29.03.2024.
//

import UIKit
import Cosmos
class WriteCommentUIView: UIView {
    private let senderName : UILabel = {
        let label = UILabel()
        label.font = UIFont.PoppinsFont(ofSize: 18,weight: .regular)
        label.textColor = UIColor(hexString: "#973939")
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Zoriana"
        return label
    }()
    public let rateImageView : CosmosView = {
       let cosmos = CosmosView()
        cosmos.settings.filledImage = UIImage(named: "filledStar")?.withRenderingMode(.alwaysOriginal)
        cosmos.settings.emptyImage = UIImage(named: "emptyStar")?.withRenderingMode(.alwaysOriginal)
        cosmos.settings.starSize = 14
        cosmos.settings.updateOnTouch = true
        cosmos.settings.totalStars = 5
        cosmos.translatesAutoresizingMaskIntoConstraints = false
        return cosmos
    }()
    public let commentTextView: UITextView = {
        let textView = UITextView()
        // Встановлюємо нульові відступи (insets) для текстового поля, щоб відсутні були рамки
        textView.textContainerInset = .zero
        textView.contentInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.layer.borderWidth = 0 // Забираємо рамку
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .PoppinsFont(ofSize: 14, weight: .regular)
        return textView
    }()
    public let textViewPlaceHolder : UILabel = {
       let label = UILabel()
        label.font = .PoppinsFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 1
        label.textColor = UIColor(hexString: "#3D3E42")
        label.textAlignment = .left
        label.text = "Start typing..."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let sendCommentButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Public a comment", for: .normal)
        btn.setTitleColor(UIColor(hexString: "#973939").withAlphaComponent(0.24), for: .normal)
        btn.layer.cornerRadius = 8
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(hexString: "#973939").withAlphaComponent(0.24).cgColor
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    public let characterCountLabel : UILabel = {
        let label = UILabel()
        label.font = .PoppinsFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 1
        label.textColor = UIColor(hexString: "#3D3E42")
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        setUpUIElements()
    }
    private func setUpUIElements(){
        addSubview(senderName)
        addSubview(rateImageView)
        addSubview(commentTextView)
        commentTextView.addSubview(textViewPlaceHolder)
        addSubview(sendCommentButton)
        addSubview(characterCountLabel)
        NSLayoutConstraint.activate([
            senderName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            senderName.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            
            rateImageView.centerYAnchor.constraint(equalTo: senderName.centerYAnchor),
            rateImageView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -40),
            rateImageView.heightAnchor.constraint(equalToConstant: 16),
            rateImageView.widthAnchor.constraint(equalToConstant: 75),
            
            commentTextView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            commentTextView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
            commentTextView.topAnchor.constraint(equalTo: senderName.bottomAnchor, constant: 8),
            commentTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            
            textViewPlaceHolder.leadingAnchor.constraint(equalTo: commentTextView.leadingAnchor, constant: 0),
            textViewPlaceHolder.topAnchor.constraint(equalTo: commentTextView.topAnchor, constant: 0),
            textViewPlaceHolder.trailingAnchor.constraint(equalTo: commentTextView.trailingAnchor, constant: -10),
            textViewPlaceHolder.bottomAnchor.constraint(equalTo: commentTextView.bottomAnchor, constant: 0),
            
            sendCommentButton.widthAnchor.constraint(equalToConstant: 147),
            sendCommentButton.topAnchor.constraint(equalTo: commentTextView.bottomAnchor, constant: 8),
            sendCommentButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            sendCommentButton.heightAnchor.constraint(equalToConstant: 26),
            
            characterCountLabel.centerYAnchor.constraint(equalTo: sendCommentButton.centerYAnchor),
            characterCountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
