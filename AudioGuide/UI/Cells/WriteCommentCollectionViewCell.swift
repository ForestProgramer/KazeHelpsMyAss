//
//  WriteCommentCollectionViewCell.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 26.03.2024.
//

//import UIKit
//protocol CommentCellDelegate: AnyObject {
//    func commentCellDidUpdateSize(_ cell: WriteCommentCollectionViewCell)
//}
//class WriteCommentCollectionViewCell: UICollectionViewCell {
//    var commentTextViewHeightConstraint : NSLayoutConstraint!
//    static let identifier : String = "WriteCommentCollectionViewCell"
//    weak var delegate: CommentCellDelegate?
//    private let senderName : UILabel = {
//        let label = UILabel()
//        label.font = UIFont.PoppinsFont(ofSize: 18,weight: .regular)
//        label.textColor = UIColor(hexString: "#973939")
//        label.textAlignment = .left
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Zoriana"
//        return label
//    }()
//    private let ratingCommentImageView : UIImageView = {
//        let imageView = UIImageView()
//        let image = UIImage(named: "Rate")
//        imageView.image = image
//        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//    public let commentTextView: UITextView = {
//        let textView = UITextView()
//        // Встановлюємо нульові відступи (insets) для текстового поля, щоб відсутні були рамки
//        textView.textContainerInset = .zero
//        textView.contentInset = .zero
//        textView.textContainer.lineFragmentPadding = 0
//        textView.layer.borderWidth = 0 // Забираємо рамку
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        textView.text = "Start typing.."
//        textView.font = .PoppinsFont(ofSize: 12, weight: .regular)
//        return textView
//    }()
//
//
//    private let sendCommentButton : UIButton = {
//        let btn = UIButton(type: .custom)
//        btn.setTitle("Public a comment", for: .normal)
//        btn.setTitleColor(UIColor(hexString: "#973939").withAlphaComponent(0.24), for: .normal)
//        btn.layer.cornerRadius = 8
//        btn.layer.borderWidth = 1
//        btn.layer.borderColor = UIColor(hexString: "#973939").withAlphaComponent(0.24).cgColor
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setUpUIElements()
//        commentTextView.delegate = self
//    }
//    private func setUpUIElements(){
//        addSubview(senderName)
//        addSubview(ratingCommentImageView)
//        addSubview(commentTextView)
//        addSubview(sendCommentButton)
//        NSLayoutConstraint.activate([
//            senderName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
//            senderName.topAnchor.constraint(equalTo: topAnchor, constant: 20),
//            
//            ratingCommentImageView.centerYAnchor.constraint(equalTo: senderName.centerYAnchor),
//            ratingCommentImageView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
//            ratingCommentImageView.heightAnchor.constraint(equalToConstant: 16),
//            ratingCommentImageView.widthAnchor.constraint(equalToConstant: 68),
//            
//            commentTextView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
//            commentTextView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
//            commentTextView.topAnchor.constraint(equalTo: senderName.bottomAnchor, constant: 8),
//            
//            sendCommentButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 200),
//            sendCommentButton.topAnchor.constraint(equalTo: commentTextView.bottomAnchor, constant: 8),
//            sendCommentButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
//            sendCommentButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 16),
//        ])
//        commentTextViewHeightConstraint = commentTextView.heightAnchor.constraint(equalToConstant: 18)
//        commentTextViewHeightConstraint.isActive = true
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    public func configureReview(with comment : OneLocationComment){
//      
//    }
//}
//extension WriteCommentCollectionViewCell: UITextViewDelegate {
//    func textViewDidChange(_ textView: UITextView) {
//        
//        let newSize = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
//        print("newSize : \(newSize)")
////        let newHeight = max(newSize.height + 60, 101) // Мінімальна висота 101 піксель
//        if newSize.height != commentTextView.bounds.size.height{
//            if let oldConstraint = commentTextViewHeightConstraint {
//                oldConstraint.isActive = false
//            }
//            let newConstraint = commentTextView.heightAnchor.constraint(equalToConstant: newSize.height)
//            commentTextViewHeightConstraint = newConstraint
//            commentTextViewHeightConstraint.isActive = true
////            frame.size.height = newHeight
////            self.layoutIfNeeded()
//            delegate?.commentCellDidUpdateSize(self)
//        }
//    }
//}
