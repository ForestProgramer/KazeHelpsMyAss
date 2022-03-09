//
//  AGMapViewController.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 04.02.2022.
//

import UIKit
import ARKit
import SceneKit
import NoticeObserveKit

class AGMapViewController: AGViewController {

    @IBOutlet private weak var popupView: AGDetailsPopup!
    @IBOutlet private weak var mapView: AGMapView!
    @IBOutlet private weak var arkitView: AGARVIew!
    
    private var isPopupShow = false
    private let pool = NoticeObserverPool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .gravityAndHeading
        self.arkitView.sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.arkitView.sceneView.session.pause()
    }
    
    @available(iOSApplicationExtension, unavailable)
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.popupView.frame = isPopupShow ? CGRect(x: 0, y: self.view.frame.height - 150 - AGMainTabBarController.tabBarHeight - self.safeAreaBottomHeight, width: self.view.frame.width, height: 150) : CGRect(x: 0, y: self.view.frame.height + AGMainTabBarController.tabBarHeight , width: self.view.frame.width, height: 150)
        
    }
    
    @available(iOSApplicationExtension, unavailable)
    private func setup() {
        self.view.addSubview(popupView)
        self.view.bringSubviewToFront(popupView)
        self.addHandlers()
    }
    
    
    
    private func addHandlers() {
        
        self.mapView.tapAction = {
            self.isPopupShow = false
            self.hidePopup()
        }
        
        self.mapView.tapMaker = {
            self.isPopupShow = true
            self.showPopup()
        }
        
        self.arkitView.tapMaker = {
            self.isPopupShow = !self.isPopupShow
            if self.isPopupShow {
                self.showPopup()
            } else {
                self.hidePopup()
            }
        }
        
        self.popupView.tapAction = {
            self.showDetails()
        }
        
        ChangeMapState.observe {[weak self] state in
            guard let `self` = self  else { return }
            self.mapView.isHidden = !state
            self.arkitView.isHidden = !self.mapView.isHidden
        }.disposed(by: self.pool)
    }
    
    private func showPopup() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
            self.popupView.frame = CGRect(x: 0, y: self.view.frame.height - 150 - AGMainTabBarController.tabBarHeight - self.safeAreaBottomHeight, width: self.view.frame.width, height: 150)
        } completion: { _ in }

    }
    
    private func hidePopup() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
            self.popupView.frame = CGRect(x: 0, y: self.view.frame.height + AGMainTabBarController.tabBarHeight , width: self.view.frame.width, height: 150)
        } completion: { _ in }

    }
    
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }
    

}
