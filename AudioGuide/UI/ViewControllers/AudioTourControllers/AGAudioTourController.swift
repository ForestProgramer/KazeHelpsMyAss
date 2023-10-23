//
//  AGAudioTourController.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 02.02.2022.
//

import UIKit

class AGAudioTourController: AGViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var locationCollectionView: UICollectionView!
    @IBOutlet private weak var guideCollectionView: UICollectionView!
    @IBOutlet private weak var cafeCollectionView: UICollectionView!
    @IBOutlet private weak var searchField: UITextField!
    var staticData : [String] = ["Tour 1", "Tour 2", "Audio 1", "Audio 2"]
    var results = [String]()
    let searchTableView : UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(ResultSearchTableViewCell.self,
                       forCellReuseIdentifier: ResultSearchTableViewCell.identifier)
        table.layer.cornerRadius = 20
        table.clipsToBounds = true
        return table
    }()
//    let noResultsLabel: UILabel = {
//        let label = UILabel()
//        label.isHidden = true
//        label.text = "No Results"
//        label.textAlignment = .center
//        label.textColor = .black
//        label.font = .systemFont(ofSize: 21, weight: . medium)
//        return label
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.tableFooterView = UIView()
        searchTableView.backgroundColor = .white
//        view.addSubview(noResultsLabel)
        view.addSubview(searchTableView)
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchField.delegate = self
        self.setup()
    }
    
    @available(iOSApplicationExtension, unavailable)
    private func setup() {
        self.scrollView.addSubview(self.mainView)
        self.searchField.clearButtonTintColor = UIColor(named: "AccentColor")
        self.searchField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: (UIColor(hexString: "#3C3C43").withAlphaComponent(0.6)), NSAttributedString.Key.font: UIFont.PoppinsFont(ofSize: 14)])
        self.locationCollectionView.delegate = self
        self.guideCollectionView.delegate = self
        self.cafeCollectionView.delegate = self
        self.locationCollectionView.dataSource = self
        self.guideCollectionView.dataSource = self
        self.cafeCollectionView.dataSource = self
    }

    @available(iOSApplicationExtension, unavailable)
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.frame = self.view.frame
        self.mainView.frame = self.scrollView.frame
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + AGMainTabBarController.tabBarHeight -  self.view.safeAreaBottomHeight - self.view.safeAreaTopHeight)
        searchTableView.frame = CGRect(x: 25 , y: (view.frame.width / 2) - 15, width: view.frame.width - 50, height: view.frame.size.height / 2 )
//        noResultsLabel.frame = CGRect(x: self.view.frame.width/4,
//                                      y: (self.view.frame.height-200)/2,
//                                      width: self.view.frame.width/2,
//                                      height: 200)
        
    }
    func searchResults(_ searchText : String){
        let filteredData = staticData.filter { element in
                return element.lowercased().contains(searchText.lowercased())
            }
        self.results = filteredData
        self.searchTableView.reloadData()
    }
    
    
    @IBAction private func showLocationListHandler(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showLocationListSeque", sender: nil)
    }
    
    @IBAction private func showGuideListHandler(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showGuideListSeque", sender: nil)
    }

    // MARK: - Navigation

    @IBAction private func unwindWithLocationListSegue(unwindSegue: UIStoryboardSegue) {
    }
    
    @IBAction private func unwindWithGuideListSegue(unwindSegue: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}

// MARK: - UICollectionViewDataSource methods

extension AGAudioTourController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == locationCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AGLocationCollectionViewCell", for: indexPath as IndexPath) as? AGLocationCollectionViewCell {
                cell.setup()
                return cell
            }
        } else if collectionView == guideCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AGCuideCollectionViewCell", for: indexPath as IndexPath) as? AGCuideCollectionViewCell {
                cell.setup()
                return cell
            }
        } else if collectionView == cafeCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AGCafeCollectionViewCell", for: indexPath as IndexPath) as? AGCafeCollectionViewCell {
                cell.setup()
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
}


// MARK: - UICollectionViewDelegate methods

extension AGAudioTourController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.showLocationDetails()
        if collectionView == self.locationCollectionView{
            self.showLocationDetails()
        }else if collectionView == self.guideCollectionView{
            self.showAudioDetails()
        }else{
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AGAudioTourController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == locationCollectionView {
            return CGSize(width: 79, height: 104)
        } else if collectionView == guideCollectionView {
            return CGSize(width: 310, height: 310)
        } else if collectionView == cafeCollectionView {
            return CGSize(width: 132, height: 88)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == locationCollectionView {
            return 13
        }else{
            return 16
        }
        
    }
}
extension AGAudioTourController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = results[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultSearchTableViewCell.identifier, for: indexPath) as? ResultSearchTableViewCell else{
            fatalError()
        }
        cell.setUpText(text: result)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    
}
extension AGAudioTourController : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        results.removeAll()
        self.searchResults(searchText)
        updateUI()
        return true
    }
    func updateUI(){
        if results.isEmpty{
//            self.noResultsLabel.isHidden = false
            self.searchTableView.isHidden = true
        }else{
//            self.noResultsLabel.isHidden = true
            self.searchTableView.isHidden = false
            self.searchTableView.reloadData()
        }
    }
}
