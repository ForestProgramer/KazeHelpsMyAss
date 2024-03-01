//
//  AGInfrastructureViewControllers.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 10.02.2022.
//

import UIKit

class AGInfrastructureViewControllers: AGViewController {

    @IBOutlet private weak var topConstant: NSLayoutConstraint!
    @IBOutlet private weak var searchField: UITextField!
    @IBOutlet private var buttons: [UIButton]!
    @IBOutlet private var imageViews: [UIView]!
    
    private var content: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @available(iOSApplicationExtension, unavailable)
    private func setup() {
//        self.searchField.clearButtonTintColor = UIColor(named: "AccentColor")
        self.searchField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: (UIColor(hexString: "#3C3C43").withAlphaComponent(0.6)), NSAttributedString.Key.font: UIFont.PoppinsFont(ofSize: 14)])
        //self.topConstant.constant = 8 + self.view.safeAreaTopHeight
        self.content = buttons.map({$0.titleLabel?.text ?? ""})
    }

    private func showButtons() {
        for item in buttons { item.isHidden = false }
        for item in imageViews { item.isHidden = false }
        self.buttons[0].setTitle(self.content.first ?? "", for: .normal)
    }
    
    private func hideButtons() {
        for item in buttons { item.isHidden = true }
        for item in imageViews { item.isHidden = true }
    }
    
    @IBAction private func buttonClicked( _sender: UIButton) {
        self.performSegue(withIdentifier: "showInfrastructureDetailsSeque", sender: _sender.titleLabel?.text)
    }
    
    
    // MARK: - Navigation

    @IBAction private func unwindWithInfrastructureDetailsSegue(unwindSegue: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? AGInfDetailsViewController, let itemTitle = sender as? String {
            controller.itemTitle = itemTitle
        }
    }
    

}

extension AGInfrastructureViewControllers: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let text = self.searchField.text {
                self.hideButtons()
                if text.isEmpty {
                    self.showButtons()
                } else if let title = self.content.filter({ item in
                    let str = item.lowercased().prefix(text.count)
                    return text.lowercased() == str
                }).first {
                    self.buttons[0].setTitle(title, for: .normal)
                    self.buttons[0].isHidden = false
                    self.imageViews[0].isHidden = false
                }
            }
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.showButtons()
        return true
    }
    
}
