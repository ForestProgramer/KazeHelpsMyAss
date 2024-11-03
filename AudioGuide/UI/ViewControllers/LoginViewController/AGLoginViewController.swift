//
//  AGLoginViewController.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 03.02.2022.
//

import UIKit
import RxSwift
import RxCocoa
import FBSDKLoginKit
import GoogleSignIn

class AGLoginViewController: AGViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var panelView: UIView!
    @IBOutlet private weak var emailView: UIView!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet private weak var passwordView: UIView!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var goToRegButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet private weak var showButton: UIButton!
    @IBOutlet weak var fieldsConsraint: NSLayoutConstraint!
    @IBOutlet weak var ridEmailBtn: UIButton!
    let checkFields = CheckField.shared
    let apiCall = APIManager.shared
    let skipButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Skip", for: .normal)
        btn.tintColor = .white
        if let titleLabel = btn.titleLabel {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 16), // Жирний шрифт системи
            ]
            let attributedText = NSAttributedString(string: "Skip", attributes: attributes)
            titleLabel.attributedText = attributedText
        }
        return btn
    }()
    let facebookButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "facebookIconBtn"), for: .normal)
        button.titleLabel?.textColor = .blue
        button.backgroundColor = .clear
//        button.permissions = ["email", "public_profile"]
        button.addTarget(AGLoginViewController.self, action: #selector(loginButtonClicked), for: .touchUpInside)
        return button
    }()
    let googleButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "googleIconBtn"), for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.textColor = .yellow
        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        return button
    }()
    let ridResetViewButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.addTarget(AGLoginViewController.self, action: #selector(closeResetPasswordView), for: .touchUpInside)
        return button
    }()
    let enterMailView = EnterEmailForResetView()
    let enterCodeView = EnterCodeView()
    let newPassView = EnterNewPasswordView()
    let popUp404 = ServerErrorPopUpUIView()
    let confirmNewDeviceView = ConfirmNewDeviceUIView()
    let lostConnection = LostWifiConnectionUIView()
    let confirmAccountView = ConfirmAccountUIView()
    let successVerificationView = SuccessVerifationUIView()
    let successChangePassView = SuccessChangePassUIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSkipButton()
        setupFacebookAndGoogleBtn()
        setup()
        setUpResetViewElements()
    }
    @objc private func closeResetPasswordView(){
        guard let containerView = ridResetViewButton.superview,
              let view = containerView.superview else {
               return
           }
        if view == confirmAccountView{
            DispatchQueue.main.async {
                self.confirmAccountView.enterCodeView.layer.borderColor = UIColor.white.cgColor
                self.confirmAccountView.codeErrorLabel.isHidden = true
                self.confirmAccountView.codeTextField.text = ""
                self.confirmAccountView.confirmCodeButton.alpha = 0.5
                self.confirmAccountView.confirmCodeButton.isUserInteractionEnabled = false
                self.confirmAccountView.ridCodeButton.isHidden = true
                self.confirmAccountView.secondaryDescLabel.text = "Secondary code was sent to "
                self.confirmAccountView.ridCodeButton.setImage(UIImage(named: "ridIcon"), for: .normal)
                self.confirmAccountView.ridCodeButton.isUserInteractionEnabled = false
                self.confirmAccountView.codeErrorLabel.text = "Wrong code. Please try again."
                self.confirmAccountView.ridCodeButton.setImage(UIImage(named: "ridIcon"), for: .normal)
                self.confirmAccountView.ridCodeButton.tintColor = .white
            }
        }else if view == successVerificationView{
            UIView.animate(withDuration: 0.3, animations: {
                self.successVerificationView.alpha = 0.0
                    }) {[weak self] _ in
                        guard let strongSelf = self else {
                            return
                        }
                        // Приховання поп-апу після завершення анімації
                        self?.successVerificationView.removeFromSuperview()
                        self?.successVerificationView.alpha = 1
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7){
                            guard let appVC = strongSelf.storyboard?.instantiateViewController(withIdentifier: "AGMainTabBarController") else {
                                return
                            }
                            strongSelf.navigationController?.pushViewController(appVC, animated: true)
                        }
                    }
        }else{
            DispatchQueue.main.async {
                self.deInitMailAndCodeView()

                self.newPassView.resetPasswordMailView.layer.borderColor = UIColor.white.cgColor
                self.newPassView.confirmPasswordView.layer.borderColor = UIColor.white.cgColor
                self.newPassView.passErrorLabel.isHidden = true
                self.newPassView.newPassTextField.text = ""
                self.newPassView.confirmNewPassTextField.text = ""
                self.newPassView.confirmNewPassButton.alpha = 0.5
                self.newPassView.confirmNewPassButton.isUserInteractionEnabled = false
            }
        }
        
        

       
        UIView.animate(withDuration: 0.3, animations: {
            view.alpha = 0.0
                }) { _ in
                    // Приховання поп-апу після завершення анімації
                    view.removeFromSuperview()
                    view.alpha = 1
                }
       
    }
    private func deInitMailAndCodeView(){
        self.enterMailView.enterMailView.layer.borderColor = UIColor.white.cgColor
        self.enterMailView.mailErrorLabel.isHidden = true
        self.enterMailView.mailResetTextField.text = ""
        self.enterMailView.sendCodeButton.alpha = 0.5
        self.enterMailView.sendCodeButton.isUserInteractionEnabled = false

        self.enterCodeView.codeErrorLabel.isHidden = true
        self.enterCodeView.codeErrorLabel.text = "Wrong code. Please try again."
        self.enterCodeView.codeTextField.text = ""
        self.enterCodeView.ridCodeButton.isHidden = true
        self.enterCodeView.ridCodeButton.isUserInteractionEnabled = false
        self.enterCodeView.ridCodeButton.setImage(UIImage(named: "ridIcon"), for: .normal)
        self.enterCodeView.ridCodeButton.tintColor = .white
        self.enterCodeView.secondaryDescLabel.text = "Secondary code was sent to "
        self.enterCodeView.enterCodeView.layer.borderColor = UIColor.white.cgColor
        self.enterCodeView.confirmCodeButton.alpha = 0.5
        self.enterCodeView.confirmCodeButton.isUserInteractionEnabled = false

    }
    private func setUpResetViewElements(){
        enterMailView.sendCodeButton.addTarget(self, action: #selector(sendEmailCode), for: .touchUpInside)
        enterMailView.mailResetTextField.delegate = self
        enterMailView.signInButton.addTarget(self, action: #selector(goToSignUpPage), for: .touchUpInside)
        enterCodeView.confirmCodeButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        enterCodeView.codeTextField.delegate = self
        enterCodeView.changeMailButton.addTarget(self, action: #selector(changeMailAgain), for: .touchUpInside)
        newPassView.confirmNewPassButton.addTarget(self, action: #selector(createNewPasswordForUser), for: .touchUpInside)
        newPassView.newPassTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        newPassView.confirmNewPassTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
//        confirmAccountView.resendCodeBtn.addTarget(self, action: #selector(resendCode), for: .touchUpInside)
        confirmAccountView.confirmCodeButton.addTarget(self, action: #selector(sendCodeToApi), for: .touchUpInside)
        confirmAccountView.codeTextField.textColor = .white
        emailField.addTarget(self, action: #selector(validFiels), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(validFiels), for: .editingChanged)
        
        
    }
    @objc private func sendCodeToApi(){
        guard let text = confirmAccountView.codeTextField.text,
              let email = UserDefaults.standard.value(forKey: "email") as? String,
              let uuid = UserDefaults.standard.value(forKey: "id_device") as? String else{
            return
        }
        apiCall.verifyUser(idDevice: uuid, email: email, code: text) {[weak self] result in
            guard let strongSelf = self else{
                return
            }
            switch result{
            case .success(let result):
                print(result)
                UserDefaults.userEmail = email
                DispatchQueue.main.async {
                    strongSelf.confirmAccountView.enterCodeView.layer.borderColor = UIColor.white.cgColor
                    strongSelf.confirmAccountView.ridCodeButton.setImage(UIImage(named: "ridIcon"), for: .normal)
                    strongSelf.confirmAccountView.ridCodeButton.tintColor = .white
                    strongSelf.confirmAccountView.ridCodeButton.isHidden = true
                    strongSelf.confirmAccountView.ridCodeButton.isUserInteractionEnabled = true
                    strongSelf.confirmAccountView.codeErrorLabel.isHidden = true
                    ///перехід в додаток
                    strongSelf.addSuccessVerificationPopUp()                    
                }
            case .failure(let error) :
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    strongSelf.confirmAccountView.enterCodeView.layer.borderColor = UIColor.red.cgColor
                    strongSelf.confirmAccountView.ridCodeButton.setImage(UIImage(named: "alertImage"), for: .normal)
                    strongSelf.confirmAccountView.ridCodeButton.isHidden = false
                    strongSelf.confirmAccountView.ridCodeButton.tintColor = .red
                    strongSelf.confirmAccountView.ridCodeButton.isUserInteractionEnabled = false
                    strongSelf.confirmAccountView.codeErrorLabel.isHidden = false
                    if (error as NSError).code == 404{
                        strongSelf.confirmAccountView.codeErrorLabel.text = "No user with exact email."
                    }else if (error as NSError).code == 422{
                        strongSelf.confirmAccountView.codeErrorLabel.text = "Error invalid input data"
                    }else if (error as NSError).code == 400{
                        strongSelf.confirmAccountView.codeErrorLabel.text = "Wrong code. Please try again!"
                    }
                }
                

            }
        }
    }
    @objc private func addSuccessVerificationPopUp(){
        confirmAccountView.removeFromSuperview()
        mainView.addSubview(successVerificationView)
        ridResetViewButton.translatesAutoresizingMaskIntoConstraints = false
        successVerificationView.successView.addSubview(ridResetViewButton)
        NSLayoutConstraint.activate([
            ridResetViewButton.trailingAnchor.constraint(equalTo: successVerificationView.successView.trailingAnchor,constant: -16),
            ridResetViewButton.topAnchor.constraint(equalTo: successVerificationView.successView.topAnchor,constant: 16),
            ridResetViewButton.widthAnchor.constraint(equalToConstant: 24),
            ridResetViewButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        successVerificationView.logInBtn.addTarget(self, action: #selector(goToApp), for: .touchUpInside)
    }
    @objc private func goToApp(){
        UserDefaults.isUserAuthorizationPassed = true
        UserDefaults.isFirstLaunchPassed = true
        UIView.animate(withDuration: 0.3, animations: {
            self.successVerificationView.alpha = 0.0
        }) {[weak self] _ in
            guard let strongSelf = self else {
                return
            }
            // Приховання поп-апу після завершення анімації
            strongSelf.successVerificationView.removeFromSuperview()
            strongSelf.successVerificationView.alpha = 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7){
                guard let appVC = strongSelf.storyboard?.instantiateViewController(withIdentifier: "AGMainTabBarController") else {
                    return
                }
                strongSelf.navigationController?.pushViewController(appVC, animated: true)
            }
        }
    }
    @objc private func resendCode(){
        //Api func resendCode to email
        guard let email = UserDefaults.standard.value(forKey: "email") as? String,
        let uuid = UserDefaults.standard.value(forKey: "id_device") as? String else{
            return
        }
        apiCall.resendVerificationCode(idDevice: uuid,email: email) {[weak self] result in
            guard let strongSelf = self else{
                return
            }
            switch result{
            case .success(let str):
                print(str)
                DispatchQueue.main.async {
                    strongSelf.confirmAccountView.codeTextField.text = ""
                    strongSelf.confirmAccountView.enterCodeView.layer.borderColor = UIColor.white.cgColor
                    strongSelf.confirmAccountView.ridCodeButton.isHidden = true
                    strongSelf.confirmAccountView.codeErrorLabel.isHidden = true
                }
            case .failure(let error):
                print("Error Resend : \(error.localizedDescription)")
                DispatchQueue.main.async {
                    strongSelf.confirmAccountView.enterCodeView.layer.borderColor = UIColor.red.cgColor
                    if (error as NSError).code == 422{
                        strongSelf.confirmAccountView.codeErrorLabel.text = "Error, invalid input data."
                    }else if (error as NSError).code == 404{
                        strongSelf.confirmAccountView.codeErrorLabel.text = "Have not found user with this email."
                    }else if (error as NSError).code == 409{
                        strongSelf.confirmAccountView.codeErrorLabel.text = "Had verified before this user."
                    }else if (error as NSError).code == 500{
                        ///404popup
                        strongSelf.add404PopUp()
                        
                    }
                }
            }
        }
        
    }
    @objc private func signIn(){
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else {
                print("Error in google log/sign")
                return
                
            }
            // If sign in succeeded, display the app's main content View.
            print("Successfully login with Google Button")
            guard let signInResult = signInResult else {
                print("Failed to log in Successfully")
                return
            }
            guard let idDevice = UserDefaults.standard.value(forKey: "id_device") as? String else{
                return
            }
            print("Login")
            let authCode = signInResult.serverAuthCode
            let userEmail = signInResult.user.profile?.email
            print("Google authCode : \(String(describing: authCode))")
            print("IdDevice : \(idDevice)")
            self.apiCall.loginWithSocialMedia(idDevice: idDevice, accessToken: nil, authCode: authCode, type: "google", email: userEmail, password: nil, remember: "1", subscription: nil) { result in
                switch result {
                case .success(_):
                    UserDefaults.isUserAuthorizationPassed = true
                    UserDefaults.isFirstLaunchPassed = true
                    UserDefaults.userEmail = userEmail
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        guard let mainAppVc = self.storyboard?.instantiateViewController(withIdentifier: "AGMainTabBarController") as? AGMainTabBarController else{
                            return
                        }
                        self.navigationController?.pushViewController(mainAppVc, animated: true)
                    }
                    //треба міняти глобальне значення для зміни rootviewController -а на app
                    print("Success logined user with socials")
                case .failure(let error as NSError):
                    DispatchQueue.main.async {
                        if error.code == 422{
                            self.emailErrorLabel.text = "Invalid input google data"
                        }else if error.code == 406{
                            self.emailErrorLabel.text = "Failed to fetch data from social media"
                        }else if error.code == 404{
                            self.emailErrorLabel.text = "Failed to fetch data from social media"
                        }else if error.code == 400{
                            self.mainView.addSubview(self.confirmAccountView)
                        }else if error.code == 401{
                            self.passwordErrorLabel.text = "Invalid password from google authentication"
                        }else if error.code == 403{
                            self.emailErrorLabel.text = "Invalid id device"
                        }else if error.code == 451{
                            ///якщо id_device не співпадає з старим записаним
                            print("Your old id device not similar with your new id device")
                            guard let oldDevice = (error as NSError).userInfo["old_id_device"] as? String,
                                  let newIdDevice = UserDefaults.standard.value(forKey: "id_device") as? String else{
                                      return
                                  }
                            self.apiCall.reInitDevice(idDevice: newIdDevice, oldIdDevice: oldDevice) { result in
                                switch result{
                                case .success(let str):
                                    print(str)
                                    UserDefaults.standard.setValue(oldDevice, forKey: "old_id_device")
                                    self.addConfirmNewDeviceView()
                                case .failure(let error):
                                    if (error as NSError).code == 422{
                                        print("reInitDevice 422 error")
                                    }else if (error as NSError).code == 404{
                                        print("reInitDevice 404 error")
                                    }else{
                                        ///серверна
                                        self.add404PopUp()

                                    }
                                }
                            }
                        }
                        print("Error to login user with google : \(error)")
                    }
                }
            }
        }
    }
   
    //MARK: Email і Password Валідація
    @objc private func validFiels(){
        guard let emailText = emailField.text,
              let passText = passwordField.text else{
            return
        }
        if checkFields.validField(emailView, emailField){
            emailView.layer.borderColor = UIColor.white.cgColor
        }else{
            if emailText.isEmpty{
                ridEmailBtn.isHidden = true
                emailView.layer.borderColor = UIColor.white.cgColor
            }else{
                ridEmailBtn.isHidden = false
                emailView.layer.borderColor = UIColor.red.cgColor
            }
        }
        if checkFields.validField(passwordView, passwordField){
            passwordView.layer.borderColor = UIColor.white.cgColor
        }else{
            if passText.isEmpty{
                showButton.isHidden = true
                passwordView.layer.borderColor = UIColor.white.cgColor
            }else{
                showButton.isHidden = false
                passwordView.layer.borderColor = UIColor.red.cgColor
            }
        }
        if checkFields.validField(emailView, emailField) && checkFields.validField(passwordView, passwordField){
            self.loginButton.isUserInteractionEnabled = true
            self.loginButton.alpha = 1
        }else{
            self.loginButton.isUserInteractionEnabled = false
            self.loginButton.alpha = 0.5
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y + view.safeAreaTopHeight / 2, width: view.frame.size.width, height: view.frame.size.height)
        self.mainView.frame = self.hasSafeArea ? self.scrollView.frame : CGRect(x: self.scrollView.frame.origin.x, y: self.scrollView.frame.origin.y, width: self.scrollView.frame.width, height:  self.view.contentHeight)
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.view.contentHeight)
        self.panelView.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: gCorrnerRadius)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.frame = CGRect(x: 311, y: 24, width: 64, height: 39)
        googleButton.frame = CGRect(x: 0, y: 0, width: 167.5, height: 40)
        facebookButton.frame = CGRect(x: 0, y: 0, width: 166, height: 40)
        enterMailView.frame = self.mainView.bounds
        enterCodeView.frame = self.mainView.bounds
        newPassView.frame = self.mainView.bounds
        confirmAccountView.frame = mainView.bounds
        popUp404.frame = self.mainView.bounds
        confirmNewDeviceView.frame = self.mainView.bounds
        lostConnection.frame = self.mainView.bounds
        successChangePassView.frame = self.mainView.bounds
        successVerificationView.frame = self.mainView.bounds
    }
    private func addSkipButton(){
        mainView.addSubview(skipButton)
        skipButton.addTarget(self, action: #selector(skipRegTap), for: .touchUpInside)
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: self.mainView.safeAreaLayoutGuide.topAnchor, constant: 24),
            skipButton.trailingAnchor.constraint(equalTo: self.mainView.trailingAnchor, constant: -16),
            skipButton.widthAnchor.constraint(equalToConstant: 54),
            skipButton.heightAnchor.constraint(equalToConstant: 39)
        ])
    }
    @objc private func skipRegTap(){
        isInternetConnected { flags in
            // Перевірка наявності з'єднання
            if self.handleNetworkChange(flags: flags) {
                self.showNoWifi4PopUp()
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    guard let mainAppVc = self.storyboard?.instantiateViewController(withIdentifier: "AGMainTabBarController") as? AGMainTabBarController else{
                        return
                    }
                    self.navigationController?.pushViewController(mainAppVc, animated: true)
                }
                UserDefaults.isFreeVersion = true
                UserDefaults.isFirstLaunchPassed = true
            }
        }
    }
    private func setupFacebookAndGoogleBtn(){
        loginButton.isUserInteractionEnabled = false
        loginButton.alpha = 0.5
        loginButton.layer.cornerRadius = 10
        emailField.textColor = .white
        passwordField.textColor = .white
        self.googleButton.layer.cornerRadius = self.gCorrnerRadius
        self.googleButton.layer.borderColor = UIColor(hexString: "#F8F8F8").withAlphaComponent(0.82).cgColor
        self.googleButton.layer.borderWidth = 1
        self.googleButton.clipsToBounds = true
        self.facebookButton.layer.cornerRadius = self.gCorrnerRadius
        self.facebookButton.layer.borderColor = UIColor(hexString: "#F8F8F8").withAlphaComponent(0.82).cgColor
        self.facebookButton.layer.borderWidth = 1
        self.facebookButton.clipsToBounds = true
        panelView.addSubview(googleButton)
        panelView.addSubview(facebookButton)
        
        NSLayoutConstraint.activate([
            googleButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 15),
            googleButton.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 15.75),
            googleButton.widthAnchor.constraint(equalToConstant: 167.5),
            googleButton.heightAnchor.constraint(equalToConstant: 40),
            
            facebookButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 15),
            facebookButton.trailingAnchor.constraint(equalTo: panelView.trailingAnchor, constant: -15.75),
            facebookButton.widthAnchor.constraint(equalToConstant: 166),
            facebookButton.heightAnchor.constraint(equalToConstant: 40)
            
        ])
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }

    //MARK: Логінація
    @objc private func loginButtonTapped(){
        ///Спочатку робим запит на API , якщо в нас не сходиться або email або password то виводим відповідні помилки , якшо все добре то логаєм користувача
        isInternetConnected { flags in
            // Перевірка наявності з'єднання
            if self.handleNetworkChange(flags: flags) {
                self.showNoWifi4PopUp()
            } else {
                let constsMargin = CGFloat(16.0)
                guard let emailText = self.emailField.text,
                      let passwordText = self.passwordField.text,
                      let uuid = UserDefaults.standard.value(forKey: "id_device") as? String else{
                          print("Rolled out")
                          return
                      }
                print("Email : \(emailText), Pass : \(passwordText), ID_DEVICE : \(uuid)")
                
                self.apiCall.loginUser(idDevice : uuid, email: emailText, password: passwordText, remember: "1") {[weak self] result in
                    guard let strongSelf = self else{
                        return
                    }
                    switch result{
                    case .success(let str):
                        print("Str : \(str)")
                        UserDefaults.isUserAuthorizationPassed = true
                        UserDefaults.isFirstLaunchPassed = true
                        UserDefaults.userEmail = emailText
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            strongSelf.fieldsConsraint.constant = constsMargin
                            strongSelf.emailView.layer.borderColor = UIColor.white.cgColor
                            strongSelf.emailErrorLabel.isHidden = true
                            strongSelf.passwordView.layer.borderColor = UIColor.white.cgColor
                            strongSelf.passwordErrorLabel.isHidden = true
                            print("Successfully loged in")
                            ///перехід в сам додаток
                            guard let mainAppVc = strongSelf.storyboard?.instantiateViewController(withIdentifier: "AGMainTabBarController") as? AGMainTabBarController else{
                                return
                            }
                            strongSelf.navigationController?.pushViewController(mainAppVc, animated: true)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                        if (error as NSError).code == 404{
                            ///email invalid
                            DispatchQueue.main.async {
                                strongSelf.emailView.layer.borderColor = UIColor.red.cgColor
                                strongSelf.emailErrorLabel.isHidden = false
                                strongSelf.emailErrorLabel.text = "We cannot find this email"
                                strongSelf.emailErrorLabel.textColor = .white
                                strongSelf.fieldsConsraint.constant += strongSelf.emailErrorLabel.frame.height
                                strongSelf.passwordView.layer.borderColor = UIColor.white.cgColor
                                strongSelf.passwordErrorLabel.isHidden = true
                                print("Email Invalid Try Another")
                            }
                            
                        }else if (error as NSError).code == 401{
                            ///password invalid
                            DispatchQueue.main.async {
                                strongSelf.passwordView.layer.borderColor = UIColor.red.cgColor
                                strongSelf.passwordErrorLabel.isHidden = false
                                strongSelf.emailView.layer.borderColor = UIColor.white.cgColor
                                strongSelf.emailErrorLabel.isHidden = true
                                print("Password Invalid Try Another")
                            }
                        }else if (error as NSError).code == 400{
                            ///якщо буде помилка 400 то потрібно це обробити і тоді виводити поп-ап з підтвердженням коду
                            DispatchQueue.main.async {
                                strongSelf.mainView.addSubview(strongSelf.confirmAccountView)
                            }
                            
                        }else if (error as NSError).code == 403{
                            ///це якщо id_device  пустий або не валідний взагалі
                            DispatchQueue.main.async {
                                strongSelf.emailView.layer.borderColor = UIColor.white.cgColor
                                strongSelf.emailErrorLabel.isHidden = false
                                strongSelf.emailErrorLabel.text = "Oops. Something going wrong with your id device"
                                strongSelf.emailErrorLabel.textColor = .red
                                strongSelf.fieldsConsraint.constant += strongSelf.emailErrorLabel.frame.height
                                strongSelf.passwordView.layer.borderColor = UIColor.white.cgColor
                                strongSelf.passwordErrorLabel.isHidden = true
                                print("Invalid id_device")
                            }
                        }else if (error as NSError).code == 422{
                            ///invalid input
                            DispatchQueue.main.async {
                                strongSelf.emailView.layer.borderColor = UIColor.red.cgColor
                                strongSelf.emailErrorLabel.isHidden = false
                                strongSelf.emailErrorLabel.text = "Enter your email clearly"
                                strongSelf.emailErrorLabel.textColor = .white
                                strongSelf.fieldsConsraint.constant += strongSelf.emailErrorLabel.frame.height
                                strongSelf.passwordView.layer.borderColor = UIColor.white.cgColor
                                strongSelf.passwordErrorLabel.isHidden = true
                                print("Invalid email")
                            }
                        }
                        else if (error as NSError).code == 451{
                            ///якщо id_device не співпадає з старим записаним
                            print("Your old id device not similar with your new id device")
                            guard let oldDevice = (error as NSError).userInfo["old_id_device"] as? String,
                                  let newIdDevice = UserDefaults.standard.value(forKey: "id_device") as? String else{
                                      return
                                  }
                            strongSelf.apiCall.reInitDevice(idDevice: newIdDevice, oldIdDevice: oldDevice) { result in
                                switch result{
                                case .success(let str):
                                    print(str)
                                    UserDefaults.standard.setValue(oldDevice, forKey: "old_id_device")
                                    strongSelf.addConfirmNewDeviceView()
                                case .failure(let error):
                                    if (error as NSError).code == 422{
                                        print("reInitDevice 422 error")
                                    }else if (error as NSError).code == 404{
                                        print("reInitDevice 404 error")
                                    }else{
                                        ///серверна
                                        strongSelf.add404PopUp()
                                    }
                                }
                            }
                        }else if (error as NSError).code == 500{
                            ///серверна помилка
                            strongSelf.add404PopUp()
                        }
                    }
                }
            }
        }
    }
    private func add404PopUp(){
        DispatchQueue.main.async {
            self.mainView.addSubview(self.popUp404)
            self.popUp404.alpha = 0.0
            // Анімація відображення затемнення і поп-апу
            UIView.animate(withDuration: 0.3) {
                self.popUp404.alpha = 1.0
            }
        }
    }
    private func addConfirmNewDeviceView(){
        DispatchQueue.main.async {
            self.mainView.addSubview(self.confirmNewDeviceView)
            self.confirmNewDeviceView.textField.textColor = .black
            self.confirmNewDeviceView.alpha = 0.0
            // Анімація відображення затемнення і поп-апу
            UIView.animate(withDuration: 0.3) {
                self.confirmNewDeviceView.alpha = 1.0
            }
        }
    }
    private func addLostConnectionWifiPopUp(){
        self.mainView.addSubview(lostConnection)
        lostConnection.alpha = 0.0
        // Анімація відображення затемнення і поп-апу
        UIView.animate(withDuration: 0.3) {
            self.lostConnection.alpha = 1.0
        }
    }
    @available(iOSApplicationExtension, unavailable)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @available(iOSApplicationExtension, unavailable)
    private func setup() {
        self.scrollView.addSubview(self.mainView)
        self.scrollView.contentOffset = .zero;
        self.scrollView.contentInset = UIEdgeInsets.zero
        self.goToRegButton.layer.cornerRadius = self.gCorrnerRadius
        self.goToRegButton.layer.borderColor = UIColor(named: "AccentColor")!.cgColor
        self.goToRegButton.layer.borderWidth = 1
        self.goToRegButton.clipsToBounds = true
        self.emailView.layer.cornerRadius = self.gCorrnerRadius
        self.emailView.layer.borderColor = UIColor(hexString: "#CDCDCD").cgColor
        self.emailView.layer.borderWidth = 1.5
        self.emailView.clipsToBounds = true
        ridEmailBtn.addTarget(self, action: #selector(diTapRidEmail), for: .touchUpInside)
        self.passwordView.layer.cornerRadius = self.gCorrnerRadius
        self.passwordView.layer.borderColor = UIColor(hexString: "#CDCDCD").cgColor
        self.passwordView.layer.borderWidth = 1.5
        self.passwordView.clipsToBounds = true
        self.showButton.isHidden = true
        self.emailField.attributedPlaceholder = NSAttributedString(string: "Email...", attributes: [NSAttributedString.Key.foregroundColor:  UIColor.white, NSAttributedString.Key.font: UIFont.PoppinsFont(ofSize: 16)])
        self.passwordField.attributedPlaceholder = NSAttributedString(string: "Password...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.PoppinsFont(ofSize: 16)])
        emailField.delegate = self
        passwordField.delegate = self
    }
    @available(iOSApplicationExtension, unavailable)
    override func setBottomOffset(keyboardInfo: UIKeyboardInfo) {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseInOut) {
            if keyboardInfo.frame.height > 0 {
                let contentInsetBottom = max(keyboardInfo.frame.height, self.view.safeAreaBottomHeight)
                self.scrollView.contentInset.bottom = contentInsetBottom
                self.scrollView.horizontalScrollIndicatorInsets.bottom = contentInsetBottom
            } else {
                self.scrollView.contentInset.bottom = 0
                self.scrollView.horizontalScrollIndicatorInsets.bottom = 0
            }
        } completion: { _ in
            if keyboardInfo.frame.height > 0 {
                // Additional adjustments or actions after the keyboard appears
                let offset = CGPoint(x: 0, y: self.scrollView.contentSize.height / 12)
                self.scrollView.setContentOffset(offset, animated: true)
            } else {
                // Additional adjustments or actions after the keyboard disappears
//                self.scrollView.setContentOffset(CGPoint.zero, animated: true)
            }
        }
    }


    
    @IBAction private func showPassword() {
        self.showButton.isSelected = !self.showButton.isSelected
        self.passwordField.isSecureTextEntry = !self.showButton.isSelected
        if showButton.isSelected{
            showButton.setImage(UIImage(named: "viewNonActive"), for: .selected)
        }else{
            showButton.setImage(UIImage(named: "viewActive"), for: .normal)
        }
        
    }
    
    @objc private func diTapRidEmail(){
        emailField.text?.removeAll()
        ridEmailBtn.isHidden = true
        emailView.layer.borderColor = UIColor.white.cgColor
    }
    @objc private func loginButtonClicked(){
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["email", "public_profile"], from: self) { result, error in
            guard let token = result?.token?.tokenString else {
                print("User failed to log in with facebook")
                return
            }
            let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email, name"], tokenString: token, version: nil, httpMethod: .get)
            print("Facebook token : \(token)")
            guard let idDevice = UserDefaults.standard.value(forKey: "id_device") as? String else{
                return
            }
            request.start { _, results, error in
                guard let result = results as? [String: Any], error == nil else{
                    print("Fail to cast dictionary")
                    return
                }
                guard let userEmail = result["email"] as? String else{
                    return
                }
                self.apiCall.loginWithSocialMedia(idDevice: idDevice, accessToken: token, authCode: nil, type: "facebook", email: userEmail, password: nil, remember: "1", subscription: nil) { result in
                    switch result {
                    case .success(_):
                        UserDefaults.isUserAuthorizationPassed = true
                        UserDefaults.isFirstLaunchPassed = true
                        UserDefaults.userEmail = userEmail
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            guard let mainAppVc = self.storyboard?.instantiateViewController(withIdentifier: "AGMainTabBarController") as? AGMainTabBarController else{
                                return
                            }
                            self.navigationController?.pushViewController(mainAppVc, animated: true)
                        }
                        //треба міняти глобальне значення для зміни rootviewController -а на app
                        print("Success logined user with socials")
                    case .failure(let error as NSError):
                        DispatchQueue.main.async {
                            if error.code == 422{
                                self.emailErrorLabel.text = "Invalid input google data"
                            }else if error.code == 406{
                                self.emailErrorLabel.text = "Failed to fetch data from social media"
                            }else if error.code == 404{
                                self.emailErrorLabel.text = "Failed to fetch data from social media"
                            }else if error.code == 400{
                                self.mainView.addSubview(self.confirmAccountView)
                            }else if error.code == 401{
                                self.passwordErrorLabel.text = "Invalid password from google authentication"
                            }else if error.code == 403{
                                self.emailErrorLabel.text = "Invalid id device"
                            }else if error.code == 451{
                                ///якщо id_device не співпадає з старим записаним
                                print("Your old id device not similar with your new id device")
                                guard let oldDevice = (error as NSError).userInfo["old_id_device"] as? String,
                                      let newIdDevice = UserDefaults.standard.value(forKey: "id_device") as? String else{
                                          return
                                      }
                                self.apiCall.reInitDevice(idDevice: newIdDevice, oldIdDevice: oldDevice) { result in
                                    switch result{
                                    case .success(let str):
                                        print(str)
                                        UserDefaults.standard.setValue(oldDevice, forKey: "old_id_device")
                                        self.addConfirmNewDeviceView()
                                    case .failure(let error):
                                        if (error as NSError).code == 422{
                                            print("reInitDevice 422 error")
                                        }else if (error as NSError).code == 404{
                                            print("reInitDevice 404 error")
                                        }else{
                                            ///серверна
                                            self.add404PopUp()
                                            
                                        }
                                    }
                                }
                            }
                            print("Error to login user with google : \(error)")
                        }
                    }
                }
            }
        }
    }
//    @IBAction private func login() {
//        self.performSegue(withIdentifier: "showTabBarSeque", sender: self)
//    }
    @objc private func changeMailAgain(){
        DispatchQueue.main.async {
            self.enterCodeView.enterCodeView.layer.borderColor = UIColor.white.cgColor
            self.enterCodeView.codeErrorLabel.isHidden = true
            self.enterCodeView.codeTextField.text = ""
            self.enterCodeView.secondaryDescLabel.text = "Secondary code was sent to "
            self.enterCodeView.removeFromSuperview()
            self.enterMailView.mailResetTextField.text = ""
            self.mainView.addSubview(self.enterMailView)
            self.ridResetViewButton.frame = CGRect(x: 303, y: 16.5, width: 24, height: 24)
            self.enterMailView.enterView.addSubview(self.ridResetViewButton)
            NSLayoutConstraint.activate([
                self.ridResetViewButton.trailingAnchor.constraint(equalTo: self.enterMailView.enterView.trailingAnchor, constant: -16),
                self.ridResetViewButton.topAnchor.constraint(equalTo: self.enterMailView.enterView.topAnchor, constant: 16),
                self.ridResetViewButton.heightAnchor.constraint(equalToConstant: 24),
                self.ridResetViewButton.widthAnchor.constraint(equalToConstant: 24)
            ])
        }
    }
    @objc private func goToSignUpPage(){
        DispatchQueue.main.async {
            self.deInitMailAndCodeView()
        }
        if let controller = self.navigationController?.viewControllers.filter({$0.isMember(of: AGRegistrationViewController.self)}).first {
            
            self.navigationController?.popToViewController(controller, animated: true)
            
        } else {
            
            self.performSegue(withIdentifier: "showRegistrationSeque", sender: self)
            closeResetPasswordView()
        }
    }
    
    @IBAction private func goToRegistaration() {
        if let controller = self.navigationController?.viewControllers.filter({$0.isMember(of: AGRegistrationViewController.self)}).first {
            self.navigationController?.popToViewController(controller, animated: true)
        } else {
            self.performSegue(withIdentifier: "showRegistrationSeque", sender: self)
        }
    }
    
    @IBAction func didTapForgotButton(_ sender: Any) {
        self.mainView.addSubview(enterMailView)
        enterMailView.mailResetTextField.textColor = .white
        ridResetViewButton.translatesAutoresizingMaskIntoConstraints = false
        enterMailView.enterView.addSubview(ridResetViewButton)
        NSLayoutConstraint.activate([
            ridResetViewButton.trailingAnchor.constraint(equalTo: enterMailView.enterView.trailingAnchor, constant: -16),
            ridResetViewButton.topAnchor.constraint(equalTo: enterMailView.enterView.topAnchor, constant: 16),
            ridResetViewButton.heightAnchor.constraint(equalToConstant: 24),
            ridResetViewButton.widthAnchor.constraint(equalToConstant: 24)

        ])
        enterMailView.alpha = 0.0
        // Анімація відображення затемнення і поп-апу
        UIView.animate(withDuration: 0.3) {
            self.enterMailView.alpha = 1.0
        }
    }

    @objc private func createNewPasswordForUser(){
        guard let uuid = UserDefaults.standard.value(forKey: "id_device") as? String,
              let email = enterMailView.mailResetTextField.text,
              let newpass = newPassView.newPassTextField.text,
              let confpass = newPassView.confirmNewPassTextField.text,
              let code = enterCodeView.codeTextField.text else{
                  return
              }
        if newpass == confpass{
            apiCall.passwordChange(idDevice: uuid, email: email, password: newpass, code: code) {[weak self] result in
                guard let strongSelf = self else{
                    return
                }
                switch result {
                case .success(_):
                    print("Success")
                    DispatchQueue.main.async {
                        strongSelf.newPassView.removeFromSuperview()
                        strongSelf.newPassView.confirmPasswordView.layer.borderColor = UIColor.white.cgColor
                        strongSelf.newPassView.resetPasswordMailView.layer.borderColor = UIColor.white.cgColor
                        strongSelf.newPassView.passErrorLabel.isHidden = true
                        strongSelf.newPassView.newPassTextField.text?.removeAll()
                        strongSelf.newPassView.confirmNewPassTextField.text?.removeAll()
                        strongSelf.enterCodeView.codeTextField.text?.removeAll()
                        strongSelf.enterMailView.mailResetTextField.text?.removeAll()
                        strongSelf.newPassView.passErrorLabel.text = "Different passwords.Please, check it."
                        strongSelf.addSuccesPopUp()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    if (error as NSError).code == 422{
                        ///newPass invalid
                        DispatchQueue.main.async {
                            strongSelf.newPassView.resetPasswordMailView.layer.borderColor = UIColor.red.cgColor
                            strongSelf.newPassView.confirmPasswordView.layer.borderColor = UIColor.red.cgColor
                            strongSelf.newPassView.passErrorLabel.isHidden = false
                        }
                        
                    }else if (error as NSError).code == 404{
                        ///email invalid
                        DispatchQueue.main.async {
                            strongSelf.newPassView.resetPasswordMailView.layer.borderColor = UIColor.white.cgColor
                            strongSelf.newPassView.confirmPasswordView.layer.borderColor = UIColor.white.cgColor
                            strongSelf.newPassView.passErrorLabel.isHidden = false
                            strongSelf.newPassView.passErrorLabel.text = "We cannot find email that u enter before"
                            print("Password Invalid Try Another")
                        }
                    }
                    else if (error as NSError).code == 401{
                        ///code invalid
                        DispatchQueue.main.async {
                            strongSelf.newPassView.resetPasswordMailView.layer.borderColor = UIColor.white.cgColor
                            strongSelf.newPassView.confirmPasswordView.layer.borderColor = UIColor.white.cgColor
                            strongSelf.newPassView.passErrorLabel.isHidden = false
                            strongSelf.newPassView.passErrorLabel.text = "Confirm code that you enter is invalid. Close this window and try again"
                            strongSelf.newPassView.passErrorLabel.tintColor = .red
                            print("Password Invalid Try Another")
                        }
                    }else if (error as NSError).code == 500{
                        //404popup
                        strongSelf.add404PopUp()
                    }
                }
            }
        }else{
            newPassView.resetPasswordMailView.layer.borderColor = UIColor.red.cgColor
            newPassView.confirmPasswordView.layer.borderColor = UIColor.red.cgColor
            newPassView.passErrorLabel.isHidden = false
        }
        
    }
    private func addSuccesPopUp(){
        DispatchQueue.main.async {
            self.mainView.addSubview(self.successChangePassView)
            self.successChangePassView.successView.addSubview(self.ridResetViewButton)
            self.ridResetViewButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.ridResetViewButton.trailingAnchor.constraint(equalTo: self.successChangePassView.successView.trailingAnchor, constant: -16),
                self.ridResetViewButton.topAnchor.constraint(equalTo: self.successChangePassView.successView.topAnchor, constant: 16),
                self.ridResetViewButton.heightAnchor.constraint(equalToConstant: 24),
                self.ridResetViewButton.widthAnchor.constraint(equalToConstant: 24)
            ])
        }
        
    }
    @objc private func didTapConfirmButton(){
        guard let code = enterCodeView.codeTextField.text,
              let idDevice = UserDefaults.standard.value(forKey: "id_device") as? String,
              let userEmail = UserDefaults.standard.value(forKey: "email") as? String else{
            return
        }
        print("UserEmail : \(userEmail), IdDevice : \(idDevice), Code : \(code)")
        apiCall.verifyCode(idDevice: idDevice, email: userEmail, code: code) { result in
            switch result{
            case .success(_):
                DispatchQueue.main.async {
                    self.enterCodeView.enterCodeView.layer.borderColor = UIColor.white.cgColor
                    self.enterCodeView.ridCodeButton.setImage(UIImage(named: "xmark"), for: .normal)
                    self.enterCodeView.ridCodeButton.tintColor = .white
                    self.enterCodeView.ridCodeButton.isHidden = true
                    self.enterCodeView.ridCodeButton.isUserInteractionEnabled = true
                    self.enterCodeView.codeErrorLabel.isHidden = true
                    self.enterCodeView.secondaryDescLabel.text = "Secondary code was sent to "
                    self.enterCodeView.codeErrorLabel.text = "Wrong code. Try again!"
                    self.enterCodeView.removeFromSuperview()
                    self.mainView.addSubview(self.newPassView)
                    self.newPassView.newPassTextField.textColor = .white
                    self.newPassView.confirmNewPassTextField.textColor = .white
                    self.ridResetViewButton.frame = CGRect(x: 303, y: 16.5, width: 24, height: 24)
                    self.newPassView.passEnterView.addSubview(self.ridResetViewButton)
                    NSLayoutConstraint.activate([
                        self.ridResetViewButton.trailingAnchor.constraint(equalTo: self.newPassView.passEnterView.trailingAnchor, constant: -16),
                        self.ridResetViewButton.topAnchor.constraint(equalTo: self.newPassView.passEnterView.topAnchor, constant: 16),
                        self.ridResetViewButton.heightAnchor.constraint(equalToConstant: 24),
                        self.ridResetViewButton.widthAnchor.constraint(equalToConstant: 24)

                    ])
                }
            case .failure(let error):
                print("Code Error: \(error.localizedDescription)")
                DispatchQueue.main.async{
                    self.enterCodeView.enterCodeView.layer.borderColor = UIColor.red.cgColor
                    self.enterCodeView.ridCodeButton.setImage(UIImage(named: "alertImage"), for: .normal)
                    self.enterCodeView.ridCodeButton.isHidden = false
                    self.enterCodeView.ridCodeButton.tintColor = .red
                    self.enterCodeView.ridCodeButton.isUserInteractionEnabled = false
                    self.enterCodeView.codeErrorLabel.isHidden = false
                    if (error as NSError).code == 422{
                        self.enterCodeView.codeErrorLabel.text = "Input data error"
                    }else if (error as NSError).code == 404{
                        self.enterCodeView.codeErrorLabel.text = "Cannot find this user."
                    }
                    else if (error as NSError).code == 404{
                        self.enterCodeView.codeErrorLabel.text = "Wrong code. Try again!"
                    }else if (error as NSError).code == 500{
                        self.add404PopUp()
                    }
                }
                
            }
        }
    }
    
    @objc private func textFieldDidChange(){
        // Перевірка, чи обидва поля мають однаковий текст
        guard let newPassword = newPassView.newPassTextField.text,
              let confirmPassword = newPassView.confirmNewPassTextField.text else{
                  return
              }
        
        self.newPassView.seeNewPassTextButton.isHidden = newPassword.isEmpty
        self.newPassView.seeConfirmPassTextButton.isHidden = confirmPassword.isEmpty
        if newPassword.count == confirmPassword.count && newPassword.count > 5 && confirmPassword.count > 5{
            // Якщо паролі співпадають, робимо кнопку доступною для натискання
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.newPassView.confirmNewPassButton.isUserInteractionEnabled = true
                self.newPassView.confirmNewPassButton.alpha = 1
                self.newPassView.resetPasswordMailView.layer.borderColor = UIColor.white.cgColor
                self.newPassView.confirmPasswordView.layer.borderColor = UIColor.white.cgColor
                self.newPassView.passErrorLabel.isHidden = true
            }
        } else {
            // Якщо паролі не співпадають, робимо кнопку недоступною
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.newPassView.confirmNewPassButton.isUserInteractionEnabled = false
            self.newPassView.confirmNewPassButton.alpha = 0.5
            self.newPassView.resetPasswordMailView.layer.borderColor = UIColor.red.cgColor
            self.newPassView.confirmPasswordView.layer.borderColor = UIColor.red.cgColor
            self.newPassView.passErrorLabel.isHidden = false
            }
        }
    }
    @objc private func sendEmailCode(){
        ///Request from API to equal enter code and sended on email
        isInternetConnected { flags in
            // Перевірка наявності з'єднання
            if self.handleNetworkChange(flags: flags) {
                self.showNoWifi4PopUp()
            } else {
                guard let userEmail = self.enterMailView.mailResetTextField.text,
                      let uuid = UserDefaults.standard.value(forKey: "id_device") as? String,
                      let labelText = self.enterCodeView.secondaryDescLabel.text else{
                          print("Didn`t get smth")
                          return
                      }
                self.apiCall.passwordRemind(idDevice: uuid, email: userEmail) {[weak self] result in
                    guard let strongSelf = self else{
                        return
                    }
                    switch result{
                    case .success(_):
                        DispatchQueue.main.async {
                            UserDefaults.standard.set(userEmail, forKey: "email")
                            strongSelf.enterMailView.removeFromSuperview()
                            strongSelf.mainView.addSubview(strongSelf.enterCodeView)
                            let boldTextAttributes: [NSAttributedString.Key: Any] = [
                                .font: UIFont.boldSystemFont(ofSize: 12),
                            ]
                            let attributedEmail = NSAttributedString(string: userEmail, attributes: boldTextAttributes)
                            let attributedString = NSMutableAttributedString(string: labelText)
                            attributedString.append(attributedEmail)
                            strongSelf.enterCodeView.secondaryDescLabel.attributedText = attributedString
                            strongSelf.enterCodeView.codeTextField.textColor = .white
                            strongSelf.ridResetViewButton.frame = CGRect(x: 303, y: 16.5, width: 24, height: 24)
                            strongSelf.enterCodeView.codeEnterView.addSubview(strongSelf.ridResetViewButton)
                            NSLayoutConstraint.activate([
                                strongSelf.ridResetViewButton.trailingAnchor.constraint(equalTo: strongSelf.enterCodeView.codeEnterView.trailingAnchor, constant: -16),
                                strongSelf.ridResetViewButton.topAnchor.constraint(equalTo: strongSelf.enterCodeView.codeEnterView.topAnchor, constant: 16),
                                strongSelf.ridResetViewButton.heightAnchor.constraint(equalToConstant: 24),
                                strongSelf.ridResetViewButton.widthAnchor.constraint(equalToConstant: 24)
                                
                            ])
                        }
                    case .failure(_):
                        DispatchQueue.main.async {
                            strongSelf.enterMailView.enterMailView.layer.borderColor = UIColor.red.cgColor
                            strongSelf.enterMailView.mailErrorLabel.isHidden = false
                            strongSelf.enterMailView.ridEmailTextButton.isHidden = false
                            strongSelf.enterMailView.ridEmailTextButton.isUserInteractionEnabled = false
                            strongSelf.enterMailView.ridEmailTextButton.tintColor = .red
                            strongSelf.enterMailView.ridEmailTextButton.setImage(UIImage(named: "alertImage"), for: .normal)
                        }
                    }
                }
            }
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.emailField{
            guard let text = textField.text else{
               return
            }
            self.ridEmailBtn.isHidden = text.isEmpty
        }
         else if textField == self.passwordField{
            guard let text = textField.text else{
               return
            }
            self.showButton.isHidden = text.isEmpty
           
        }
        else if textField == self.newPassView.newPassTextField{
            self.newPassView.seeNewPassTextButton.isHidden = true
        }else if textField == self.newPassView.confirmNewPassTextField{
            self.newPassView.seeConfirmPassTextButton.isHidden = true
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == self.emailField{
//            self.ridEmailBtn.isHidden = true
//        }
    }
}
