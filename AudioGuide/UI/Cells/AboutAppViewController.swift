//
//  AboutAppViewController.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 02.01.2024.
//

import UIKit

class AboutAppViewController: AGViewController {
    let viewBackground : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(hexString: "#FAFAFA")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.PoppinsFont(ofSize: 24)
        label.text = "About the app"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let appImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "videoImage") // Замініть на назву вашого зображення
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.PoppinsFont(ofSize: 16)
        label.text = """
           Introducing Lviv Audio Guide, the perfect travel companion for discovering the beautiful city of Lviv! With our interactive audio guide, you can explore the city like a local and get an immersive look into the unique culture of this fascinating city. Our audio guide includes a range of informative audio tours covering the city's history, culture, architecture, and more. Whether you're a first-time visitor or a local looking to explore, our audio guide will provide you with an unforgettable experience of Lviv. With our easy to use interface, you can customize your experience and choose from a variety of audio tours, ensuring you get the most out of your trip to Lviv. So, what are you waiting for? Download Lviv Audio Guide today and start exploring the city like a local!
           """
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(viewBackground)
        viewBackground.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(appImageView)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            viewBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewBackground.topAnchor.constraint(equalTo: view.topAnchor,constant: self.safeAreaTopHeight + CustomNavigationController.customNavigationBarHeight),
            viewBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollView.leadingAnchor.constraint(equalTo: viewBackground.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: viewBackground.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: viewBackground.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: viewBackground.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
            appImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            appImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            appImageView.widthAnchor.constraint(equalToConstant: 343),
            appImageView.heightAnchor.constraint(equalToConstant: 262),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: appImageView.bottomAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }
    
}
