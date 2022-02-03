//
//  AGLoginViewController.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 03.02.2022.
//

import UIKit
import RxSwift
import RxCocoa

class AGLoginViewController: AGViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var gradientView: UIView!
    @IBOutlet private weak var panelView: UIView!
    @IBOutlet private weak var emailView: UIView!
    @IBOutlet private weak var passwordView: UIView!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var goToRegButton: UIButton!
    @IBOutlet private weak var loginButton: AGButton!
    @IBOutlet private weak var googleButton: UIButton!
    @IBOutlet private weak var facebookButton: UIButton!
    @IBOutlet private weak var showButton: UIButton!
    @IBOutlet private weak var bottomConstant: NSLayoutConstraint!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        Observable.combineLatest(self.emailField.rx.text.orEmpty, self.passwordField.rx.text.orEmpty) {email, password -> Bool in
            return email.count > 0 && password.count > 5 && email.isValidEmail()
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
        self.goToRegButton.layer.cornerRadius = self.gCorrnerRadius
        self.goToRegButton.layer.borderColor = UIColor(named: "AccentColor")!.cgColor
        self.goToRegButton.layer.borderWidth = 1
        self.goToRegButton.clipsToBounds = true
        self.googleButton.layer.cornerRadius = self.gCorrnerRadius
        self.googleButton.layer.borderColor = UIColor(hexString: "#F8F8F8").withAlphaComponent(0.82).cgColor
        self.googleButton.layer.borderWidth = 1
        self.googleButton.clipsToBounds = true
        self.facebookButton.layer.cornerRadius = self.gCorrnerRadius
        self.facebookButton.layer.borderColor = UIColor(hexString: "#F8F8F8").withAlphaComponent(0.82).cgColor
        self.facebookButton.layer.borderWidth = 1
        self.facebookButton.clipsToBounds = true
        self.emailView.layer.cornerRadius = self.gCorrnerRadius
        self.emailView.layer.borderColor = UIColor(named: "AccentQuarterColor")!.cgColor
        self.emailView.layer.borderWidth = 1
        self.emailView.clipsToBounds = true
        self.passwordView.layer.cornerRadius = self.gCorrnerRadius
        self.passwordView.layer.borderColor = UIColor(named: "AccentQuarterColor")!.cgColor
        self.passwordView.layer.borderWidth = 1
        self.passwordView.clipsToBounds = true
        self.emailField.attributedPlaceholder = NSAttributedString(string: "Email...", attributes: [NSAttributedString.Key.foregroundColor:  UIColor.white, NSAttributedString.Key.font: UIFont.PoppinsFont(ofSize: 16)])
        self.passwordField.attributedPlaceholder = NSAttributedString(string: "Password...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.PoppinsFont(ofSize: 16)])
        self.bottomConstant.constant = self.hasSafeArea ? 36 + self.view.safeAreaTopHeight + self.view.safeAreaBottomHeight : self.bottomConstant.constant
    }
    
    @available(iOSApplicationExtension, unavailable)
    override func setBottomOffset(keyboardInfo: UIKeyboardInfo) {
        UIView.animate(withDuration: 0, delay: keyboardInfo.frame.height > 0 ? 0.3 : 0, options: UIView.AnimationOptions.curveEaseInOut) {
            self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.view.contentHeight + keyboardInfo.frame.height)
            let offset: CGPoint = CGPoint(x: 0, y: self.scrollView.contentSize.height / 7)
            self.scrollView.contentOffset = keyboardInfo.frame.height > 0 ? offset : CGPoint(x: 0, y: -self.view.safeAreaTopHeight)
        } completion: { _ in }
        
    }
    
    @IBAction private func showPassword() {
        self.showButton.isSelected = !self.showButton.isSelected
        self.passwordField.isSecureTextEntry = !self.showButton.isSelected
    }
    
    @IBAction private func goToRegistaration() {
        if let controller = self.navigationController?.viewControllers.filter({$0.isMember(of: AGRegistrationViewController.self)}).first {
            self.navigationController?.popToViewController(controller, animated: true)
        } else {
            self.performSegue(withIdentifier: "showRegistrationSeque", sender: self)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}

extension AGLoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailField {
            self.passwordField.becomeFirstResponder()
        } else if textField == self.passwordField {
            self.emailField.becomeFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.passwordField {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let text = textField.text {
                    self.showButton.isHidden = text.isEmpty
                }
            }
        }
        return true
    }
}
