//
//  404ErrorPopUpUIView.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 16.11.2023.
//

import UIKit

class ServerErrorPopUpUIView: UIView {

    let errorView : UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        return view
    }()
    let imageView : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        let im = UIImage(named: "404ErrorImage")
        image.image = im
        return image
    }()
    let boldLabel : UILabel = {
        let label = UILabel()
        label.text = "Oops! What`s going on?"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    let secondaryLabel : UILabel = {
        let label = UILabel()
        label.text = "Something gets wrong. Please, try again, and again, and again..."
        label.font = UIFont(name: "Poppins", size: 15)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    let tryAgainButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor(hexString: "#973939")
        btn.setTitle("Try again", for: .normal)
        btn.titleLabel?.textColor = .white
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(tapTryAgain), for: .touchUpInside)
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
        addSubview(errorView)
        errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorView.widthAnchor.constraint(equalToConstant: 343),
            errorView.heightAnchor.constraint(equalToConstant: 455),
            errorView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100),
            errorView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        errorView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: errorView.leadingAnchor,constant: 8),
            imageView.topAnchor.constraint(equalTo: errorView.topAnchor,constant: 48),
            imageView.widthAnchor.constraint(equalToConstant: 327),
            imageView.heightAnchor.constraint(equalToConstant: 211),
        ])
        errorView.addSubview(boldLabel)
        boldLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            boldLabel.leadingAnchor.constraint(equalTo: errorView.leadingAnchor,constant: 63.5),
            boldLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 16),
            boldLabel.widthAnchor.constraint(equalToConstant: 216),
            boldLabel.heightAnchor.constraint(equalToConstant: 27),
        ])
        errorView.addSubview(secondaryLabel)
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondaryLabel.leadingAnchor.constraint(equalTo: errorView.leadingAnchor,constant: 32.5),
            secondaryLabel.topAnchor.constraint(equalTo: boldLabel.bottomAnchor,constant: 4),
            secondaryLabel.widthAnchor.constraint(equalToConstant: 278),
            secondaryLabel.heightAnchor.constraint(equalToConstant: 46),
        ])
        errorView.addSubview(tryAgainButton)
        tryAgainButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tryAgainButton.leadingAnchor.constraint(equalTo: errorView.leadingAnchor,constant:24),
            tryAgainButton.topAnchor.constraint(equalTo: secondaryLabel.bottomAnchor,constant: 16),
            tryAgainButton.widthAnchor.constraint(equalToConstant: 295),
            tryAgainButton.heightAnchor.constraint(equalToConstant: 39),
        ])
    }
    override func layoutSubviews() {
        errorView.frame = CGRect(x: 50, y: 50, width: 343, height: 455)
        imageView.frame = CGRect(x: 8, y: 48, width: 327, height: 211)
        boldLabel.frame = CGRect(x: 63.5, y: 275, width: 216, height: 27)
        secondaryLabel.frame = CGRect(x: 32.5, y: 306, width: 278, height: 46)
        tryAgainButton.frame = CGRect(x: 24, y: 368, width: 295, height: 39)
    }
    @objc private func tapTryAgain(){
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
                }) { _ in
                    // Приховання поп-апу після завершення анімації
                    self.removeFromSuperview()
                    self.alpha = 1
                }
    }
}
