//
//  AGMenuView.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 09.02.2022.
//

import UIKit

class AGMenuView: UIView {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var logoutButton: UIButton!
    
    private let dataSource = ["Про додаток", "Поділитись", "Оцінити", "Користувацька угода"]
    private var currentIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction private func logoutHandler(_ sender: UIButton) {
        AGViewController.logout()
    }
}

// MARK: - UITableViewDataSource methods

extension AGMenuView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.dataSource[indexPath.row]
        let cell = UITableViewCell()
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.backgroundColor = currentIndex == indexPath.row ? UIColor(hexString: "#D3E5FF") : .clear
        cell.imageView?.image = currentIndex == indexPath.row ? UIImage(named: "menu_select_icon") : UIImage(named: "menu_icon")
        cell.textLabel?.text = item
        cell.textLabel?.font = UIFont.PoppinsFont(ofSize: 14)
        cell.textLabel?.textColor = currentIndex == indexPath.row ? UIColor(hexString: "#007AFF") : .black
        return cell
    }
    
}

// MARK: - UITableViewDelegate methods

extension AGMenuView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentIndex = indexPath.row
        self.tableView.reloadData()
    }
}
