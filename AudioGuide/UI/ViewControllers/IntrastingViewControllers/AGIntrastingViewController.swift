//
//  AGIntrastingViewController.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 09.02.2022.
//

import UIKit

class AGIntrastingViewController: AGViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var topConstant: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchField: UITextField!
    @IBOutlet private weak var bottomConstant: NSLayoutConstraint!
    
    private let dataSource = ["Перша пошта у Львові", "Львівська бруківка", "Перша пошта у Львові", "Львівська бруківка", "Перша пошта у Львові", "Львівська бруківка", "Перша пошта у Львові", "Львівська бруківка", "Перша пошта у Львові", "Львівська бруківка", "Перша пошта у Львові", "Львівська бруківка", "Перша пошта у Львові", "Львівська бруківка", "Перша пошта у Львові", "Львівська бруківка"]
    var content: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    @available(iOSApplicationExtension, unavailable)
    private func setup() {
        self.searchField.clearButtonTintColor = UIColor(named: "AccentColor")
        self.searchField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: (UIColor(hexString: "#3C3C43").withAlphaComponent(0.6)), NSAttributedString.Key.font: UIFont.PoppinsFont(ofSize: 14)])
        self.content = self.dataSource
        self.scrollView.addSubview(self.mainView)
        //self.topConstant.constant = 8 + self.view.safeAreaTopHeight
        self.searchField.tintColor = UIColor(hexString: "#973939")
        self.searchField.textColor = UIColor(hexString: "#973939")
    }

    @available(iOSApplicationExtension, unavailable)
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.mainView.frame = self.view.frame
    }
    
    override func setBottomOffset(keyboardInfo: UIKeyboardInfo) {
        self.bottomConstant.constant = keyboardInfo.frame.height
        UIView.animate(withDuration: 0, delay: 0.3, options: UIView.AnimationOptions.curveEaseInOut) {
            self.view.setNeedsDisplay()
        } completion: { _ in }
        
    }
    
    @IBAction private func unwindWithIntrestingDetailsSegue(unwindSegue: UIStoryboardSegue) {
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? AGIntrastingDetailsViewController, let itemTitle = sender as? String {
            controller.itemTitle = itemTitle
        }
    }
    

}

// MARK: - UITableViewDataSource methods

extension AGIntrastingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AGIntrastingTableViewCell") as? AGIntrastingTableViewCell {
            let item = self.content[indexPath.row]
            cell.setup(item: item)
            return cell
        }
        return UITableViewCell()
    }
    
}

// MARK: - UITableViewDelegate methods

extension AGIntrastingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showIntrastingDetailsSeque", sender: self.content[indexPath.row])
    }
}


extension AGIntrastingViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let text = self.searchField.text {
                self.content = text.isEmpty ? self.dataSource : self.dataSource.filter { item in
                    let str = item.lowercased().prefix(text.count)
                    return text.lowercased() == str
                }
                self.tableView.reloadData()
            }
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.content = self.dataSource
        self.tableView.reloadData()
        return true
    }
    
}
