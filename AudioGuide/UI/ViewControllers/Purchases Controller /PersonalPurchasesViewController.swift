//
//  PersonalPurchasesViewController.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 30.12.2023.
//

import UIKit

class PersonalPurchasesViewController: AGViewController {
    let dataSource : [Purchase] = [Purchase(name: "Dominican Church", imageName: "locationImage", type: "Audio guide", date: "02/01/2024", price: "3.99")]
    let mainView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(hexString: "#FAFAFA")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.PoppinsFont(ofSize: 24)
        label.text = "My purchases"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let tableViewPurchases : UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        return table
    }()
    let noPurchasesImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "noPurchaseImage") // Замініть на ваш образ
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainView)
        view.backgroundColor = .black
        mainView.addSubview(titleLabel)
        mainView.addSubview(tableViewPurchases)
        tableViewPurchases.delegate = self
        tableViewPurchases.dataSource = self
        tableViewPurchases.register(PurchaseTableViewCell.self, forCellReuseIdentifier: PurchaseTableViewCell.identifier)
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.topAnchor.constraint(equalTo: view.topAnchor,constant: self.safeAreaTopHeight + CustomNavigationController.customNavigationBarHeight),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        
            titleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor,constant: 16),
            titleLabel.topAnchor.constraint(equalTo: mainView.topAnchor),
            
            tableViewPurchases.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            tableViewPurchases.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableViewPurchases.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16),
            tableViewPurchases.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0),
        ])
        updateUI()
    }
    private func updateUI() {
            if dataSource.isEmpty {
                // Покажіть UIImageView, приховайте UITableView
                noPurchasesImageView.isHidden = false
                tableViewPurchases.isHidden = true
                mainView.addSubview(noPurchasesImageView)
                NSLayoutConstraint.activate([
                    noPurchasesImageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
                    noPurchasesImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
                    noPurchasesImageView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
//                    noPurchasesImageView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
                ])
            } else {
                // Покажіть UITableView, приховайте UIImageView
                noPurchasesImageView.isHidden = true
                tableViewPurchases.isHidden = false
                noPurchasesImageView.removeFromSuperview()
            }
    }
}

extension PersonalPurchasesViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PurchaseTableViewCell.identifier) as? PurchaseTableViewCell{
            let item = dataSource[indexPath.section]
            cell.configure(with: item)
            return cell
        }else{
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        72
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        16
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
}
