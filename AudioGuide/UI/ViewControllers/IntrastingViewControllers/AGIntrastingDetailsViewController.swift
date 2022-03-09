//
//  AGIntrastingDetailsViewController.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 10.02.2022.
//

import UIKit

class AGIntrastingDetailsViewController: AGViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var titleView: AGLabel!
    @IBOutlet private weak var topConstant: NSLayoutConstraint!
    
    var itemTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    @available(iOSApplicationExtension, unavailable)
    private func setup() {
        self.titleView.text = self.itemTitle
        self.scrollView.addSubview(self.mainView)
        self.topConstant.constant = 8 + self.view.safeAreaTopHeight
    }

    @available(iOSApplicationExtension, unavailable)
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.frame = self.view.frame
        self.mainView.frame = self.scrollView.frame
        self.scrollView.contentOffset = .zero;
        self.scrollView.contentInset = UIEdgeInsets.zero
    }
   
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}
