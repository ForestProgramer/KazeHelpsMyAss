//
//  AGRegistrationViewController.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 03.02.2022.
//

import UIKit
import RxSwift
import RxCocoa

class AGRegistrationViewController: AGViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var gradientView: UIView!
    @IBOutlet private weak var panelView: UIView!
    @IBOutlet private weak var emailView: UIView!
    @IBOutlet private weak var passwordView: UIView!
    @IBOutlet private weak var confirmPasswordView: UIView!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var confirmPasswordField: UITextField!
    @IBOutlet private weak var goToLogButton: UIButton!
    @IBOutlet private weak var showPasswordButton: UIButton!
    @IBOutlet private weak var showConfirmButton: UIButton!
    @IBOutlet private weak var bottomConstant: NSLayoutConstraint!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        Observable.combineLatest(self.emailField.rx.text.orEmpty, self.passwordField.rx.text.orEmpty, self.confirmPasswordField.rx.text.orEmpty) {email, password, confirm -> Bool in
            return email.count > 0 && password.count > 5 && confirm.count > 5 && email.isValidEmail() && password == confirm
        }.bind(to: self.loginButton.rx.isEnabled).disposed(by: self.disposeBag)
    }
    
    @available(iOSApplicationExtension, unavailable)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainView.frame = self.hasSafeArea ? self.scrollView.frame : CGRect(x: self.scrollView.frame.origin.x, y: self.scrollView.frame.origin.y, width: self.scrollView.frame.width, height:  self.view.contentHeight)
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.view.contentHeight)
        self.panelView.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: gCorrnerRadius)
    }
    
    @available(iOSApplicationExtension, unavailable)
    private func setup() {
        self.scrollView.addSubview(self.mainView)
        self.scrollView.contentOffset = .zero;
        self.scrollView.contentInset = UIEdgeInsets.zero
        let colors = [UIColor(hexString: "#FFFFFF"), UIColor(hexString: "#85B6FF")]
        let locations = [0 as NSNumber, 0.98 as NSNumber]
        _ = self.gradientView.applyGradient(colours: colors, locations: locations)
        self.goToLogButton.layer.cornerRadius = self.gCorrnerRadius
        self.goToLogButton.layer.borderColor = UIColor(named: "AccentColor")!.cgColor
        self.goToLogButton.layer.borderWidth = 1
        self.goToLogButton.clipsToBounds = true
        self.bottomConstant.constant = self.hasSafeArea ? 36 + self.view.safeAreaTopHeight + self.view.safeAreaBottomHeight : self.bottomConstant.constant
    }
    
    @available(iOSApplicationExtension, unavailable)
    override func setBottomOffset(keyboardInfo: UIKeyboardInfo) {
        UIView.animate(withDuration: 0, delay: keyboardInfo.frame.height > 0 ? 0.3 : 0, options: UIView.AnimationOptions.curveEaseInOut) {
            self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.scrollView.frame.height + keyboardInfo.frame.height)
            let offset: CGPoint = CGPoint(x: 0, y: self.scrollView.contentSize.height / 7)
            self.scrollView.contentOffset = keyboardInfo.frame.height > 0 ? offset : CGPoint(x: 0, y: -self.view.safeAreaTopHeight)
        } completion: { _ in }
        
    }
    
    @IBAction private func showPassword(_ sender: UIButton) {
        if sender.tag == 0 {
            self.showPasswordButton.isSelected = !self.showPasswordButton.isSelected
            self.passwordField.isSecureTextEntry = !self.showButton.isSelected
        } else {
            self.showConfirmButton.isSelected = !self.showConfirmButton.isSelected
            self.confirmPasswordView.isSecureTextEntry = !self.confirmPasswordView.isSelected
        }
    }
    
    @IBAction private func goToLogin() {
        if let controller = self.navigationController?.viewControllers.filter({$0.isMember(of: AGLoginViewController.self)}).first {
            self.navigationController?.popToViewController(controller, animated: true)
        } else {
            self.performSegue(withIdentifier: "showLoginSeque", sender: self)
        }
    }

    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}

extension AGRegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailField {
            self.passwordField.becomeFirstResponder()
        } else if textField == self.passwordField {
            self.confirmPasswordField.becomeFirstResponder()
        } else if textField == self.confirmPasswordField {
            self.emailField.becomeFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if textField == self.passwordField, let text = textField.text {
                self.showPasswordButton.isHidden = text.isEmpty
            } else if textField == self.confirmPasswordField, let text = textField.text {
                self.showConfirmButton.isHidden = text.isEmpty
            }
        }
        return true
    }
}