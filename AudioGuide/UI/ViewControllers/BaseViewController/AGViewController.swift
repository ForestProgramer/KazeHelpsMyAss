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

extension AGViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


class AGViewController: UIViewController {

    @IBInspectable var gCorrnerRadius: CGFloat = 10
    @IBInspectable var shouldHandleKeyboardSizeChange: Bool = false
    @IBInspectable var cancelsEditingByBackgroundTap: Bool = false
    
    private let keyboardPool = NoticeObserverPool()
    private var keyboardOffset: CGFloat = 0
    private var tapRecognizer: UITapGestureRecognizer!
    
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
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
    
    private func setKeyboardOffset(keyboardInfo: UIKeyboardInfo) {
        let offset = keyboardInfo.frame.size.height
        if self.keyboardOffset != offset {
            self.keyboardOffset = offset
            self.setBottomOffset(keyboardInfo: keyboardInfo)
        }
    }
    
    func setBottomOffset(keyboardInfo: UIKeyboardInfo) {
    }

    @available(iOSApplicationExtension, unavailable)
    func logout() {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        keyWindow.rootViewController = UINavigationController(rootViewController: viewController)
        keyWindow.makeKeyAndVisible()
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

