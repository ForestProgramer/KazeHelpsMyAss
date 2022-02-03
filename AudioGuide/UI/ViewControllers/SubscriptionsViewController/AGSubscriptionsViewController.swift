//
//  AGSubscriptionsViewController.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 03.02.2022.
//

import UIKit

class AGSubscriptionsViewController: AGViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var topConstant: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    @available(iOSApplicationExtension, unavailable)
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.frame = self.view.frame
        self.mainView.frame = self.scrollView.frame
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.view.contentHeight)
    }
    
    private func setup() {
        self.scrollView.addSubview(self.mainView)
        self.scrollView.contentOffset = .zero;
        self.scrollView.contentInset = UIEdgeInsets.zero
    }
    
    @IBAction private func continueFree() {
        UserDefaults.isFreeVersion = true
        self.performSegue(withIdentifier: "showRegistrationSeque", sender: self)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
