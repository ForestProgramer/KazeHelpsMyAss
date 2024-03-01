//
//  TermsAndConditionViewController.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 02.01.2024.
//

import UIKit

class TermsAndConditionViewController: AGViewController {
    let viewBackground : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(hexString: "#FAFAFA")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#FAFAFA")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.PoppinsFont(ofSize: 24)
        label.text = "Terms and conditions"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let termsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.PoppinsFont(ofSize: 16)
        label.text = """
           By accessing and placing an order with, you confirm that you are in agreement with and bound by the terms of service contained in the Terms & Conditions outlined below. These terms apply to the entire website and any email or other type of communication between you and Under no circumstances shall team be liable for any direct, indirect, special, incidental or consequential damages, including, but not limited to, loss of data or profit, arising out of the use, or the inability to use, the materials on this site, even if team or an authorized representative has been advised of the possibility of such damages. If your use of materials from this site results in the need for servicing, repair or correction of equipment or data, you assume any costs thereof. will not be responsible for any outcome that may occur during the course of usage of our resources. We reserve the rights to change prices and revise the resources usage policy in any moment.
           
           By accessing and placing an order with, you confirm that you are in agreement with and bound by the terms of service contained in the Terms & Conditions outlined below. These terms apply to the entire website and any email or other type of communication between you and Under no circumstances shall team be liable for any direct, indirect, special, incidental or consequential damages, including, but not limited to, loss of data or profit, arising out of the use, or the inability to use, the materials on this site, even if team or an authorized representative has been advised of the possibility of such damages. If your use of materials from this site results in the need for servicing, repair or correction of equipment or data, you assume any costs thereof. will not be responsible for any outcome that may occur during the course of usage of our resources. We reserve the rights to change prices and revise the resources usage policy in any moment.
           """
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(viewBackground)
        viewBackground.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(termsLabel)
        
        NSLayoutConstraint.activate([
            viewBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewBackground.topAnchor.constraint(equalTo: view.topAnchor,constant: self.safeAreaTopHeight + CustomNavigationController.customNavigationBarHeight),
            viewBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollView.leadingAnchor.constraint(equalTo: viewBackground.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: viewBackground.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: viewBackground.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: viewBackground.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
            termsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            termsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            termsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            termsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }
}
