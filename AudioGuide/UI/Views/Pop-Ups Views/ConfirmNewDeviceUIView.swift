//
//  ConfirmNewDeviceUIView.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 16.11.2023.
//

import UIKit

class ConfirmNewDeviceUIView: UIView {

    let apiCall = APIManager.shared
    let serverErrorPopUp = ServerErrorPopUpUIView()
    let confView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        return view
    }()
    let title : UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "Seems you've changed the device"
        return label
    }()
    let ridViewBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(systemName:"xmark"), for: .normal)
        btn.tintColor = UIColor(hexString: "#973939")
        btn.addTarget(self, action: #selector(didTapRidBtn), for: .touchUpInside)
        return btn
    }()
    let imageView : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        let im = UIImage(named: "nokiaImage")
        image.image = im
        return image
    }()
    let messageLabel : UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Poppins", size: 15)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "Please, confirm the email "
        return label
    }()
    let enterCodeView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        return view
    }()
    let iphoneIconImageView : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "iphone")
        image.tintColor = .black
        return image
    }()
    let textField : UITextField = {
        let field = UITextField()
        field.font = UIFont(name: "Poppins", size: 16)
        field.attributedPlaceholder = NSAttributedString(
            string: "Enter code from email here",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        field.textColor = .black
        field.keyboardType = .numberPad
        field.addTarget(self, action: #selector(enterCode), for: .editingChanged)
        return field
    }()
    let ridCodeButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "blackRidIcon"), for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(didRidText), for: .touchUpInside)
        return button
    }()
    let codeErrorLabel : UILabel = {
        let label = UILabel()
        label.text = "Wrong code. Please try again."
        label.textColor = .black
        label.font = UIFont(name: "Poppins", size: 9)
        label.isHidden = true
        return label
    }()
    let confrirmBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor(hexString: "#973939")
        btn.layer.cornerRadius = 10
        btn.setTitle("Confirm the code", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.isUserInteractionEnabled = false
        btn.alpha = 0.5
        btn.addTarget(self, action: #selector(didConfirmNewId), for: .touchUpInside)
        return btn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews(){
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        addSubview(confView)
        confView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confView.widthAnchor.constraint(equalToConstant: 343),
            confView.heightAnchor.constraint(equalToConstant: 564),
            confView.centerYAnchor.constraint(equalTo: centerYAnchor,constant: -50),
            confView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        confView.addSubview(ridViewBtn)
        ridViewBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ridViewBtn.trailingAnchor.constraint(equalTo: confView.trailingAnchor,constant: -24),
            ridViewBtn.topAnchor.constraint(equalTo: confView.topAnchor,constant: 32),
            ridViewBtn.widthAnchor.constraint(equalToConstant: 24),
            ridViewBtn.heightAnchor.constraint(equalToConstant: 24)
        ])
        confView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: confView.centerXAnchor),
            title.topAnchor.constraint(equalTo: confView.topAnchor,constant: 56),
            title.widthAnchor.constraint(equalToConstant: 246),
            title.heightAnchor.constraint(equalToConstant: 60)
        ])
        confView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: confView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: title.bottomAnchor,constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 327),
            imageView.heightAnchor.constraint(equalToConstant: 211),
        ])
        confView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: confView.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 16),
            messageLabel.widthAnchor.constraint(equalToConstant: 295),
            messageLabel.heightAnchor.constraint(equalToConstant: 46)
        ])
        confView.addSubview(enterCodeView)
        enterCodeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            enterCodeView.centerXAnchor.constraint(equalTo: confView.centerXAnchor),
            enterCodeView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor,constant: 16),
            enterCodeView.widthAnchor.constraint(equalToConstant: 295),
            enterCodeView.heightAnchor.constraint(equalToConstant: 40)
        ])
        enterCodeView.addSubview(iphoneIconImageView)
        iphoneIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iphoneIconImageView.centerYAnchor.constraint(equalTo: enterCodeView.centerYAnchor),
            iphoneIconImageView.leadingAnchor.constraint(equalTo: enterCodeView.leadingAnchor,constant: 8),
            iphoneIconImageView.widthAnchor.constraint(equalToConstant: 24),
            iphoneIconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        enterCodeView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.centerYAnchor.constraint(equalTo: enterCodeView.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: iphoneIconImageView.trailingAnchor,constant: 8),
            textField.widthAnchor.constraint(equalToConstant: 220),
            textField.heightAnchor.constraint(equalToConstant: 24)
        ])
        enterCodeView.addSubview(ridCodeButton)
        ridCodeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ridCodeButton.centerYAnchor.constraint(equalTo: enterCodeView.centerYAnchor),
            ridCodeButton.trailingAnchor.constraint(equalTo: enterCodeView.trailingAnchor,constant: -8),
            ridCodeButton.widthAnchor.constraint(equalToConstant: 24),
            ridCodeButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        confView.addSubview(codeErrorLabel)
        codeErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            codeErrorLabel.leadingAnchor.constraint(equalTo: confView.leadingAnchor,constant: 24),
            codeErrorLabel.topAnchor.constraint(equalTo: enterCodeView.bottomAnchor,constant: 4),
            codeErrorLabel.widthAnchor.constraint(equalToConstant: 295),
            codeErrorLabel.heightAnchor.constraint(equalToConstant: 14)
        ])
        confView.addSubview(confrirmBtn)
        confrirmBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confrirmBtn.centerXAnchor.constraint(equalTo: confView.centerXAnchor),
            confrirmBtn.topAnchor.constraint(equalTo: enterCodeView.bottomAnchor,constant: 30),
            confrirmBtn.widthAnchor.constraint(equalToConstant: 295),
            confrirmBtn.heightAnchor.constraint(equalToConstant: 39)
        ])
    }
    override func layoutSubviews() {
        confView.frame = CGRect(x: 50, y: 50, width: 343, height: 564)
        ridViewBtn.frame = CGRect(x: 295, y: 32, width: 24, height: 24)
        title.frame = CGRect(x: 39, y: 56, width: 246, height: 60)
        imageView.frame = CGRect(x: 8, y: 132, width: 327, height: 211)
        messageLabel.frame = CGRect(x: 24, y: 359, width: 295, height: 46)
        enterCodeView.frame = CGRect(x: 24, y: 421, width: 295, height: 40)
        iphoneIconImageView.frame = CGRect(x: 8, y: 8, width: 24, height: 24)
        textField.frame = CGRect(x: 40, y: 8, width: 220, height: 24)
//        ridCodeButton.frame = CGRect(x: 263, y: 8, width: 24, height: 24)
        codeErrorLabel.frame = CGRect(x: 24, y: 465, width: 295, height: 14)
//        confrirmBtn.frame = CGRect(x: 24, y: 509, width: 295, height: 39)
    }
    @objc private func enterCode(){
        guard let text = textField.text else {
            return
        }
        if text.count > 5{
            ridCodeButton.isHidden = true
            enterCodeView.layer.borderColor = UIColor.black.cgColor
            codeErrorLabel.isHidden = true
        }else{
            if text.isEmpty{
                ridCodeButton.isHidden = true
                ridCodeButton.isUserInteractionEnabled = false
                enterCodeView.layer.borderColor = UIColor.black.cgColor
                confrirmBtn.isUserInteractionEnabled = false
                confrirmBtn.alpha = 0.5
                confrirmBtn.setTitleColor(.black, for: .normal)
                confrirmBtn.isUserInteractionEnabled = false
            }else{
                ridCodeButton.isHidden = false
                ridCodeButton.isUserInteractionEnabled = true
                enterCodeView.layer.borderColor = UIColor.red.cgColor
                confrirmBtn.isUserInteractionEnabled = true
                confrirmBtn.alpha = 1
                confrirmBtn.setTitleColor(.white, for: .normal)
            }
            ridCodeButton.setImage(UIImage(named: "blackRidIcon"), for: .normal)
            ridCodeButton.tintColor = .black
            
        }
    }
    @objc private func didRidText(){
        textField.text = ""
        ridCodeButton.isHidden = true
        enterCodeView.layer.borderColor = UIColor.black.cgColor
    }
    @objc private func didTapRidBtn(){
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
                }) { _ in
                    // Приховання поп-апу після завершення анімації
                    self.textField.text = ""
                    self.removeFromSuperview()
                    self.alpha = 1
                }
    }
    @objc private func didConfirmNewId(){
        guard let code = textField.text,
              let newIdDevice = UserDefaults.standard.value(forKey: "id_device") as? String,
              let oldIdDevice = UserDefaults.standard.value(forKey: "old_id_device") as? String else{
                  print("OldDevice invalid!!!!")
            return
        }
        print("New ID : \(newIdDevice) , Old ID : \(oldIdDevice)")
        apiCall.confirmNewDeviceId(idDevice: newIdDevice, oldIdDevice: oldIdDevice, code: code) {[weak self] result in
            guard let strongSelf = self else{
                return
            }
            switch result{
            case .success(_):
                DispatchQueue.main.async {
                    NSLayoutConstraint.activate([
                        strongSelf.confView.widthAnchor.constraint(equalToConstant: 343),
                        strongSelf.confView.heightAnchor.constraint(equalToConstant: 508),
                        strongSelf.confView.centerYAnchor.constraint(equalTo: strongSelf.centerYAnchor,constant: -50),
                        strongSelf.confView.centerXAnchor.constraint(equalTo: strongSelf.centerXAnchor)
                    ])
                    strongSelf.title.text = "Device changed successfully!"
                    strongSelf.imageView.image = UIImage(named: "changedIDImage")
                    strongSelf.messageLabel.text = "You changed the device successfully. Let’s continue with new device."
                    strongSelf.enterCodeView.removeFromSuperview()
                    NSLayoutConstraint.activate([
                        strongSelf.confrirmBtn.centerXAnchor.constraint(equalTo: strongSelf.confView.centerXAnchor),
                        strongSelf.confrirmBtn.topAnchor.constraint(equalTo: strongSelf.messageLabel.bottomAnchor,constant: 16),
                        strongSelf.confrirmBtn.widthAnchor.constraint(equalToConstant: 295),
                        strongSelf.confrirmBtn.heightAnchor.constraint(equalToConstant: 39)
                    ])
                    strongSelf.confrirmBtn.setTitle("Sign In", for: .normal)
                    strongSelf.confrirmBtn.addTarget(self, action: #selector(strongSelf.goToApp), for: .touchUpInside)
                    UserDefaults.standard.removeObject(forKey: "old_id_device")
                }
                
            case .failure(let error):
                print("Error in reinit device: \(error.localizedDescription)")
                if (error as NSError).code == 422{
                    ///код поганний
                    strongSelf.enterCodeView.layer.borderColor = UIColor.red.cgColor
                    strongSelf.ridCodeButton.setImage(UIImage(named: "alertImage"), for: .normal)
                    strongSelf.ridCodeButton.tintColor = .red
                    strongSelf.ridCodeButton.isHidden = false
                    strongSelf.codeErrorLabel.isHidden = false
                }else if (error as NSError).code == 404{
                    print("confirmNewDeviceId 404 error")
                }else{
                    ///серверна помилка
                    strongSelf.add404PopUp()
                }
            }
        }
    }
    @objc private func goToApp(){
        
        DispatchQueue.main.async{
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0.0
            }) {[weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                // Приховання поп-апу після завершення анімації
                strongSelf.removeFromSuperview()
                strongSelf.alpha = 1
            }
        }
    }
    private func add404PopUp(){
        DispatchQueue.main.async {
            self.serverErrorPopUp.frame = self.bounds
            self.addSubview(self.serverErrorPopUp)
            self.serverErrorPopUp.alpha = 0.0
            // Анімація відображення затемнення і поп-апу
            UIView.animate(withDuration: 0.3) {
                self.serverErrorPopUp.alpha = 1.0
            }
        }
    }
}
