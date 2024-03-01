//
//  AGMainTabBarController.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 07.02.2022.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
protocol TopPanelControllable {
    func shouldShowTopPanel(_ show: Bool)
}


class AGMainTabBarController: UITabBarController {
    let apiCall = APIManager.shared
    @IBOutlet private weak var menuView: AGMenuView!
    @IBOutlet private weak var topPanel: AGTopPanel!
    @IBOutlet private weak var topMenuView: AGTopMenuView!
    @IBOutlet private weak var filterMapView: AGFilterMapView!
    
    
    static var tabBarHeight: CGFloat = 0
    private let width = 3.6 * UIScreen.main.bounds.width / 5
    private var isMapSelect = false
    private var isMenuShow = false
    private var isTopMenuShow = false
    private var isFilterShow = false
    private var dimmingView: UIView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        menuView.tabBarController = self
        menuView.closeViewBtn.addTarget(self, action: #selector(hideMenu), for: .touchUpInside)
        if UserDefaults.isFreeVersion == true{
            print("isFreeVersion == true")
            menuView.logoutButton.backgroundColor = UIColor(hexString: "#973939")
            menuView.logoutButton.layer.borderColor = UIColor.clear.cgColor
            menuView.logoutButton.layer.borderWidth = 0
            menuView.logoutButton.setTitleColor( .white, for: .normal)
            menuView.logoutButton.setTitle("Log in", for: .normal)
            menuView.logoutButton.addTarget(self, action: #selector(oppenRegView), for: .touchUpInside)
        }else if UserDefaults.isUserAuthorizationPassed == true{
            print("isUserAuthorizationPassed == true")
            menuView.logoutButton.backgroundColor = .clear
            menuView.logoutButton.layer.borderColor = UIColor(hexString: "#973939").cgColor
            menuView.logoutButton.layer.borderWidth = 1
            menuView.logoutButton.setTitleColor(UIColor(hexString: "#973939"), for: .normal)
            menuView.logoutButton.setTitle("Log out", for: .normal)
            menuView.logoutButton.addTarget(self, action: #selector(logOutUser), for: .touchUpInside)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let navigation = self.navigationController {
            navigation.viewControllers = [self]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        AGMainTabBarController.tabBarHeight = self.tabBar.frame.size.height
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.menuView.frame = self.isMenuShow ? CGRect(x: 0, y: self.safeAreaTopHeight, width: self.width , height: UIScreen.main.bounds.height - self.safeAreaTopHeight) :  CGRect(x: -self.width, y: self.safeAreaTopHeight, width: self.width, height: UIScreen.main.bounds.height - self.safeAreaTopHeight)
        self.topMenuView.frame = self.isTopMenuShow ? CGRect(x: 0, y: self.topPanel.frame.height, width: UIScreen.main.bounds.width - 130, height: 200) :  CGRect(x: 0, y: self.topPanel.frame.height, width: UIScreen.main.bounds.width - 130, height: 0)
        self.filterMapView.frame = self.isFilterShow ? CGRect(x: UIScreen.main.bounds.width - 240, y: self.topPanel.frame.height, width: 240, height: 520) :  CGRect(x: UIScreen.main.bounds.width - 240, y: self.topPanel.frame.height, width: 240, height: 0)
        self.topPanel.frame = CGRect(x: 0, y: safeAreaTopHeight, width: UIScreen.main.bounds.width, height: 85)
        if self.isTopMenuShow {
            self.topPanel.roundCorners(corners: [.layerMaxXMaxYCorner], radius: 10)
        } else if self.isFilterShow {
            self.topPanel.roundCorners(corners: [.layerMinXMaxYCorner], radius: 10)
        } else {
            self.topPanel.roundCorners(corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 10)
        }
    }
    @objc private func oppenRegView(){
        UserDefaults.isFreeVersion = false
        UserDefaults.isFirstLaunchPassed = false
        guard let logVC = self.storyboard?.instantiateViewController(withIdentifier: "AGRegistrationViewController") else {
            return
        }
            self.navigationController?.pushViewController(logVC, animated: false)
    }
    @objc private func logOutUser(){
        guard let userToken = UserDefaults.userBearerToken, let idDevice = UserDefaults.standard.value(forKey: "id_device") as? String else{
            return
        }
        print("Bearer : \(userToken)\nIdDevice : \(idDevice)")
        apiCall.logOut(deviceID: idDevice,bearerToken: userToken) { result in
            switch result{
            case .success(_):
                print("Success Logout")
                UserDefaults.isUserAuthorizationPassed = false
                UserDefaults.isFreeVersion = false
                UserDefaults.isFirstLaunchPassed = false
                UserDefaults.userEmail = nil
                GIDSignIn.sharedInstance.signOut()
                FBSDKLoginKit.LoginManager().logOut()
                AGViewController.logout()
            case .failure(let error):
                print("Error to logOut : \(error)")
            }
        }
    }
    private func dimTabBar(_ dim: Bool) {
        if dim {
            // Затемнення
            dimmingView = UIView(frame: self.view.bounds)
            dimmingView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            dimmingView?.alpha = 0
            self.view.addSubview(dimmingView!)
            
            // Додайте dimmingView перед menuView
            self.view.insertSubview(dimmingView!, belowSubview: menuView)
            
            UIView.animate(withDuration: 0.3) {
                self.dimmingView?.alpha = 1.0
            }
        }else{
            // Зняття затемнення
            UIView.animate(withDuration: 0.3, animations: {
                self.dimmingView?.alpha = 0
            }) { _ in
                self.dimmingView?.removeFromSuperview()
            }
        }
    }
    private func setup() {
        //MARK: Remove one of tabs
        //        if UserDefaults.isFreeVersion == true {
        //            var viewControllers = self.viewControllers
        //            viewControllers?.remove(at: 1)
        //            self.viewControllers = viewControllers
        //
        //        }
        
        self.topPanel.selectIndex = 0
        if let items = self.tabBar.items {
            for item in items {
                item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 14)
                item.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
                item.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.PoppinsFont(ofSize: 10)], for: .normal)
            }
        }
        self.delegate = self
        
        //        let swipeGestureRecognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeRight(_:)))
        //        swipeGestureRecognizerRight.direction = .right
        //        self.view.addGestureRecognizer(swipeGestureRecognizerRight)
        //
        //        let swipeGestureRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft(_:)))
        //        swipeGestureRecognizerLeft.direction = .left
        //        self.view.addGestureRecognizer(swipeGestureRecognizerLeft)
        
        //        self.view.addSubview(self.topMenuView)
        //        self.view.addSubview(self.filterMapView)
        //        self.view.addSubview(self.topPanel)
        self.view.addSubview(self.menuView)
        
        self.addHandlers()
    }
    
    private func addHandlers() {
        self.topPanel.showMenu = {
            self.topPanel.isFilterShow = false
            self.hideFilter()
            self.showTopMenu()
        }
        self.topPanel.hideMenu = {
            self.hideTopMenu()
        }
        self.topPanel.showFilter = {
            self.topPanel.isMenuShow = false
            self.hideTopMenu()
            self.showFilter()
        }
        self.topPanel.hideFilter = {
            self.hideFilter()
        }
        self.topMenuView.selectItem = { index in
            self.topPanel.isMenuShow = false
            self.hideTopMenu()
            if index == 0 {
                self.performSegue(withIdentifier: "showIntrastingSeque", sender: nil)
            } else if index == 3 {
                self.performSegue(withIdentifier: "showInfrastructureSeque", sender: nil)
            }
        }
    }
    
    private func showTopMenu() {
        self.isTopMenuShow = true
        self.topMenuView.isHidden = false
        self.topMenuView.tableView.alpha = 0
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            self.topMenuView.frame = CGRect(x: 0, y: self.topPanel.frame.height, width: UIScreen.main.bounds.width - 130, height: 200)
            self.topMenuView.tableView.alpha = 1
        } completion: { _ in }
        
    }
    func showMenu() {
        self.isMenuShow = true
        dimTabBar(true) // Затемнити UITabBarController
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.menuView.frame = CGRect(x: 0, y: self.safeAreaTopHeight, width: self.width, height: UIScreen.main.bounds.height - self.safeAreaTopHeight)
        } completion: { _ in }
    }
    @objc func hideMenu() {
        self.isMenuShow = false
        dimTabBar(false) // Зняти затемнення UITabBarController
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.menuView.frame = CGRect(x: -self.width, y: self.safeAreaTopHeight, width: self.width, height: UIScreen.main.bounds.height - self.safeAreaTopHeight)
        } completion: { _ in }
    }
    
    private func hideTopMenu() {
        self.isTopMenuShow = false
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            self.topMenuView.frame = CGRect(x: 0, y: self.topPanel.frame.height, width: UIScreen.main.bounds.width - 130, height: 0)
            self.topMenuView.tableView.alpha = 0
        } completion: { _ in self.topMenuView.isHidden = true}
        
    }
    
    private func showFilter() {
        self.isFilterShow = true
        self.filterMapView.isHidden = false
        self.filterMapView.tableView.alpha = 0
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            self.filterMapView.frame = CGRect(x: UIScreen.main.bounds.width - 240, y: self.topPanel.frame.height, width: 240, height: 520)
            self.filterMapView.tableView.alpha = 1
        } completion: { _ in }
        
    }
    
    private func hideFilter() {
        self.isFilterShow = false
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            self.filterMapView.frame = CGRect(x: UIScreen.main.bounds.width - 240, y: self.topPanel.frame.height, width: 240, height: 0)
            self.filterMapView.tableView.alpha = 0
        } completion: { _ in self.filterMapView.isHidden = true}
        
    }
    
    @objc private func didSwipeRight(_ sender: UISwipeGestureRecognizer) {
        self.isMenuShow = true
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.menuView.frame = CGRect(x: 0, y: 0, width: self.width, height: UIScreen.main.bounds.height)
        } completion: { _ in }
        
    }
    
    @objc private func didSwipeLeft(_ sender: UISwipeGestureRecognizer) {
        self.isMenuShow = false
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.menuView.frame = CGRect(x: -self.width, y: 0, width: self.width, height: UIScreen.main.bounds.height)
        } completion: { _ in }
        
    }
    
    
    // MARK: - Navigation
    
    @IBAction private func unwindWithIntrestingUpSegue(unwindSegue: UIStoryboardSegue) {
    }
    
    @IBAction private func unwindWithInfrastructureSegue(unwindSegue: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

extension AGMainTabBarController: UITabBarControllerDelegate {
    
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.topPanel.selectIndex = item.tag
        if item.tag == 3 {
            isMapSelect = !isMapSelect
            item.title = isMapSelect ? "Map" : "AR"
            ChangeMapState.post(info: isMapSelect)
        }
    }

    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    
    }
}

