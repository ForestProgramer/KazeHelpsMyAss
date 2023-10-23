//
//  AudioDetailsViewController.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 13.10.2023.
//

import UIKit

class AudioDetailsViewController: UIViewController {

    @IBOutlet weak var mainLabel: AGLabel!
    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var reviewImage: UIImageView!
    @IBOutlet weak var aboutBtn: UIButton!
    @IBOutlet weak var aboutImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var imageAbout: UIImageView!
    @IBOutlet weak var imageReview: UIImageView!
    @IBOutlet weak var aboutContainer: UIView!
    @IBOutlet var reviewContainer: UIView!
    private let viewmodels : [CollectionViewCellViewModel] = [
        CollectionViewCellViewModel(viewModels: [
            ElemntsColleViewCellViewModel(imageName: "otherToursImages"),
            ElemntsColleViewCellViewModel(imageName: "otherToursImages"),
            ElemntsColleViewCellViewModel(imageName: "otherToursImages"),
            ElemntsColleViewCellViewModel(imageName: "otherToursImages"),
            ElemntsColleViewCellViewModel(imageName: "otherToursImages")
        ])
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setUpTableView()
    }
    private func setup() {
        self.scrollView.addSubview(self.mainView)
        reviewContainer.isHidden = true
        reviewContainer.frame = CGRect(x: 0, y: view.safeAreaTopHeight + 351 + 123, width: view.bounds.width, height: reviewContainer.bounds.height)
        reviewContainer.backgroundColor = .white
        

        
    }
    private func setUpTableView(){
        self.tableView.register(OthersAudioToursTableViewCell.self, forCellReuseIdentifier: OthersAudioToursTableViewCell.identifier)
        self.reviewTableView.register(ReviewsTableViewCell.self, forCellReuseIdentifier: "ReviewsTableViewCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.reviewTableView.dataSource = self
        self.reviewTableView.delegate = self
    }
    private func setupBtns() {
//        self.aboutBtn.isSelected = true
//        self.informationContainer.isHidden = !self.aboutBtn.isSelected
//        self.reviewBtn.isSelected = false
//        self.reviewsContainer.isHidden = !self.reviewBtn.isSelected
//        reviewsTableView.delegate = self
//        reviewsTableView.dataSource = self
//        reviewsTableView.register(ReviewsTableViewCell.self, forCellReuseIdentifier: "ReviewsTableViewCell")
//        reviewsTableView.separatorInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
//        reviewsTableView.translatesAutoresizingMaskIntoConstraints = false
        
    }

    @available(iOSApplicationExtension, unavailable)
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.frame = self.view.frame
        self.mainView.frame = self.scrollView.frame
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 1100)
    }
    @IBAction func backClickBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }

    @IBAction func aboutBtnClicked(_ sender: Any) {
        self.aboutContainer.isHidden = false
        self.reviewContainer.isHidden = true
        self.aboutBtn.isSelected = true
        self.aboutImage.isHidden = !self.aboutBtn.isSelected
        self.reviewBtn.isSelected = false
        self.reviewImage.isHidden = !self.reviewBtn.isSelected
    }
    
    @IBAction func reviewBtnClicked(_ sender: Any) {
        self.aboutContainer.isHidden = true
        self.reviewContainer.isHidden = false
        self.reviewBtn.isSelected = true
        self.reviewImage.isHidden = !self.aboutBtn.isSelected
        self.aboutBtn.isSelected = false
        self.aboutImage.isHidden = !self.aboutBtn.isSelected
        self.mainView.addSubview(reviewContainer)
    }
    
}

extension AudioDetailsViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView{
            return viewmodels.count
        }else if tableView == reviewTableView{
            return 1
        }else {
            return 0
        }
       
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.reviewTableView{
           return 10
        }else{
            return 1
        }
        
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if tableView == self.tableView{
//            return nil
//        }else if tableView == self.reviewTableView{
//            let headerView = UIView()
//            headerView.backgroundColor = .white
//            return headerView
//        }else{
//            return nil
//        }
//
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView{
            return 128
        }else if tableView == self.reviewTableView{
            return 65
        }else{
            return 0
        }
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView{
            let viewModel = viewmodels[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OthersAudioToursTableViewCell.identifier, for: indexPath) as? OthersAudioToursTableViewCell else{
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell
        }else if tableView == self.reviewTableView{
            guard let reviewCell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell", for: indexPath) as? ReviewsTableViewCell else{
                fatalError()
            }
            reviewCell.setUp()
            return reviewCell
            
        }else {
            return UITableViewCell()
        }
        
       
    }
}
