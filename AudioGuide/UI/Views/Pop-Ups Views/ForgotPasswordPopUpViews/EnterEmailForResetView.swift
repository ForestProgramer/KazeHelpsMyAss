//
//  EnterEmailForResetView.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 31.10.2023.
//

import UIKit

class EnterEmailForResetView: UIView {
    let enterView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return view
    }()
    let resetFirstLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins", size: 20)
        label.text = "Forgot the password?"
        label.textColor = .white
        return label
    }()
    let secondaryDescLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins", size: 12)
        label.text = "Don`t worry! We will help you asap!"
        label.textColor = .white
        return label
    }()
    let enterMailView : UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        return view
    }()
    let mailIconImageView : UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "mainIconReg")
        return image
    }()
    let mailResetTextField : UITextField = {
       let field = UITextField()
        field.font = UIFont(name: "Poppins", size: 16)
        field.textColor = UIColor.white
        field.keyboardType = .emailAddress
        field.clearsOnBeginEditing = false
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.attributedPlaceholder = NSAttributedString(
            string: "Enter your email here",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        field.restorationIdentifier = "emailForReset"
        field.addTarget(self, action: #selector(startEdit), for: .editingChanged)
        return field
    }()
    let ridEmailTextButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ridIcon"), for: .normal)
        button.isHidden = true
        button.tintColor = .white
        button.addTarget(self, action: #selector(ridTextTap), for: .touchUpInside)
        return button
    }()
    let mailErrorLabel : UILabel = {
        let label = UILabel()
        label.text = "We cannot find this email.Please check it again."
        label.textColor = .white
        label.font = UIFont(name: "Poppins", size: 9)
        label.isHidden = true
        return label
    }()
    let sendCodeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send Code", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(hexString: "#973939")
        button.isUserInteractionEnabled = false
        button.alpha = 0.5
        return button
    }()
    let secondSecondaryLabel : UILabel = {
        let label = UILabel()
        label.text = "Are you new here?"
        label.textColor = .white
        label.font = UIFont(name: "Poppins", size: 12)
        return label
    }()
    let signInButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.tintColor = .white
        if let titleLabel = button.titleLabel {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 16), // Жирний шрифт системи
            ]
            let attributedText = NSAttributedString(string: "Skip", attributes: attributes)
            titleLabel.attributedText = attributedText
        }
        
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviewsToMainView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviewsToMainView(){
        mailIconImageView.tintColor = .white
        mailResetTextField.textColor = .white
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.addSubview(enterView)
        enterView.layer.cornerRadius = 24
        enterView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            enterView.widthAnchor.constraint(equalToConstant: 343),
            enterView.heightAnchor.constraint(equalToConstant: 330),
            enterView.centerXAnchor.constraint(equalTo: centerXAnchor),
            enterView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100)
        ])
        enterView.addSubview(resetFirstLabel)
        resetFirstLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resetFirstLabel.leadingAnchor.constraint(equalTo: enterView.leadingAnchor,constant: 24),
            resetFirstLabel.topAnchor.constraint(equalTo: enterView.topAnchor,constant: 48),
            resetFirstLabel.widthAnchor.constraint(equalToConstant: 222),
            resetFirstLabel.heightAnchor.constraint(equalToConstant: 30)
            
        ])
        enterView.addSubview(secondaryDescLabel)
        secondaryDescLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondaryDescLabel.leadingAnchor.constraint(equalTo: enterView.leadingAnchor,constant: 24),
            secondaryDescLabel.topAnchor.constraint(equalTo: enterView.topAnchor,constant: 80),
            secondaryDescLabel.widthAnchor.constraint(equalToConstant: 254),
            secondaryDescLabel.heightAnchor.constraint(equalToConstant: 18)
            
        ])
        enterView.addSubview(enterMailView)
        enterMailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            enterMailView.leadingAnchor.constraint(equalTo: enterView.leadingAnchor,constant: 24),
            enterMailView.topAnchor.constraint(equalTo: enterView.topAnchor,constant: 114),
            enterMailView.widthAnchor.constraint(equalToConstant: 295),
            enterMailView.heightAnchor.constraint(equalToConstant: 40)
            
        ])
        enterMailView.addSubview(mailIconImageView)
        mailIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mailIconImageView.leadingAnchor.constraint(equalTo: enterMailView.leadingAnchor,constant: 8),
            mailIconImageView.topAnchor.constraint(equalTo: enterMailView.topAnchor,constant: 8),
            mailIconImageView.widthAnchor.constraint(equalToConstant: 24),
            mailIconImageView.heightAnchor.constraint(equalToConstant: 24)
            
        ])
        enterMailView.addSubview(mailResetTextField)
        mailResetTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mailResetTextField.leadingAnchor.constraint(equalTo: enterMailView.leadingAnchor,constant: 40),
            mailResetTextField.topAnchor.constraint(equalTo: enterMailView.topAnchor,constant: 8),
            mailResetTextField.widthAnchor.constraint(equalToConstant: 210),
            mailResetTextField.heightAnchor.constraint(equalToConstant: 24)
            
        ])
        enterMailView.addSubview(ridEmailTextButton)
        ridEmailTextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ridEmailTextButton.leadingAnchor.constraint(equalTo: enterMailView.leadingAnchor,constant: 263),
            ridEmailTextButton.topAnchor.constraint(equalTo: enterMailView.topAnchor,constant: 8),
            ridEmailTextButton.widthAnchor.constraint(equalToConstant: 24),
            ridEmailTextButton.heightAnchor.constraint(equalToConstant: 24)
            
        ])
        enterView.addSubview(mailErrorLabel)
        mailErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mailErrorLabel.leadingAnchor.constraint(equalTo: enterView.leadingAnchor,constant: 24),
            mailErrorLabel.topAnchor.constraint(equalTo: enterView.topAnchor,constant: 158),
            mailErrorLabel.widthAnchor.constraint(equalToConstant: 295),
            mailErrorLabel.heightAnchor.constraint(equalToConstant: 14)
            
        ])
        enterView.addSubview(sendCodeButton)
        sendCodeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendCodeButton.leadingAnchor.constraint(equalTo: enterView.leadingAnchor,constant: 24),
            sendCodeButton.topAnchor.constraint(equalTo: enterView.topAnchor,constant: 180),
            sendCodeButton.widthAnchor.constraint(equalToConstant: 295),
            sendCodeButton.heightAnchor.constraint(equalToConstant: 39)
            
        ])
        enterView.addSubview(secondSecondaryLabel)
        secondSecondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondSecondaryLabel.centerYAnchor.constraint(equalTo: enterView.centerYAnchor),
            secondSecondaryLabel.topAnchor.constraint(equalTo: enterView.topAnchor,constant: 241),
            secondSecondaryLabel.widthAnchor.constraint(equalToConstant: 111),
            secondSecondaryLabel.heightAnchor.constraint(equalToConstant: 18)
            
        ])
        enterView.addSubview(signInButton)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInButton.centerYAnchor.constraint(equalTo: enterView.centerYAnchor),
            signInButton.topAnchor.constraint(equalTo: enterView.topAnchor,constant: 259),
            signInButton.widthAnchor.constraint(equalToConstant: 90),
            signInButton.heightAnchor.constraint(equalToConstant: 39)
        ])
//        enterView.addSubview(signInButton)
        
    }
    override func layoutSubviews() {
        enterView.backgroundColor = .black.withAlphaComponent(0.80)
        enterView.frame = CGRect(x: 50, y: 50, width: 343, height: 330)
        resetFirstLabel.frame = CGRect(x: 24, y: 48, width: 222, height: 30)
        secondaryDescLabel.frame = CGRect(x: 24, y: 80, width: 254, height: 18)
        enterMailView.frame = CGRect(x: 24, y: 114, width: 295, height: 40)
        mailIconImageView.frame = CGRect(x: 8, y: 8, width: 24, height: 24)
        mailResetTextField.frame = CGRect(x: 40, y: 8, width: 210, height: 24)
        ridEmailTextButton.frame = CGRect(x: 263, y: 8, width: 24, height: 24)
        mailErrorLabel.frame = CGRect(x: 24, y: 158, width: 295, height: 14)
        sendCodeButton.frame = CGRect(x: 24, y: 180, width: 295, height: 39)
        secondSecondaryLabel.frame = CGRect(x: 112, y: 241, width: 111, height: 18)
        signInButton.frame = CGRect(x: 126.5, y: 259, width: 90, height: 39)
        
        
    }
    @objc private func ridTextTap(){
        mailResetTextField.text = ""
        ridEmailTextButton.isHidden = true
        enterMailView.layer.borderColor = UIColor.white.cgColor
    }
    @objc private func startEdit(){
        guard let text = mailResetTextField.text else {
            return
        }
        mailErrorLabel.isHidden = true
        if text.count > 5{
                self.sendCodeButton.isUserInteractionEnabled = true
                self.sendCodeButton.alpha = 1
                self.ridEmailTextButton.isHidden = true
                self.enterMailView.layer.borderColor = UIColor.white.cgColor
        }else{
            if text.isEmpty{
                enterMailView.layer.borderColor = UIColor.white.cgColor
                ridEmailTextButton.isHidden = true
            }else{
                ridEmailTextButton.isHidden = false
                enterMailView.layer.borderColor = UIColor.red.cgColor
            }
                self.ridEmailTextButton.setImage(UIImage(named: "ridIcon"), for: .normal)
                self.ridEmailTextButton.tintColor = .white
                self.ridEmailTextButton.isUserInteractionEnabled = true
                self.sendCodeButton.isUserInteractionEnabled = false
                self.sendCodeButton.alpha = 0.5
        }
       
    }
}
