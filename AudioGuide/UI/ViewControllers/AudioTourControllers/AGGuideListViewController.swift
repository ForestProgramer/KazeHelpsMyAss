//
//  AGGuideListViewController.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 21.02.2022.
//

import UIKit

class AGGuideListViewController: AGViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}

// MARK: - UITableViewDataSource methods

extension AGGuideListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AGGuideTableViewCell") as? AGGuideTableViewCell {
            cell.setup()
            return cell
        }
        return UITableViewCell()
    }
    
}

// MARK: - UITableViewDelegate methods

extension AGGuideListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showDetails()
    }
}
