//
//  CustomNavigationBar.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 24.12.2023.
//

import UIKit

class CustomNavigationBar: UINavigationBar {
    weak var mainTabBarController: AGMainTabBarController?
    
   
    private var leftButton: UIButton!
    private var rightUIView : UIView!
    private var userLabel : UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
        
        // Додати кнопку зліва
        leftButton = UIButton(type: .custom)
        leftButton.setImage(UIImage(named: "left_burger"), for: .normal)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        addSubview(leftButton)
        rightUIView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        rightUIView.backgroundColor = UIColor(hexString: "#973939")
        rightUIView.layer.cornerRadius = 8
        rightUIView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rightUIView)
        userLabel = UserDefaults.userEmail != nil ? UILabel() : nil
        if let label = userLabel{
            label.textColor = .white
            label.text = UserDefaults.userEmail?.first?.uppercased()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .PoppinsFont(ofSize: 18)
            rightUIView.addSubview(label)
            NSLayoutConstraint.activate([
                label.centerYAnchor.constraint(equalTo: rightUIView.centerYAnchor),
                label.centerXAnchor.constraint(equalTo: rightUIView.centerXAnchor),
            ])
        }
        // Налаштувати обмеження кнопки
        NSLayoutConstraint.activate([
            leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            leftButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            rightUIView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
            rightUIView.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightUIView.heightAnchor.constraint(equalToConstant: 32),
            rightUIView.widthAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAppearance()
    }
    @objc func leftButtonTapped() {
        mainTabBarController?.showMenu()
    }
    private func setupAppearance() {
        // Встановлення вигляду вашого кастомного NavigationBar
        self.backgroundColor = UIColor(hexString: "#FAFAFA")
        self.tintColor = .white
        self.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    func openNavigationBar() {
        self.isHidden = false
        // Додайте код анімації або інші налаштування при потребі
    }
    
    func closeNavigationBar() {
        self.isHidden = true
        // Додайте код анімації або інші налаштування при потребі
    }
}
