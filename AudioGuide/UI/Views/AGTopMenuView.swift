//
//  AGTopMenuView.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 07.02.2022.
//

import UIKit

class AGTopMenuView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectItem: ((_ index: Int) -> Void)?
    
    private let dataSource = ["Цікаві факти про Львів", "YouTube про Львів", "Аудіо тури", "Інфраструктура міста", "Запланувати власну екскурсію"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
  
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }

}

// MARK: - UITableViewDataSource methods

extension AGTopMenuView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.dataSource[indexPath.row]
        let cell = UITableViewCell()
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.textLabel?.text = item
        cell.textLabel?.font = UIFont.PoppinsFont(ofSize: 14)
        cell.textLabel?.textColor = .black
        return cell
    }
    
}

// MARK: - UITableViewDelegate methods

extension AGTopMenuView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectItem?(indexPath.row)
    }
}
