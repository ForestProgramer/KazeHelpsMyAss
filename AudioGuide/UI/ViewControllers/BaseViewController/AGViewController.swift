//
//  ViewController.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 01.02.2022.
//

import UIKit
import NoticeObserveKit
import RxSwift
import RxCocoa
import SystemConfiguration
extension AGViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


class AGViewController: UIViewController {

    @IBInspectable var gCorrnerRadius: CGFloat = 5
    @IBInspectable var shouldHandleKeyboardSizeChange: Bool = false
    @IBInspectable var cancelsEditingByBackgroundTap: Bool = false
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "www.apple.com")
    private var flags = SCNetworkReachabilityFlags()
    private let keyboardPool = Notice.ObserverPool()
    private var keyboardOffset: CGFloat = 0
    private var tapRecognizer: UITapGestureRecognizer!
//    private let viewBackgroundColor : UIColor = .black
    
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.shouldHandleKeyboardSizeChange {
            UIKeyboardWillChangeFrame.observe {[weak self] keyboardInfo in
                guard let `self` = self else { return }
                self.setKeyboardOffset(keyboardInfo: keyboardInfo)
                }.disposed(by: self.keyboardPool)
            UIKeyboardWillHide.observe {[weak self] keyboardInfo in
                guard let `self` = self else { return }
                self.setKeyboardOffset(keyboardInfo: UIKeyboardInfo(info: [:]))
                }.disposed(by: self.keyboardPool)
        }
        if self.cancelsEditingByBackgroundTap {
            self.tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(AGViewController.backgroundTapAction(recognizer:)))
            self.tapRecognizer.cancelsTouchesInView = false
            self.view.addGestureRecognizer(self.tapRecognizer)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func showLocationDetails(choosedId : Int) {
        let viewController = AGMainDetailsViewController(with: choosedId, typeOfDetail: .location)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    func showTourDetails(choosedId: Int) {
        let viewController = AGMainDetailsViewController(with: choosedId, typeOfDetail: .tour)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func setKeyboardOffset(keyboardInfo: UIKeyboardInfo) {
        let offset = keyboardInfo.frame.size.height
        if self.keyboardOffset != offset {
            self.keyboardOffset = offset
            self.setBottomOffset(keyboardInfo: keyboardInfo)
        }
    }
    
    func setBottomOffset(keyboardInfo: UIKeyboardInfo) {
    }
    public func isInternetConnected(completion: @escaping (SCNetworkReachabilityFlags) -> Void) {
        // Додати слухача подій для моніторингу змін стану мережі
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())

        if SCNetworkReachabilitySetCallback(reachability!, { (reachability, flags, info) in
            if let info = info {
                let sceneDelegate = Unmanaged<AGViewController>.fromOpaque(info).takeUnretainedValue()
                sceneDelegate.flags = flags
//                completion(flags)
            }
        }, &context) {
            SCNetworkReachabilityScheduleWithRunLoop(reachability!, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
        }

        // Початкова перевірка стану мережі
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability!, &flags)

        // Викликати замикання з параметром flags
        completion(flags)
    }
    // Функція для обробки змін стану мережі
    public func handleNetworkChange(flags: SCNetworkReachabilityFlags)->Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

           if isReachable && !needsConnection {
               // Інтернет доступний, нічого не робимо
               return false
           } else {
               // Немає інтернет-з'єднання, показуємо повідомлення
               return true
           }
    }
    public func showNoWifi4PopUp() {
        DispatchQueue.main.async {
           

            let wifiPopUpView = LostWifiConnectionUIView()
            wifiPopUpView.frame = self.view.bounds
            self.view.addSubview(wifiPopUpView)

            print("Everything must work")
            wifiPopUpView.alpha = 0.0

            // Анімація відображення затемнення і поп-апу
            UIView.animate(withDuration: 0.3) {
                wifiPopUpView.alpha = 1.0
            }
        }
    }
    
    @available(iOSApplicationExtension, unavailable)
    class func logout() {
        DispatchQueue.main.async {
            guard let keyWindow = UIApplication.shared.keyWindow else { return }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(withIdentifier: "AGLoginViewController") as? AGLoginViewController else{
                return
            }
            keyWindow.rootViewController = UINavigationController(rootViewController: viewController)
            keyWindow.makeKeyAndVisible()
        }
    }
    
    @objc private func backgroundTapAction(recognizer: UITapGestureRecognizer) {
        if self.isInsideTextField(parent: self.view, touchRecognizer: self.tapRecognizer) == false {
            self.view.endEditing(true)
        }
    }
    
    private func isInsideTextField(parent: UIView, touchRecognizer: UITapGestureRecognizer) -> Bool {
        let location = touchRecognizer.location(in: parent)
        for subview in parent.subviews {
            if subview.frame.contains(location) {
                if subview is UITextField {
                    return true
                } else if isInsideTextField(parent: subview, touchRecognizer: touchRecognizer) {
                    return true
                }
            }
        }
        return false
    }
    
    @available(iOSApplicationExtension, unavailable)
    func showAlert(title: String = "", message: String) {
        let panel = AGNotificationPanel()
        panel.notificationType = .error
        panel.message = message
        panel.show()
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let closeAction = UIAlertAction(title: "Ok", style: .cancel) { [weak alert] _ in
//            alert?.dismiss(animated: true, completion: nil)
//        }
//        alert.addAction(closeAction)
//        self.present(alert, animated: true, completion: nil)
    }
}

