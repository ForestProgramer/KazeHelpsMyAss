//
//  AGMenuView.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 09.02.2022.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import SwiftUI
import StoreKit
class AGMenuView: UIView {
    let apiCall = APIManager.shared
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet public weak var logoutButton: UIButton!
    @IBOutlet public weak var closeViewBtn: UIButton!
    private let dataSource = ["Interesting facts about Lviv", "My purchases", "About the app", "Change language", "Rate us", "Share the app", "Terms and conditions"]
//    private var currentIndex = 0
    private var imagesMassive = ["lionImage","walletImage","phoneImage","globalImage","starImage","shareImage","documentImage"]
    weak var tabBarController: AGMainTabBarController? {
            didSet {
                setupMenu()
            }
        }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction private func logoutHandler(_ sender: UIButton) {
        
    }
    private func setupMenu() {
            // Ініціалізація та налаштування меню, використовуючи tabBarController, якщо потрібно
            tableView.dataSource = self
            tableView.delegate = self
            tableView.reloadData()
        }
}

// MARK: - UITableViewDataSource methods

extension AGMenuView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.dataSource[indexPath.row]
        let images = self.imagesMassive[indexPath.row]
        let cell = UITableViewCell()
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.imageView?.image = UIImage(named: images)
        cell.imageView?.contentMode = .scaleAspectFill
        cell.textLabel?.text = item
        cell.textLabel?.font = UIFont.PoppinsFont(ofSize: 14)
        cell.textLabel?.textColor =  UIColor(hexString: "#973939")
        return cell
    }
    
}

// MARK: - UITableViewDelegate methods

extension AGMenuView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = dataSource[indexPath.row]
        
        // Перевірте, чи це кнопки "Share app" або "Rate us"
        if selectedItem == "Terms and conditions" {
            closeMenu()
            openNewController(for: selectedItem, and: TermsAndConditionViewController())
        }else if selectedItem == "About the app" {
            closeMenu()
            openNewController(for: selectedItem, and: AboutAppViewController())
        }else if selectedItem == "Share the app" {
//            closeMenu()
            presentShareSheet()
        } else if selectedItem == "My purchases"{
            print("My purchases")
            closeMenu()
            openNewController(for: selectedItem, and: PersonalPurchasesViewController())
        }else if selectedItem == "Rate us"{
            rateApp()
        }else{
            
        }
    }
    private func closeMenu() {
        // Отримайте посилання на tabBarController через слабке посилання
        guard let tabBarController = tabBarController else {
            print("Do not find tabBarController")
            return
        }
        
        // Закрийте бокове меню
        tabBarController.hideMenu()
    }
    private func presentShareSheet(){
        guard let url = URL(string: "https://www.google.com") else{
            return
        }
        let shareSheetVC = UIActivityViewController(activityItems: [
            url
        ], applicationActivities: nil)
        tabBarController?.present(shareSheetVC, animated: true, completion: nil)
    }
    private func rateApp(){
        guard let tabBarVC = tabBarController, let scene = tabBarVC.view.window?.windowScene else{
            return
        }
        SKStoreReviewController.requestReview(in: scene)
    }
    // Функція для відкриття нового контролера в tabBarController
    private func openNewController(for item: String ,and controller : UIViewController) {
        // Отримайте посилання на tabBarController через слабке посилання
        guard let tabBarController = tabBarController else {
            return
        }
        
        // Створіть новий контролер, який ви хочете відобразити
        let newViewController = controller
        
        // ... Налаштуйте ваш новий контролер за необхідності ...
        
        // Отримайте поточний вибраний індекс ваших контролерів
        let selectedIndex = tabBarController.selectedIndex
        
        // Отримайте поточний UINavigationController в tabBarController
        if let currentNavController = tabBarController.viewControllers?[selectedIndex] as? UINavigationController {
            // Викличте pushViewController, щоб відобразити ваш новий контролер
            currentNavController.pushViewController(newViewController, animated: true)
        }
    }
    
    // ... інші методи і функції ...
}
