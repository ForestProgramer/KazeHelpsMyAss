//
//  NoAccountPopUp.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 07.02.2024.
//

import Foundation
import UIKit

class NoAccountPopUp: UIView {
    let lostWifiView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let imageView : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        let im = UIImage(named: "noResultsImage")
        image.image = im
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let boldLabel : UILabel = {
        let label = UILabel()
        label.text = "Account needed!"
        label.font = .PoppinsFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    let secondaryLabel : UILabel = {
        let label = UILabel()
        label.text = "To use this function you should have an account"
        label.font = .PoppinsFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    public let tryAgainButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor(hexString: "#973939")
        btn.setTitle("Create an account in 2 min", for: .normal)
        btn.titleLabel?.textColor = .white
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    let ridButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "ridViewImage"), for: .normal)
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(didRidPopUp), for: .touchUpInside)
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
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        addSubview(lostWifiView)
        lostWifiView.addSubview(imageView)
        lostWifiView.addSubview(boldLabel)
        lostWifiView.addSubview(secondaryLabel)
        lostWifiView.addSubview(tryAgainButton)
        lostWifiView.addSubview(ridButton)
        NSLayoutConstraint.activate([
            lostWifiView.widthAnchor.constraint(equalToConstant: 343),
            lostWifiView.heightAnchor.constraint(equalToConstant: 455),
            lostWifiView.centerYAnchor.constraint(equalTo: centerYAnchor),
            lostWifiView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: lostWifiView.leadingAnchor,constant: 8),
            imageView.topAnchor.constraint(equalTo: lostWifiView.topAnchor,constant: 48),
            imageView.widthAnchor.constraint(equalToConstant: 327),
            imageView.heightAnchor.constraint(equalToConstant: 211),
            
            boldLabel.leadingAnchor.constraint(equalTo: lostWifiView.leadingAnchor,constant: 63.5),
            boldLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 16),
            boldLabel.widthAnchor.constraint(equalToConstant: 216),
            boldLabel.heightAnchor.constraint(equalToConstant: 27),
            
            secondaryLabel.leadingAnchor.constraint(equalTo: lostWifiView.leadingAnchor,constant: 32.5),
            secondaryLabel.topAnchor.constraint(equalTo: boldLabel.bottomAnchor,constant: 4),
            secondaryLabel.widthAnchor.constraint(equalToConstant: 278),
            secondaryLabel.heightAnchor.constraint(equalToConstant: 46),
            
            tryAgainButton.leadingAnchor.constraint(equalTo: lostWifiView.leadingAnchor,constant:24),
            tryAgainButton.topAnchor.constraint(equalTo: secondaryLabel.bottomAnchor,constant: 16),
            tryAgainButton.widthAnchor.constraint(equalToConstant: 295),
            tryAgainButton.heightAnchor.constraint(equalToConstant: 39),
            
            ridButton.topAnchor.constraint(equalTo: lostWifiView.topAnchor,constant: 32),
            ridButton.trailingAnchor.constraint(equalTo:lostWifiView.trailingAnchor,constant: -24),
            ridButton.heightAnchor.constraint(equalToConstant: 24),
            ridButton.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    override func layoutSubviews() {
    }
    @objc private func didRidPopUp(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.alpha = 0
            }completion: { _ in
                self.isHidden = true
            }
        }
    }
}
