//
//  AGRegistrationViewController.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 03.02.2022.
//

import UIKit
import RxSwift
import RxCocoa
import FBSDKLoginKit
import GoogleSignIn
//enum MatchType: String {
//    case CONFIRM = "cofirm_icon"
//    case ERROR = "error_icon"
//}
class AGRegistrationViewController: AGViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var panelView: UIView!
    @IBOutlet private weak var emailView: UIView!
    @IBOutlet weak var wrongEmailErrorLabel: UILabel!
    @IBOutlet weak var diffPassErrorLabel: UILabel!
    @IBOutlet private weak var passwordView: UIView!
    @IBOutlet private weak var confirmPasswordView: UIView!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet weak var ridEmailBtn: UIButton!
    @IBOutlet private weak var confirmPasswordField: UITextField!
    @IBOutlet private weak var goToLogButton: UIButton!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet private weak var showPasswordButton: UIButton!
    @IBOutlet private weak var showConfirmButton: UIButton!
    @IBOutlet private weak var passwordImageView: UIImageView!
    @IBOutlet private weak var registrButton: UIButton!
    @IBOutlet weak var enterEmailTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var signInBtnBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var confirmPasswordLabelContraint: NSLayoutConstraint!
    @IBOutlet weak var passwordLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var wrongEmailWidth: NSLayoutConstraint!
    let checkFiels = CheckField.shared
    let apiCall = APIManager.shared
    let ridResetViewButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(closeResetPasswordView), for: .touchUpInside)
        return button
    }()
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
    let alertPaswordLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins", size: 9)
        label.textColor = .white
        label.text = "Please, don’t reuse your bank account password. We didn’t spend a lot on security."
        label.numberOfLines = 2
        label.isHidden = true
        return label
    }()
    let facebookButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "facebookIconBtn"), for: .normal)
        button.titleLabel?.textColor = .blue
        button.backgroundColor = .clear
//        button.permissions = ["email", "public_profile"]
        button.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
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
    let confirmCodeView = ConfirmAccountUIView()
    let serverErrorView = ServerErrorPopUpUIView()
    let successVerificationView = SuccessVerifationUIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFacebookAndGoogleBtn()
        self.setup()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.skipButton.translatesAutoresizingMaskIntoConstraints = false
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        alertPaswordLabel.translatesAutoresizingMaskIntoConstraints = false
        googleButton.frame = CGRect(x: 0, y: 0, width: 167.5, height: 40)
        alertPaswordLabel.frame = CGRect(x: 16, y: 263.33, width: 343, height: 28)
        facebookButton.frame = CGRect(x: 0, y: 0, width: 166, height: 40)
        skipButton.frame = CGRect(x: 311, y: 24, width: 64, height: 39)
        confirmCodeView.frame = self.mainView.bounds
        serverErrorView.frame = self.mainView.bounds
        successVerificationView.frame = self.mainView.bounds
    }
    @objc private func closeResetPasswordView(){
        DispatchQueue.main.async {
            self.confirmCodeView.enterCodeView.layer.borderColor = UIColor.white.cgColor
            self.confirmCodeView.codeErrorLabel.isHidden = true
            self.confirmCodeView.codeTextField.text = ""
            self.confirmCodeView.confirmCodeButton.alpha = 0.5
            self.confirmCodeView.confirmCodeButton.isUserInteractionEnabled = false
            self.confirmCodeView.ridCodeButton.isHidden = true
//            self.confirmCodeView.secondaryDescLabel.text = "Secondary code was sent to "
            self.confirmCodeView.ridCodeButton.setImage(UIImage(named: "ridIcon"), for: .normal)
            self.confirmCodeView.ridCodeButton.isUserInteractionEnabled = false
            self.confirmCodeView.codeErrorLabel.text = "Wrong code. Please try again."
            self.confirmCodeView.ridCodeButton.tintColor = .white
        }
        
        guard let containerView = ridResetViewButton.superview,
              let view = containerView.superview else {
               return
           }
        UIView.animate(withDuration: 0.3, animations: {
            view.alpha = 0.0
                }) {[weak self] _ in
                    guard let strongSelf = self else {
                        return
                    }
                    // Приховання поп-апу після завершення анімації
                    view.removeFromSuperview()
                    view.alpha = 1
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7){
                        guard let appVC = strongSelf.storyboard?.instantiateViewController(withIdentifier: "AGMainTabBarController") else {
                            return
                        }
                        strongSelf.navigationController?.pushViewController(appVC, animated: true)
                    }
                }
       
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
    @available(iOSApplicationExtension, unavailable)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollView.frame = self.view.frame
        self.mainView.frame = self.hasSafeArea ? self.scrollView.frame : CGRect(x: self.scrollView.frame.origin.x, y: self.scrollView.frame.origin.y, width: self.scrollView.frame.width, height:  self.view.contentHeight)
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.view.contentHeight)
        self.panelView.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: gCorrnerRadius)
        GIDSignIn.sharedInstance.signOut()
    }
    
    @available(iOSApplicationExtension, unavailable)
    private func setup() {
        self.scrollView.addSubview(self.mainView)
        self.scrollView.contentOffset = .zero;
        self.scrollView.contentInset = UIEdgeInsets.zero
        addSkipButton()
        self.goToLogButton.clipsToBounds = true
        registrButton.isUserInteractionEnabled = false
        registrButton.alpha = 0.5
        emailField.textColor = .white
        emailField.attributedPlaceholder = NSAttributedString(
            string: "Enter your email here",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        ridEmailBtn.addTarget(self, action: #selector(ridEmailTextTap), for: .touchUpInside)
        emailField.addTarget(self, action: #selector(emailDidChanged), for: .editingChanged)
        passwordField.textColor = .white
        passwordField.attributedPlaceholder = NSAttributedString(
            string: "Create your password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        passwordField.addTarget(self, action: #selector(passDidChanged), for: .editingChanged)
        showPasswordButton.addTarget(self, action: #selector(showPasswordTap), for: .touchUpInside)
        confirmPasswordField.textColor = .white
        confirmPasswordField.attributedPlaceholder = NSAttributedString(
            string: "Confirm your password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        confirmPasswordField.addTarget(self, action: #selector(passDidChanged), for: .editingChanged)
        showConfirmButton.addTarget(self, action: #selector(showConfrimPasswordTap), for: .touchUpInside)
        self.emailView.layer.cornerRadius = self.gCorrnerRadius
        self.emailView.layer.borderColor = UIColor(hexString: "#CDCDCD").cgColor
        self.emailView.layer.borderWidth = 1.5
        self.emailView.clipsToBounds = true
        self.passwordView.layer.cornerRadius = self.gCorrnerRadius
        self.passwordView.layer.borderColor = UIColor(hexString: "#CDCDCD").cgColor
        self.passwordView.layer.borderWidth = 1.5
        self.passwordView.clipsToBounds = true
        self.confirmPasswordView.layer.cornerRadius = self.gCorrnerRadius
        self.confirmPasswordView.layer.borderColor = UIColor(hexString: "#CDCDCD").cgColor
        self.confirmPasswordView.layer.borderWidth = 1.5
        self.confirmPasswordView.clipsToBounds = true
        self.registrButton.addTarget(self, action: #selector(regIn), for: .touchUpInside)
    }
    private func setupFacebookAndGoogleBtn(){
        self.googleButton.layer.cornerRadius = 10
        self.googleButton.layer.borderColor = UIColor(hexString: "#F8F8F8").withAlphaComponent(0.82).cgColor
        self.googleButton.layer.borderWidth = 1
        self.googleButton.clipsToBounds = true
        self.facebookButton.layer.cornerRadius = 10
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
    }
    @objc private func ridEmailTextTap(){
        emailField.text?.removeAll()
        ridEmailBtn.isHidden = true
        ridEmailBtn.isUserInteractionEnabled = false
        emailView.layer.borderColor = UIColor.white.cgColor
        registrButton.alpha = 0.5
        registrButton.isUserInteractionEnabled = false
        wrongEmailErrorLabel.isHidden = true
       
    }
    
    @objc private func showPasswordTap(){
        self.showPasswordButton.isSelected = !self.showPasswordButton.isSelected
        self.passwordField.isSecureTextEntry = !self.showPasswordButton.isSelected
        if showPasswordButton.isSelected{
            showPasswordButton.setImage(UIImage(named: "viewNonActive"), for: .selected)
        }else{
            showPasswordButton.setImage(UIImage(named: "viewActive"), for: .normal)
        }
    }
    @objc private func showConfrimPasswordTap(){
        self.showConfirmButton.isSelected = !self.showConfirmButton.isSelected
        self.confirmPasswordField.isSecureTextEntry = !self.showConfirmButton.isSelected
        if showConfirmButton.isSelected{
            showConfirmButton.setImage(UIImage(named: "viewNonActive"), for: .selected)
        }else{
            showConfirmButton.setImage(UIImage(named: "viewActive"), for: .normal)
        }
    }

    //MARK: Changing Fields
    @objc private func emailDidChanged(){
        guard let text = emailField.text else{
            return
        }
        if checkFiels.validField(emailView, emailField){
            emailView.layer.borderColor = UIColor.white.cgColor
            wrongEmailErrorLabel.isHidden = true
        }else{
            if text.isEmpty{
                ridEmailBtn.isHidden = true
                ridEmailBtn.isUserInteractionEnabled = false
                emailView.layer.borderColor = UIColor.white.cgColor
                wrongEmailErrorLabel.isHidden = true
            }else{
                ridEmailBtn.isHidden = false
                ridEmailBtn.isUserInteractionEnabled = true
                emailView.layer.borderColor = UIColor.red.cgColor
                wrongEmailErrorLabel.isHidden = false
                wrongEmailErrorLabel.text = "*Wrong Email Adress"
                wrongEmailWidth.constant = 135
            }
        }
        validateThreeFields()
        
    }
    @objc private func passDidChanged(){
        guard let passText = passwordField.text, let confText = confirmPasswordField.text else{
            return
        }
        if checkFiels.validField(passwordView, passwordField){
            passwordView.layer.borderColor = UIColor.white.cgColor
        }else{
            if passText.isEmpty{
                showPasswordButton.isHidden = true
                passwordView.layer.borderColor = UIColor.white.cgColor
            }else{
                showPasswordButton.isHidden = false
                passwordView.layer.borderColor = UIColor.red.cgColor
            }
        }
        
        if checkFiels.validField(confirmPasswordView, confirmPasswordField) && passText.count == confText.count{
            confirmPasswordView.layer.borderColor = UIColor.white.cgColor
            diffPassErrorLabel.isHidden = true
        }else{
            if confText.isEmpty{
                showConfirmButton.isHidden = true
                confirmPasswordView.layer.borderColor = UIColor.white.cgColor
                diffPassErrorLabel.isHidden = true
            }else{
                showConfirmButton.isHidden = false
                confirmPasswordView.layer.borderColor = UIColor.red.cgColor
                if passText == confText{
                    diffPassErrorLabel.isHidden = true
                }else{
                    diffPassErrorLabel.isHidden = false
                }
                
            }
        }
        validateThreeFields()
    }
    func validateThreeFields(){
        guard let emailText = self.emailField.text,
              let passWordText = self.passwordField.text,
              let confirmPassText = self.confirmPasswordField.text else{
                  return
              }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if emailText.count > 5 && passWordText.count > 5 && confirmPassText.count > 5 && passWordText.count == confirmPassText.count {
                self.registrButton.isUserInteractionEnabled = true
                self.registrButton.alpha = 1
            }else {
                self.registrButton.isUserInteractionEnabled = false
                self.registrButton.alpha = 0.5
            }
        }
    }
    @objc private func loginButtonClicked(){
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["email", "public_profile"], from: self) { result, error in
            guard let token = result?.token?.tokenString else {
                print("User failed to log in with facebook")
                return
            }
            let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email, name"], tokenString: token, version: nil, httpMethod: .get)
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
                                
                            }else if error.code == 406{
                                
                            }else if error.code == 404{
                                
                            }else if error.code == 400{
                                
                            }else if error.code == 401{
                                
                            }else if error.code == 403{
                            
                            }else if error.code == 451{ }
                            print("Error to login user with google : \(error)")
                        }
                    }
                }
            }
        }
    }
    @objc private func signIn(){
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            
            // If sign in succeeded, display the app's main content View.
            print("Successfully signedIn with Google Button")
            guard let signInResult = signInResult else {
                print("Failed to sign in Successfully")
                return
                
            }
            guard let idDevice = UserDefaults.standard.value(forKey: "id_device") as? String else{
                return
            }
            
            let authCode = signInResult.serverAuthCode
            let userEmail = signInResult.user.profile?.email
            print("Google authCode : \(String(describing: authCode))")
            print("IdDevice : \(idDevice)")
            print("Email : \(String(describing: userEmail))")
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
                        //треба міняти глобальне значення для зміни rootviewController -а на app
                    }
                    print("Success register user with socials")
                case .failure(let error as NSError):
                    print("Error to register user : \(error.localizedDescription)")
                }
            }
        }
    }
    func addPopUpForVerification(){
//        confirmCodeView.resendCodeBtn.addTarget(self, action: #selector(resendCode), for: .touchUpInside)
        confirmCodeView.confirmCodeButton.addTarget(self, action: #selector(sendCodeToApi), for: .touchUpInside)
        confirmCodeView.codeTextField.textColor = .white
       
        mainView.addSubview(confirmCodeView)
        confirmCodeView.alpha = 0.0
        // Анімація відображення затемнення і поп-апу
        UIView.animate(withDuration: 0.3) {
            self.confirmCodeView.alpha = 1.0
        }
        
    }
    func add404PopUp(){
        mainView.addSubview(serverErrorView)
        serverErrorView.alpha = 0.0
        // Анімація відображення затемнення і поп-апу
        UIView.animate(withDuration: 0.3) {
            self.serverErrorView.alpha = 1.0
        }
        
    }
    //MARK: Повторне надсилання коду
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
                    strongSelf.confirmCodeView.codeTextField.text = ""
                    strongSelf.confirmCodeView.enterCodeView.layer.borderColor = UIColor.white.cgColor
                    strongSelf.confirmCodeView.ridCodeButton.isHidden = true
                    strongSelf.confirmCodeView.codeErrorLabel.isHidden = true
                }
            case .failure(let error):
                print("Error Resend : \(error.localizedDescription)")
                DispatchQueue.main.async {
                    strongSelf.confirmCodeView.enterCodeView.layer.borderColor = UIColor.red.cgColor
                    if (error as NSError).code == 422{
                        strongSelf.confirmCodeView.codeErrorLabel.text = "Error, invalid input data."
                    }else if (error as NSError).code == 404{
                        strongSelf.confirmCodeView.codeErrorLabel.text = "Have not found user with this email."
                    }else if (error as NSError).code == 409{
                        strongSelf.confirmCodeView.codeErrorLabel.text = "Had verified before this user."
                    }else if (error as NSError).code == 500{
                        ///404popup
                        strongSelf.add404PopUp()
                        
                    }
                }
            }
        }
        
    }
    //MARK: Реєстрація
    @objc private func regIn()
    {
        isInternetConnected { flags in
            // Перевірка наявності з'єднання
            if self.handleNetworkChange(flags: flags) {
                self.showNoWifi4PopUp()
            } else {
                guard let emailText = self.emailField.text,
                      let passwordText = self.passwordField.text,
                      let uuid = UserDefaults.standard.value(forKey: "id_device") as? String else {
                          return
                      }
                print("Email: \(emailText) , Password: \(passwordText) , UUID: \(uuid)")
                self.apiCall.registerUser(idDevice: uuid, email: emailText, password: passwordText) { error in
                    if let error = error{
                        print("error :\(error.localizedDescription)")
                        if (error as NSError).code == 422{
                            DispatchQueue.main.async {
                                self.emailView.layer.borderColor = UIColor.red.cgColor
                                self.wrongEmailErrorLabel.text = "*Email already registered"
                                self.ridEmailBtn.setImage(UIImage(named: "alertImage"), for: .normal)
                                self.ridEmailBtn.tintColor = .red
                                self.ridEmailBtn.isUserInteractionEnabled = false
                                self.wrongEmailWidth.constant = 165
                                self.wrongEmailErrorLabel.isHidden = false
                            }
                        }else if (error as NSError).code == 500{
                            ///404popup
                            self.add404PopUp()
                        }
                        
                        
                    }else{
                        DispatchQueue.main.async {
                            self.emailView.layer.borderColor = UIColor.white.cgColor
                            self.wrongEmailErrorLabel.text = "*Wrong Email Adress"
                            self.wrongEmailWidth.constant = 135
                            self.wrongEmailErrorLabel.isHidden = true
                            UserDefaults.standard.setValue(emailText, forKey: "email")
                            //                    self.skipButton.isHidden = true
                            self.addPopUpForVerification()
                        }
                    }
                }
            }
        }
    }
    //MARK: Перевірка вводу коду(якщо успішно то переходим в додаток)
    @objc private func sendCodeToApi(){
        guard let text = confirmCodeView.codeTextField.text,
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
                    strongSelf.confirmCodeView.enterCodeView.layer.borderColor = UIColor.white.cgColor
                    strongSelf.confirmCodeView.ridCodeButton.setImage(UIImage(named: "ridIcon"), for: .normal)
                    strongSelf.confirmCodeView.ridCodeButton.tintColor = .white
                    strongSelf.confirmCodeView.ridCodeButton.isHidden = true
                    strongSelf.confirmCodeView.ridCodeButton.isUserInteractionEnabled = true
                    strongSelf.confirmCodeView.codeErrorLabel.isHidden = true
                    strongSelf.addSuccesPopUp()
                }
            case .failure(let error) :
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    strongSelf.confirmCodeView.enterCodeView.layer.borderColor = UIColor.red.cgColor
                    strongSelf.confirmCodeView.ridCodeButton.setImage(UIImage(named: "alertImage"), for: .normal)
                    strongSelf.confirmCodeView.ridCodeButton.isHidden = false
                    strongSelf.confirmCodeView.ridCodeButton.tintColor = .red
                    strongSelf.confirmCodeView.ridCodeButton.isUserInteractionEnabled = false
                    strongSelf.confirmCodeView.codeErrorLabel.isHidden = false
                    if (error as NSError).code == 404{
                        strongSelf.confirmCodeView.codeErrorLabel.text = "No user with exact email."
                    }else if (error as NSError).code == 422{
                        strongSelf.confirmCodeView.codeErrorLabel.text = "Error invalid input data"
                    }else if (error as NSError).code == 400{
                        strongSelf.confirmCodeView.codeErrorLabel.text = "Wrong code. Please try again!"
                    }
                }
                

            }
        }
    }
    private func addSuccesPopUp(){
        confirmCodeView.removeFromSuperview()
        mainView.addSubview(successVerificationView)
        ridResetViewButton.frame = CGRect(x: 303, y: 16, width: 24, height: 24)
        successVerificationView.successView.addSubview(ridResetViewButton)
        NSLayoutConstraint.activate([
            ridResetViewButton.trailingAnchor.constraint(equalTo:  successVerificationView.successView.trailingAnchor, constant: -16),
            ridResetViewButton.topAnchor.constraint(equalTo:  successVerificationView.successView.topAnchor, constant: 16),
                    ridResetViewButton.heightAnchor.constraint(equalToConstant: 24),
                    ridResetViewButton.widthAnchor.constraint(equalToConstant: 24)
        
                ])
        successVerificationView.logInBtn.addTarget(self, action: #selector(goToApp), for: .touchUpInside)
    }
    @objc private func goToApp(){
        UserDefaults.isUserAuthorizationPassed = true
        UserDefaults.isFirstLaunchPassed = true
        print("Done\nisUserAuthorizationPassed : \(String(describing: UserDefaults.isUserAuthorizationPassed))\nisFirstLaunchPassed : \(String(describing: UserDefaults.isFirstLaunchPassed))")
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
    }
    @objc private func diTapRidBtn(){
        confirmCodeView.removeFromSuperview()
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
    func hideProblemPassAlert(){
        alertPaswordLabel.textColor = .white
        alertPaswordLabel.text = "Please, don’t reuse your bank account password. We didn’t spend a lot on security."
        alertPaswordLabel.removeFromSuperview()
        alertPaswordLabel.isHidden = true
        signInBtnBottomConstraint.constant = 86
        confirmPasswordLabelContraint.constant = 17
        enterEmailTopConstraint.constant = 17
        passwordLabelTopConstraint.constant = 17
        passwordView.layer.borderColor = UIColor.white.cgColor
    }
    func showProblemPassAlert(){
        alertPaswordLabel.textColor = .red
        alertPaswordLabel.text = "This password is too weak even for our simple validation"
        panelView.addSubview(alertPaswordLabel)
        alertPaswordLabel.isHidden = false
        enterEmailTopConstraint.constant = 11
        passwordLabelTopConstraint.constant = 11
        confirmPasswordLabelContraint.constant = 38
        signInBtnBottomConstraint.constant = 65
        NSLayoutConstraint.activate([
            alertPaswordLabel.leadingAnchor.constraint(equalTo: self.panelView.leadingAnchor,constant: 16),
            alertPaswordLabel.topAnchor.constraint(equalTo: self.passwordView.bottomAnchor,constant: 8),
            alertPaswordLabel.widthAnchor.constraint(equalToConstant: 343),
            alertPaswordLabel.heightAnchor.constraint(equalToConstant: 28),

        ])
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.passwordField, let text = textField.text {
            self.showPasswordButton.isHidden = text.isEmpty
            panelView.addSubview(alertPaswordLabel)
            self.alertPaswordLabel.isHidden = false
            self.enterEmailTopConstraint.constant = 11
            self.passwordLabelTopConstraint.constant = 11
            self.confirmPasswordLabelContraint.constant = 38
            self.signInBtnBottomConstraint.constant = 65
//            self.confirmPasswordLabelContraint.secondItem = self.alertPaswordLabel.bottomAnchor
            NSLayoutConstraint.activate([
                alertPaswordLabel.leadingAnchor.constraint(equalTo: self.panelView.leadingAnchor,constant: 16),
                alertPaswordLabel.topAnchor.constraint(equalTo: self.passwordView.bottomAnchor,constant: 8),
                alertPaswordLabel.widthAnchor.constraint(equalToConstant: 343),
                alertPaswordLabel.heightAnchor.constraint(equalToConstant: 28),

            ])
        }else if textField == self.emailField{
            guard let text = textField.text else{
               return
            }
            self.ridEmailBtn.isHidden = text.isEmpty
            self.ridEmailBtn.setImage(UIImage(named: "ridIcon"), for: .normal)
            self.ridEmailBtn.isUserInteractionEnabled = true
            self.wrongEmailErrorLabel.text = "*Wrong Email"
        }else if textField == self.confirmPasswordField, let text = textField.text {
            self.showConfirmButton.isHidden = text.isEmpty
        }
    }
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
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == passwordField{
            alertPaswordLabel.removeFromSuperview()
            alertPaswordLabel.isHidden = true
            signInBtnBottomConstraint.constant = 86
            confirmPasswordLabelContraint.constant = 17
            enterEmailTopConstraint.constant = 17
            passwordLabelTopConstraint.constant = 17
            
        }
    }
}
