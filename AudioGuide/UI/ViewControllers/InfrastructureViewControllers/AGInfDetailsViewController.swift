//
//  AGInfDetailsViewController.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 08.02.2022.
//

import UIKit

class AGInfDetailsViewController: AGViewController {

    @IBOutlet private weak var topConstant: NSLayoutConstraint!
    @IBOutlet private weak var titleView: AGLabel!
    @IBOutlet private weak var searchField: UITextField!
    
    var itemTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    @available(iOSApplicationExtension, unavailable)
    private func setup() {
//        self.searchField.clearButtonTintColor = UIColor(named: "AccentColor")
        self.searchField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: (UIColor(hexString: "#3C3C43").withAlphaComponent(0.6)), NSAttributedString.Key.font: UIFont.PoppinsFont(ofSize: 14)])
        self.titleView.text = self.itemTitle
        //self.topConstant.constant = 8 + self.view.safeAreaTopHeight
    }

    @available(iOSApplicationExtension, unavailable)
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        
    }
    

}

// MARK: - UITableViewDataSource methods

extension AGInfDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AGInfrastructureTableViewCell") as? AGInfrastructureTableViewCell {
            cell.setup(index: indexPath.row%2 == 0)
            return cell
        }
        return UITableViewCell()
    }
    
}

// MARK: - UITableViewDelegate methods

extension AGInfDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
