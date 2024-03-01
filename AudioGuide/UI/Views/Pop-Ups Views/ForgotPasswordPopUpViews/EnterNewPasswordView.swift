//
//  EnterNewPasswordView.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 31.10.2023.
//

import UIKit

class EnterNewPasswordView: UIView {
    
    let passEnterView : UIView = {
       let view = UIView()
        view.layer.cornerRadius = 24
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        return view
    }()
    let resetFirstLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins", size: 20)
        label.text = "Create new password"
        label.textColor = .white
        return label
    }()
    let secondaryDescLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins", size: 12)
        label.text = "Let`s try to create unforgetable password"
        label.textColor = .white
        return label
    }()
    let resetPasswordMailView : UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        return view
    }()
    let passIconImageView : UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "lockIcon" )
        image.tintColor = .white
        return image
    }()
    let newPassTextField : UITextField = {
       let field = UITextField()
        field.font = UIFont(name: "Poppins", size: 16)
        field.textColor = UIColor.white
        field.isSecureTextEntry = true
        field.attributedPlaceholder = NSAttributedString(
            string: "Create your password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        field.textColor = .white
        return field
    }()
    let seeNewPassTextButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named:"viewActive"), for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(showNewPassword), for: .touchUpInside)
        return button
    }()
    let confirmPasswordView : UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        return view
    }()
    let confirmPassIconImageView : UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "lockIcon" )
        image.tintColor = .white
        return image
    }()
    let confirmNewPassTextField : UITextField = {
       let field = UITextField()
        field.font = UIFont(name: "Poppins", size: 16)
        field.textColor = UIColor.white
        field.isSecureTextEntry = true
        field.attributedPlaceholder = NSAttributedString(
            string: "Confirm your password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        field.textColor = .white
        return field
    }()
    let seeConfirmPassTextButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "viewActive"), for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(showNewConfirmedPassword), for: .touchUpInside)
        return button
    }()
    let passErrorLabel : UILabel = {
        let label = UILabel()
        label.text = "Different passwords.Please, check it."
        label.textColor = .white
        label.font = UIFont(name: "Poppins", size: 9)
        label.isHidden = true
        return label
    }()
    let confirmNewPassButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirm the password", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(hexString: "#973939")
        button.isUserInteractionEnabled = false
        button.alpha = 0.5
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
        newPassTextField.textColor = .white
        confirmNewPassTextField.textColor = .white
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.addSubview(passEnterView)
        passEnterView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passEnterView.centerXAnchor.constraint(equalTo: centerXAnchor),
            passEnterView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100),
            passEnterView.widthAnchor.constraint(equalToConstant: 343),
            passEnterView.heightAnchor.constraint(equalToConstant: 330)
        ])
        passEnterView.addSubview(resetFirstLabel)
        resetFirstLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resetFirstLabel.leadingAnchor.constraint(equalTo: passEnterView.leadingAnchor,constant: 24),
            resetFirstLabel.topAnchor.constraint(equalTo: passEnterView.topAnchor,constant: 48),
            resetFirstLabel.widthAnchor.constraint(equalToConstant: 222),
            resetFirstLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        passEnterView.addSubview(secondaryDescLabel)
        secondaryDescLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondaryDescLabel.leadingAnchor.constraint(equalTo: passEnterView.leadingAnchor,constant: 24),
            secondaryDescLabel.topAnchor.constraint(equalTo: passEnterView.topAnchor,constant: 80),
            secondaryDescLabel.widthAnchor.constraint(equalToConstant: 254),
            secondaryDescLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        passEnterView.addSubview(resetPasswordMailView)
        resetPasswordMailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resetPasswordMailView.leadingAnchor.constraint(equalTo: passEnterView.leadingAnchor,constant: 24),
            resetPasswordMailView.topAnchor.constraint(equalTo: passEnterView.topAnchor,constant: 114),
            resetPasswordMailView.widthAnchor.constraint(equalToConstant: 295),
            resetPasswordMailView.heightAnchor.constraint(equalToConstant: 40)
        ])
        resetPasswordMailView.addSubview(passIconImageView)
        passIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passIconImageView.leadingAnchor.constraint(equalTo: resetPasswordMailView.leadingAnchor,constant: 8),
            passIconImageView.topAnchor.constraint(equalTo: resetPasswordMailView.topAnchor,constant: 8),
            passIconImageView.widthAnchor.constraint(equalToConstant: 24),
            passIconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        resetPasswordMailView.addSubview(newPassTextField)
        newPassTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newPassTextField.leadingAnchor.constraint(equalTo: resetPasswordMailView.leadingAnchor,constant: 40),
            newPassTextField.topAnchor.constraint(equalTo: resetPasswordMailView.topAnchor,constant: 8),
            newPassTextField.widthAnchor.constraint(equalToConstant: 190),
            newPassTextField.heightAnchor.constraint(equalToConstant: 24)
        ])
        resetPasswordMailView.addSubview(seeNewPassTextButton)
        seeNewPassTextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seeNewPassTextButton.leadingAnchor.constraint(equalTo: resetPasswordMailView.leadingAnchor,constant: 263),
            seeNewPassTextButton.topAnchor.constraint(equalTo: resetPasswordMailView.topAnchor,constant: 8),
            seeNewPassTextButton.widthAnchor.constraint(equalToConstant: 24),
            seeNewPassTextButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        passEnterView.addSubview(confirmPasswordView)
        confirmPasswordView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmPasswordView.leadingAnchor.constraint(equalTo: passEnterView.leadingAnchor,constant: 24),
            confirmPasswordView.topAnchor.constraint(equalTo: passEnterView.topAnchor,constant: 170),
            confirmPasswordView.widthAnchor.constraint(equalToConstant: 295),
            confirmPasswordView.heightAnchor.constraint(equalToConstant: 40)
        ])
        confirmPasswordView.addSubview(confirmPassIconImageView)
        confirmPassIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmPassIconImageView.leadingAnchor.constraint(equalTo: confirmPasswordView.leadingAnchor,constant: 8),
            confirmPassIconImageView.topAnchor.constraint(equalTo: confirmPasswordView.topAnchor,constant: 8),
            confirmPassIconImageView.widthAnchor.constraint(equalToConstant: 24),
            confirmPassIconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        confirmPasswordView.addSubview(confirmNewPassTextField)
        confirmNewPassTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmNewPassTextField.leadingAnchor.constraint(equalTo: confirmPasswordView.leadingAnchor,constant: 40),
            confirmNewPassTextField.topAnchor.constraint(equalTo: confirmPasswordView.topAnchor,constant: 8),
            confirmNewPassTextField.widthAnchor.constraint(equalToConstant: 190),
            confirmNewPassTextField.heightAnchor.constraint(equalToConstant: 24)
        ])
        confirmPasswordView.addSubview(seeConfirmPassTextButton)
        seeConfirmPassTextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seeConfirmPassTextButton.leadingAnchor.constraint(equalTo: confirmPasswordView.leadingAnchor,constant: 263),
            seeConfirmPassTextButton.topAnchor.constraint(equalTo: confirmPasswordView.topAnchor,constant: 8),
            seeConfirmPassTextButton.widthAnchor.constraint(equalToConstant: 24),
            seeConfirmPassTextButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        passEnterView.addSubview(passErrorLabel)
        passErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passErrorLabel.leadingAnchor.constraint(equalTo: passEnterView.leadingAnchor,constant: 24),
            passErrorLabel.topAnchor.constraint(equalTo: passEnterView.topAnchor,constant: 214),
            passErrorLabel.widthAnchor.constraint(equalToConstant: 295),
            passErrorLabel.heightAnchor.constraint(equalToConstant: 14)
        ])
        passEnterView.addSubview(confirmNewPassButton)
        confirmNewPassButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmNewPassButton.leadingAnchor.constraint(equalTo: passEnterView.leadingAnchor,constant: 24),
            confirmNewPassButton.topAnchor.constraint(equalTo: passEnterView.topAnchor,constant: 234),
            confirmNewPassButton.widthAnchor.constraint(equalToConstant: 295),
            confirmNewPassButton.heightAnchor.constraint(equalToConstant: 39)
        ])
    }
    
    override func layoutSubviews() {
        passEnterView.frame = CGRect(x: 50, y: 50, width: 343, height: 330)
        resetFirstLabel.frame = CGRect(x: 24, y: 48, width: 222, height: 30)
//        secondaryDescLabel.frame = CGRect(x: 24, y: 80, width: 254, height: 18)
//        resetPasswordMailView.frame = CGRect(x: 24, y: 114, width: 295, height: 40)
//        passIconImageView.frame = CGRect(x: 8, y: 8, width: 24, height: 24)
//        newPassTextField.frame = CGRect(x: 40, y: 8, width: 190, height: 24)
//        seeNewPassTextButton.frame = CGRect(x: 263, y: 8, width: 24, height: 24)
//        confirmPasswordView.frame = CGRect(x: 24, y: 170, width: 295, height: 40)
//        confirmPassIconImageView.frame = CGRect(x: 8, y: 8, width: 24, height: 24)
//        confirmNewPassTextField.frame = CGRect(x: 40, y: 8, width: 190, height: 24)
//        seeConfirmPassTextButton.frame = CGRect(x: 263, y: 8, width: 24, height: 24)
//        passErrorLabel.frame = CGRect(x: 24, y: 214, width: 295, height: 14)
//        confirmNewPassButton.frame = CGRect(x: 24, y: 234, width: 295, height: 39)
        
        
    }
    @objc private func showNewPassword(){
        seeNewPassTextButton.isSelected = !self.seeNewPassTextButton.isSelected
         self.newPassTextField.isSecureTextEntry = !self.seeNewPassTextButton.isSelected
         if seeNewPassTextButton.isSelected{
             seeNewPassTextButton.setImage(UIImage(named: "viewNonActive"), for: .selected)
         }else{
             seeNewPassTextButton.setImage(UIImage(named: "viewActive"), for: .normal)
         }
    }
    @objc private func showNewConfirmedPassword(){
       seeConfirmPassTextButton.isSelected = !self.seeConfirmPassTextButton.isSelected
        self.confirmNewPassTextField.isSecureTextEntry = !self.seeConfirmPassTextButton.isSelected
        if seeConfirmPassTextButton.isSelected{
            seeConfirmPassTextButton.setImage(UIImage(named: "viewNonActive"), for: .selected)
        }else{
            seeConfirmPassTextButton.setImage(UIImage(named: "viewActive"), for: .normal)
        }
    }
}
