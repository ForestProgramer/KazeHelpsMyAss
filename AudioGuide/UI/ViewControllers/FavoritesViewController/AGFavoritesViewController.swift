//
//  AGFavoritesViewController.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 02.02.2022.
//

import UIKit

class AGFavoritesViewController: AGViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var favoritesButton: UIButton!
    @IBOutlet private weak var tripButton: UIButton!
    @IBOutlet private weak var favoritesImageView: UIImageView!
    @IBOutlet private weak var tripImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    private func setup() {
        self.favoritesButton.isSelected = true
        self.favoritesImageView.isHidden = !self.favoritesButton.isSelected
        self.tripButton.isSelected = false
        self.tripImageView.isHidden = !self.tripButton.isSelected
    }
    
    @IBAction private func favoritesHandler(_ sender: UIButton) {
        self.tableView.isHidden = false
        self.favoritesButton.isSelected = true
        self.favoritesImageView.isHidden = !self.favoritesButton.isSelected
        self.tripButton.isSelected = false
        self.tripImageView.isHidden = !self.tripButton.isSelected
    }
    
    @IBAction private func tripHandler(_ sender: UIButton) {
        self.tableView.isHidden = true
        self.tripButton.isSelected = true
        self.tripImageView.isHidden = !self.favoritesButton.isSelected
        self.favoritesButton.isSelected = false
        self.favoritesImageView.isHidden = !self.favoritesButton.isSelected
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }

}


// MARK: - UITableViewDataSource methods

extension AGFavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let key = indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 6
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AGLocationTableViewCell") as? AGLocationTableViewCell, !key {
            cell.setup()
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: "AGGuideTableViewCell") as? AGGuideTableViewCell {
            cell.setup()
            return cell
        }
        return UITableViewCell()
    }
    
}

// MARK: - UITableViewDelegate methods

extension AGFavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let key = indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 6
        return key ? 180 : 105
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showDetails()
    }
}
