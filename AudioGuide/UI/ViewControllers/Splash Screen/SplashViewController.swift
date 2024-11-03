//
//  SplashViewController.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 23.09.2024.
//
import UIKit

class SplashViewControllerrr: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background color (customize as needed)
        view.backgroundColor = .white
//        // Create and configure the image view
//        let imageView = UIImageView(image: UIImage(named: "Vector"))
//        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(imageView)
//        
//        // Center the image view in the splash screen
//        NSLayoutConstraint.activate([
//            
//            
//            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            imageView.widthAnchor.constraint(equalToConstant: 200), // Adjust size as needed
//            imageView.heightAnchor.constraint(equalToConstant: 200) // Adjust size as needed
//        ])
//        
//        // Simulate a delay for the splash screen (optional)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            self.showMainApp()
//        }
    }
    
    private func showMainApp() {
        print("Showed main App controller")
//        let mainViewController = MainViewController() // Your main app's initial view controller
//        let navigationController = UINavigationController(rootViewController: mainViewController)
//        navigationController.modalPresentationStyle = .fullScreen
//        UIApplication.shared.windows.first?.rootViewController = navigationController
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}

