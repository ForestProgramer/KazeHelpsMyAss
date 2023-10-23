//
//  AGMainTabBarController.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 07.02.2022.
//

import UIKit

class AGMainTabBarController: UITabBarController {

    @IBOutlet private weak var menuView: AGMenuView!
    @IBOutlet private weak var topPanel: AGTopPanel!
    @IBOutlet private weak var topMenuView: AGTopMenuView!
    @IBOutlet private weak var filterMapView: AGFilterMapView!
    
    
    static var tabBarHeight: CGFloat = 0
    private let width = 4 * UIScreen.main.bounds.width / 5
    private var isMapSelect = false
    private var isMenuShow = false
    private var isTopMenuShow = false
    private var isFilterShow = false
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
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
        self.menuView.frame = self.isMenuShow ? CGRect(x: 0, y: 0, width: self.width, height: UIScreen.main.bounds.height) :  CGRect(x: -self.width, y: 0, width: self.width, height: UIScreen.main.bounds.height)
        self.topMenuView.frame = self.isTopMenuShow ? CGRect(x: 0, y: self.topPanel.frame.height, width: UIScreen.main.bounds.width - 130, height: 200) :  CGRect(x: 0, y: self.topPanel.frame.height, width: UIScreen.main.bounds.width - 130, height: 0)
        self.filterMapView.frame = self.isFilterShow ? CGRect(x: UIScreen.main.bounds.width - 240, y: self.topPanel.frame.height, width: 240, height: 520) :  CGRect(x: UIScreen.main.bounds.width - 240, y: self.topPanel.frame.height, width: 240, height: 0)
        self.topPanel.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 85 + self.safeAreaTopHeight)
        if self.isTopMenuShow {
            self.topPanel.roundCorners(corners: [.layerMaxXMaxYCorner], radius: 10)
        } else if self.isFilterShow {
            self.topPanel.roundCorners(corners: [.layerMinXMaxYCorner], radius: 10)
        } else {
            self.topPanel.roundCorners(corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 10)
        }
    }
    
    private func setup() {

        if UserDefaults.isFreeVersion == true {
            var viewControllers = self.viewControllers
            viewControllers?.remove(at: 1)
            self.viewControllers = viewControllers
            
        }
        
        self.topPanel.selectIndex = 0
        if let items = self.tabBar.items {
            for item in items {
                item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 14)
                item.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
                item.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.PoppinsFont(ofSize: 10)], for: .normal)
            }
        }
        self.delegate = self
        
        let swipeGestureRecognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeRight(_:)))
        swipeGestureRecognizerRight.direction = .right
        self.view.addGestureRecognizer(swipeGestureRecognizerRight)
        
        let swipeGestureRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft(_:)))
        swipeGestureRecognizerLeft.direction = .left
        self.view.addGestureRecognizer(swipeGestureRecognizerLeft)
        
        self.view.addSubview(self.topMenuView)
        self.view.addSubview(self.filterMapView)
        self.view.addSubview(self.topPanel)
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

