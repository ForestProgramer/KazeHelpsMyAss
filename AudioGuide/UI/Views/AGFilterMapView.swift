//
//  AGFilterMapView.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 07.02.2022.
//

import UIKit

class AGFilterMapView: UIView {

    @IBOutlet weak var tableView: UITableView!

    var selectItem: ((_ index: Int) -> Void)?
    
    private let dataSource = ["All objects", "Museums", "Galleries", "Sights", "Shops", "Food establishments", "Entertainment", "Other", "YouTube", "Interesting facts"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
  
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
}


// MARK: - UITableViewDataSource methods

extension AGFilterMapView: UITableViewDataSource {
    
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
        let imageView =  UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 19))
        imageView.image = UIImage(named: "filter_icon")
        cell.accessoryView = imageView
        return cell
    }
    
}

// MARK: - UITableViewDelegate methods

extension AGFilterMapView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectItem?(indexPath.row)
    }
}
