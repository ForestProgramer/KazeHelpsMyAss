//
//  CustomNavigationController.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 24.12.2023.
//

import UIKit

class CustomNavigationController: UINavigationController {
    public let customNavigationBar = CustomNavigationBar()
    static public let customNavigationBarHeight = 85.0
    override func viewDidLoad() {
        super.viewDidLoad()
        if let customNavigationBar = self.customNavigationBar as? CustomNavigationBar {
            customNavigationBar.mainTabBarController = self.tabBarController as? AGMainTabBarController
        }
        // Приховати системний навігаційний бар
        navigationBar.isHidden = true
        
        // Додати кастомний навігаційний бар
        view.addSubview(customNavigationBar)
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customNavigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavigationBar.heightAnchor.constraint(equalToConstant: CGFloat(CustomNavigationController.customNavigationBarHeight))
        ])
        
    }
    // Статичний метод для відображення кастомного навігаційного бару
//    static func showCustomNavigationBar() {
////            customNavigationBar.isHidden = false
//
//    }
//    
//    // Статичний метод для приховування кастомного навігаційного бару
//    static func hideCustomNavigationBar() {
//        // Знайдіть поточний навігаційний контролер
//        if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? CustomNavigationController {
//           
//            navigationController.customNavigationBar.isHidden = true
//        }
//    }
}
