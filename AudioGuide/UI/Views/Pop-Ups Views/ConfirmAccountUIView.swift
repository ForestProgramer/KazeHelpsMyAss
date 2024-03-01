//
//  ConfirmAccountUIView.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 20.11.2023.
//

import UIKit

class ConfirmAccountUIView: UIView {

    let apiCall = APIManager.shared
    let codeEnterView : UIView = {
       let view = UIView()
        view.layer.cornerRadius = 24
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.layer.cornerRadius = 24
        return view
    }()
    let resetFirstLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins", size: 20)
        label.text = "Verification required"
        label.textColor = UIColor(hexString: "#CDCDCD")
        return label
    }()
    let secondaryDescLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins", size: 12)
        label.text = "Please, verify your email. We send you a code."
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    let enterCodeView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        return view
    }()
    let codeIconImageView : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "keyImage")
        image.tintColor = .white
        return image
    }()
    let codeTextField : UITextField = {
        let field = UITextField()
        field.font = UIFont(name: "Poppins", size: 16)
        field.keyboardType = .emailAddress
        field.attributedPlaceholder = NSAttributedString(
            string: "Enter the code",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        field.textColor = .white
        field.keyboardType = .numberPad
        field.addTarget(self, action: #selector(enterCode), for: .editingChanged)
        return field
    }()
    let ridCodeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ridIcon"), for: .normal)
        button.tintColor = .white
        button.isHidden = true
        button.addTarget(self, action: #selector(didRidText), for: .touchUpInside)
        return button
    }()
    let codeErrorLabel : UILabel = {
        let label = UILabel()
        label.text = "Wrong code. Please try again."
        label.textColor = .white
        label.font = UIFont(name: "Poppins", size: 9)
        label.isHidden = true
        return label
    }()
    let confirmCodeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirm the code", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(hexString: "#973939")
        button.isUserInteractionEnabled = false
        button.alpha = 0.5
        return button
    }()
//    let secondSecondaryLabel : UILabel = {
//        let label = UILabel()
//        label.text = "Didn`t get the code?"
//        label.textColor = .white
//        label.font = UIFont(name: "Poppins", size: 12)
//        return label
//    }()
//    let resendCodeBtn : UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Resend code", for: .normal)
//        button.tintColor = .white
//        if let titleLabel = button.titleLabel {
//            let attributes: [NSAttributedString.Key: Any] = [
//                .font: UIFont.boldSystemFont(ofSize: 16), // Жирний шрифт системи
//            ]
//            let attributedText = NSAttributedString(string: "Skip", attributes: attributes)
//            titleLabel.attributedText = attributedText
//        }
//        return button
//    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviewsToMainView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addSubviewsToMainView(){
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.addSubview(codeEnterView)
        codeEnterView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            codeEnterView.widthAnchor.constraint(equalToConstant: 343),
            codeEnterView.heightAnchor.constraint(equalToConstant: 241),
            codeEnterView.centerXAnchor.constraint(equalTo: centerXAnchor),
            codeEnterView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100)
        ])
        codeEnterView.addSubview(resetFirstLabel)
        resetFirstLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resetFirstLabel.leadingAnchor.constraint(equalTo: codeEnterView.leadingAnchor,constant: 24),
            resetFirstLabel.topAnchor.constraint(equalTo: codeEnterView.topAnchor,constant: 40),
            resetFirstLabel.widthAnchor.constraint(equalToConstant: 290),
            resetFirstLabel.heightAnchor.constraint(equalToConstant: 30)

        ])
        codeEnterView.addSubview(secondaryDescLabel)
        secondaryDescLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondaryDescLabel.leadingAnchor.constraint(equalTo: codeEnterView.leadingAnchor,constant: 24),
            secondaryDescLabel.topAnchor.constraint(equalTo: resetFirstLabel.bottomAnchor,constant: 2 ),
            secondaryDescLabel.widthAnchor.constraint(equalToConstant: 295),
            secondaryDescLabel.heightAnchor.constraint(equalToConstant: 18)

        ])
        codeEnterView.addSubview(enterCodeView)
        enterCodeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            enterCodeView.centerXAnchor.constraint(equalTo: codeEnterView.centerXAnchor),
            enterCodeView.topAnchor.constraint(equalTo: secondaryDescLabel.bottomAnchor,constant: 16),
            enterCodeView.widthAnchor.constraint(equalToConstant: 295),
            enterCodeView.heightAnchor.constraint(equalToConstant: 40)

        ])
        enterCodeView.addSubview(codeIconImageView)
        codeIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            codeIconImageView.leadingAnchor.constraint(equalTo: enterCodeView.leadingAnchor,constant: 8),
            codeIconImageView.topAnchor.constraint(equalTo: enterCodeView.topAnchor,constant: 8),
            codeIconImageView.widthAnchor.constraint(equalToConstant: 24),
            codeIconImageView.heightAnchor.constraint(equalToConstant: 24)

        ])
        enterCodeView.addSubview(codeTextField)
        codeTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            codeTextField.leadingAnchor.constraint(equalTo: enterCodeView.leadingAnchor,constant: 40),
            codeTextField.topAnchor.constraint(equalTo: enterCodeView.topAnchor,constant: 8),
            codeTextField.widthAnchor.constraint(equalToConstant: 190),
            codeTextField.heightAnchor.constraint(equalToConstant: 24)

        ])
        enterCodeView.addSubview(ridCodeButton)
        ridCodeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ridCodeButton.leadingAnchor.constraint(equalTo: enterCodeView.leadingAnchor,constant: 263),
            ridCodeButton.topAnchor.constraint(equalTo: enterCodeView.topAnchor,constant: 8),
            ridCodeButton.widthAnchor.constraint(equalToConstant: 24),
            ridCodeButton.heightAnchor.constraint(equalToConstant: 24)

        ])
        codeEnterView.addSubview(codeErrorLabel)
        codeErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            codeErrorLabel.centerXAnchor.constraint(equalTo: codeEnterView.centerXAnchor),
            codeErrorLabel.topAnchor.constraint(equalTo: enterCodeView.bottomAnchor,constant: 5),
            codeErrorLabel.widthAnchor.constraint(equalToConstant: 295),
            codeErrorLabel.heightAnchor.constraint(equalToConstant: 18)

        ])
        codeEnterView.addSubview(confirmCodeButton)
        confirmCodeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmCodeButton.centerXAnchor.constraint(equalTo: codeEnterView.centerXAnchor),
            confirmCodeButton.topAnchor.constraint(equalTo: codeErrorLabel.bottomAnchor,constant: 5),
            confirmCodeButton.widthAnchor.constraint(equalToConstant: 295),
            confirmCodeButton.heightAnchor.constraint(equalToConstant: 39)

        ])
//        codeEnterView.addSubview(secondSecondaryLabel)
//        secondSecondaryLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            secondSecondaryLabel.widthAnchor.constraint(equalToConstant: 130),
//            secondSecondaryLabel.heightAnchor.constraint(equalToConstant: 18),
//            secondSecondaryLabel.centerXAnchor.constraint(equalTo: codeEnterView.centerXAnchor),
//            secondSecondaryLabel.topAnchor.constraint(equalTo: codeEnterView.topAnchor,constant: 259)
//        ])
//        codeEnterView.addSubview(resendCodeBtn)
//        resendCodeBtn.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            resendCodeBtn.widthAnchor.constraint(equalToConstant: 160),
//            resendCodeBtn.heightAnchor.constraint(equalToConstant: 39),
//            resendCodeBtn.centerXAnchor.constraint(equalTo: codeEnterView.centerXAnchor),
//            resendCodeBtn.topAnchor.constraint(equalTo: codeEnterView.topAnchor,constant: 277)
//        ])
        
    }
    override func layoutSubviews() {
        codeEnterView.frame = CGRect(x: 50, y: 50, width: 343, height: 330)
        resetFirstLabel.frame = CGRect(x: 24, y: 40, width: 210, height: 30)
        secondaryDescLabel.frame = CGRect(x: 24, y: 72, width: 295, height: 18)
        enterCodeView.frame = CGRect(x: 24, y: 106, width: 295, height: 40)
        codeIconImageView.frame = CGRect(x: 8, y: 8, width: 24, height: 24)
        codeTextField.frame = CGRect(x: 40, y: 8, width: 190, height: 24)
        ridCodeButton.frame = CGRect(x: 263, y: 8, width: 24, height: 24)
        codeErrorLabel.frame = CGRect(x: 24, y: 150, width: 295, height: 14)
        confirmCodeButton.frame = CGRect(x: 24, y: 180, width: 295, height: 39)
//        secondSecondaryLabel.frame = CGRect(x: 112, y: 259, width: 130, height: 18)
//        resendCodeBtn.frame = CGRect(x: 102, y: 277, width: 160, height: 39)
        
        
        
    }

    @objc private func enterCode(){
        guard let text = codeTextField.text else {
            return
        }
        if text.count > 5{
            ridCodeButton.isHidden = true
            enterCodeView.layer.borderColor = UIColor.white.cgColor
            codeErrorLabel.isHidden = true
        }else{
            if text.isEmpty{
                ridCodeButton.isHidden = true
                ridCodeButton.isUserInteractionEnabled = false
                enterCodeView.layer.borderColor = UIColor.white.cgColor
                confirmCodeButton.isUserInteractionEnabled = false
                confirmCodeButton.alpha = 0.5
            }else{
                ridCodeButton.isHidden = false
                ridCodeButton.isUserInteractionEnabled = true
                enterCodeView.layer.borderColor = UIColor.red.cgColor
                confirmCodeButton.isUserInteractionEnabled = true
                confirmCodeButton.alpha = 1
            }
            ridCodeButton.setImage(UIImage(named: "ridIcon"), for: .normal)
            ridCodeButton.tintColor = .white
            
        }
    }
    @objc private func didRidText(){
        codeTextField.text = ""
        ridCodeButton.isHidden = true
        enterCodeView.layer.borderColor = UIColor.white.cgColor
    }

}
