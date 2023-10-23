//
//  AGLocationListViewController.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 21.02.2022.
//

import UIKit

class AGLocationListViewController: AGViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}

// MARK: - UITableViewDataSource methods

extension AGLocationListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AGLocationTableViewCell") as? AGLocationTableViewCell {
            cell.setup()
            return cell
        }
        return UITableViewCell()
    }
    
}

// MARK: - UITableViewDelegate methods

extension AGLocationListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showLocationDetails()
    }
}
