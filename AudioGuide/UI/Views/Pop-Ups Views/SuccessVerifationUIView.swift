//
//  SuccessVerifationUIView.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 23.11.2023.
//

import UIKit

class SuccessVerifationUIView: UIView {

    let successView : UIView = {
       let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.8)
        view.layer.cornerRadius = 24
        return view
    }()
    let imageView : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        let im = UIImage(named: "successImage")
        image.image = im
        return image
    }()
    let boldLabel : UILabel = {
        let label = UILabel()
        label.text = "Successfully done! "
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    let secondaryLabel : UILabel = {
        let label = UILabel()
        label.text = "You successfully verified your account."
        label.font = UIFont(name: "Poppins", size: 12)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "#CDCDCD")
        return label
    }()
    let logInBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor(hexString: "#973939")
        btn.setTitle("Discover an app", for: .normal)
        btn.titleLabel?.textColor = .white
        btn.layer.cornerRadius = 10
        return btn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews(){
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        addSubview(successView)
        successView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            successView.widthAnchor.constraint(equalToConstant: 343),
            successView.heightAnchor.constraint(equalToConstant: 241),
            successView.centerYAnchor.constraint(equalTo: centerYAnchor,constant: -100),
            successView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        successView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: successView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: successView.topAnchor,constant: 41),
            imageView.widthAnchor.constraint(equalToConstant: 50.5),
            imageView.heightAnchor.constraint(equalToConstant: 51),
        ])
        successView.addSubview(boldLabel)
        boldLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            boldLabel.centerXAnchor.constraint(equalTo: successView.centerXAnchor),
            boldLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 8),
            boldLabel.widthAnchor.constraint(equalToConstant: 191),
            boldLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
        successView.addSubview(secondaryLabel)
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondaryLabel.centerXAnchor.constraint(equalTo: successView.centerXAnchor),
            secondaryLabel.topAnchor.constraint(equalTo: boldLabel.bottomAnchor,constant: 2),
            secondaryLabel.widthAnchor.constraint(equalToConstant: 232),
            secondaryLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
        successView.addSubview(logInBtn)
        logInBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logInBtn.centerXAnchor.constraint(equalTo: successView.centerXAnchor),
            logInBtn.topAnchor.constraint(equalTo: secondaryLabel.bottomAnchor,constant: 12),
            logInBtn.widthAnchor.constraint(equalToConstant: 295),
            logInBtn.heightAnchor.constraint(equalToConstant: 39),
        ])
    }
    override func layoutSubviews() {
        successView.frame = CGRect(x: 50, y: 50, width: 343, height: 455)
        imageView.frame = CGRect(x: 118.5, y: 39, width: 106, height: 107)
        boldLabel.frame = CGRect(x: 75, y: 154, width: 191, height: 30)
        secondaryLabel.frame = CGRect(x: 48, y: 186, width: 247, height: 36)
        logInBtn.frame = CGRect(x: 24, y: 234, width: 295, height: 39)
    }
}
