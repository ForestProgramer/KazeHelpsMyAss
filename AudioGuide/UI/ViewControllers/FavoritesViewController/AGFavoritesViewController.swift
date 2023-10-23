//
//  AGFavoritesViewController.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 02.02.2022.
//

import UIKit

struct cellData{
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

class AGFavoritesViewController: AGViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var favoritesButton: UIButton!
    @IBOutlet private weak var tripButton: UIButton!
    @IBOutlet private weak var favoritesImageView: UIImageView!
    @IBOutlet private weak var tripImageView: UIImageView!
    @IBOutlet var tripsView: UIView!
    let tripsTableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    var trips = [cellData]()
    var buttonCreateNewtrip : UIButton = {
        var button = UIButton(type: .custom)
        button.setImage(UIImage(named: "buttonCreateGuide"), for: .normal)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        tripsView.frame = CGRect(x: 0, y: self.view.safeAreaTopHeight + 100 + self.tripButton.bounds.height + 5, width: self.view.bounds.width, height: self.view.bounds.height - (self.view.safeAreaTopHeight + 100 + self.tripButton.bounds.height + 5))
        tripsView.backgroundColor = .white
        tripsTableView.backgroundColor = .clear
        tripsTableView.delegate = self
        tripsTableView.dataSource = self
        self.setup()
        trips = [cellData(opened: false, title: "My trip 1", sectionData: ["Taras Shevchenko Monument", "Adam Mitskevych Monument", "St.Peter and St.Paul's Church"]),
        cellData(opened: false, title: "My trip 2", sectionData: ["Lviv Opera and Ballet Theatre", "Lviv National Museum", "Lviv Arsenal"]),
        cellData(opened: false, title: "My trip 3", sectionData: ["The High Castle", "The Dragon's Den", "The Market Square"])
        ]
        
    }
    
    private func setup() {
        self.favoritesButton.isSelected = true
        self.favoritesImageView.isHidden = !self.favoritesButton.isSelected
        self.tripButton.isSelected = false
        self.tripImageView.isHidden = !self.tripButton.isSelected
        self.tripsView.isHidden = !self.tripButton.isSelected
        buttonCreateNewtrip.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped(){
        let createNewTripViewController = CreateNewTripViewController()
            self.navigationController?.pushViewController(createNewTripViewController, animated: true)
        
    }
    
    @IBAction private func favoritesHandler(_ sender: UIButton) {
        self.tableView.isHidden = false
        self.favoritesButton.isSelected = true
        self.favoritesImageView.isHidden = !self.favoritesButton.isSelected
        self.tripButton.isSelected = false
        self.tripImageView.isHidden = !self.tripButton.isSelected
        self.tripsView.isHidden = !self.tripButton.isSelected
    }
    
    @IBAction private func tripHandler(_ sender: UIButton) {
        self.tableView.isHidden = true
        self.tripButton.isSelected = true
        self.tripImageView.isHidden = !self.favoritesButton.isSelected
        self.tripsView.isHidden = !self.tripButton.isSelected
        self.view.addSubview(tripsView)
        self.tripsView.addSubview(tripsTableView)
        self.view.addSubview(buttonCreateNewtrip)
        self.favoritesButton.isSelected = false
        self.favoritesImageView.isHidden = !self.favoritesButton.isSelected
    }
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
        tripsTableView.frame = CGRect(x: 0, y: 0, width: self.tripsView.frame.width, height: self.tripsView.frame.height)
        buttonCreateNewtrip.frame = CGRect(x: view.frame.size.width - 75, y: view.frame.size.height - view.safeAreaBottomHeight - 107, width: 48, height: 48)
        }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }

}


// MARK: - UITableViewDataSource methods

extension AGFavoritesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        trips.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView{
            return 7
        }else if tableView == self.tripsTableView{
            if trips[section].opened == true{
                return trips[section].sectionData.count + 1
            }else{
                return 1
            }
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView{
            let key = indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 6
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AGLocationTableViewCell") as? AGLocationTableViewCell, !key {
                cell.setup()
                return cell
            } else if let cell = tableView.dequeueReusableCell(withIdentifier: "AGGuideTableViewCell") as? AGGuideTableViewCell {
                cell.setup()
                return cell
            }
        }else if tableView == self.tripsTableView{
            if indexPath.row == 0{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else{
                    return UITableViewCell()
                }
                cell.textLabel?.text = trips[indexPath.section].title
                return cell
            }else{
                //Use different cell identifier if needed
                let dataIndex = indexPath.row - 1
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else{
                    return UITableViewCell()
                }
                cell.textLabel?.text = trips[indexPath.section].sectionData[dataIndex]
                return cell
            }
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate methods

extension AGFavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView{
            let key = indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 6
            return key ? 180 : 105
        }else if tableView == self.tripsTableView{
            return 42
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            if trips[indexPath.section].opened == true{
                trips[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tripsTableView.reloadSections(sections, with: .none)
            }else{
                trips[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tripsTableView.reloadSections(sections, with: .none)
            }
        }else{
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
