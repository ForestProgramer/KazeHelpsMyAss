//
//  AGTourDetailsViewController.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 23.02.2022.
//

import UIKit

class AGTourDetailsViewController: AGViewController {

    
    @IBOutlet weak var mainLabel: AGLabel!
    @IBOutlet weak var reviewsTableView: UITableView!
    
    @IBOutlet weak var otherSidesCollectionView: UICollectionView!
    @IBOutlet weak var aboutTourView: UIView!
    @IBOutlet var reviewTourView: UIView!
    @IBOutlet weak var aboutBtn: UIButton!
    @IBOutlet weak var aboutActiveImageView: UIImageView!
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var reviewActiveImageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupBtns()
    }
    private func setupBtns() {
        self.aboutBtn.isSelected = true
        self.aboutTourView.isHidden = !self.aboutBtn.isSelected
        self.reviewBtn.isSelected = false
        self.reviewTourView.isHidden = !self.reviewBtn.isSelected
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        otherSidesCollectionView.register(AGDetailsCollectionViewCell.self, forCellWithReuseIdentifier: "AGDetailsCollectionViewCell")
        reviewsTableView.register(ReviewsTableViewCell.self, forCellReuseIdentifier: "ReviewsTableViewCell")
        reviewsTableView.separatorInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        reviewsTableView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    @available(iOSApplicationExtension, unavailable)
    private func setup() {
        self.reviewTourView.isHidden = true
        self.scrollView.addSubview(self.mainView)
        reviewTourView.frame = CGRect(x: 0, y: view.safeAreaTopHeight + 474, width: view.bounds.width, height: reviewTourView.bounds.height)
        reviewTourView.backgroundColor = .white
        
        
        
    }

    @available(iOSApplicationExtension, unavailable)
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.frame = self.view.frame
        self.mainView.frame = self.scrollView.frame
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 1200)
    }
    
    @IBAction private func backClicekd(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func aboutBtnClick(_ sender: Any) {
        self.aboutTourView.isHidden = false
        self.reviewTourView.isHidden = true
        self.aboutBtn.isSelected = true
        self.aboutActiveImageView.isHidden = !self.aboutBtn.isSelected
        self.reviewBtn.isSelected = false
        self.reviewActiveImageView.isHidden = !self.reviewBtn.isSelected
    }
    
    @IBAction func reviewBtnClick(_ sender: Any) {
        self.aboutTourView.isHidden = true
        self.reviewTourView.isHidden = false
        self.reviewBtn.isSelected = true
        self.reviewActiveImageView.isHidden = !self.aboutBtn.isSelected
        self.aboutBtn.isSelected = false
        self.aboutActiveImageView.isHidden = !self.aboutBtn.isSelected
        self.mainView.addSubview(reviewTourView)
    }
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}

// MARK: - UICollectionViewDataSource methods

extension AGTourDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AGDetailsCollectionViewCell", for: indexPath) as? AGDetailsCollectionViewCell {
            cell.setup()
            return cell
        }
        
        return UICollectionViewCell()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AGTourDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 132, height: 128)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

extension AGTourDetailsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell") as? ReviewsTableViewCell
        guard let cell = cell else {
            return UITableViewCell()
        }        
        cell.setUp()
        return cell
        
        
    }

    
}
