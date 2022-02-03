//
//  AGOnboardViewControll.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 02.02.2022.
//

import UIKit

class AGOnboardViewController: AGViewController {

    @IBOutlet private weak var onboardView1: UIView!
    @IBOutlet private weak var onboardView2: UIView!
    @IBOutlet private weak var onboardView3: UIView!
    @IBOutlet private weak var onboardView4: UIView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var onboardTop1: NSLayoutConstraint!
    @IBOutlet private weak var onboardTop2: NSLayoutConstraint!
    @IBOutlet private weak var onboardTop3: NSLayoutConstraint!
    @IBOutlet private weak var onboardTop4: NSLayoutConstraint!
    @IBOutlet private weak var onboardImage1: NSLayoutConstraint!
    @IBOutlet private weak var onboardImage2: NSLayoutConstraint!
    @IBOutlet private weak var onboardImage3: NSLayoutConstraint!
    @IBOutlet private weak var onboardImage4: NSLayoutConstraint!
    
    private var scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        UserDefaults.isOnboard = true
    }
    
    @available(iOSApplicationExtension, unavailable)
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.frame = CGRect(origin:  CGPoint(x: 0, y: -self.view.safeAreaTopHeight), size: CGSize(width: self.view.frame.width, height: self.view.frame.height + self.view.safeAreaTopHeight + self.view.safeAreaBottomHeight))
        let frame = CGRect(origin: self.view.frame.origin, size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        self.onboardView1.frame = CGRect(origin:  CGPoint(x: 0, y: frame.origin.y), size: CGSize(width: frame.width, height: frame.height))
        self.onboardView2.frame = CGRect(origin:  CGPoint(x: frame.width, y: frame.origin.y), size: CGSize(width: frame.width, height: frame.height))
        self.onboardView3.frame = CGRect(origin:  CGPoint(x: frame.width * 2, y: frame.origin.y), size: CGSize(width: frame.width, height: frame.height))
        self.onboardView4.frame = CGRect(origin:  CGPoint(x: frame.width * 3, y: frame.origin.y), size: CGSize(width: frame.width, height: frame.height))
        self.scrollView.contentSize = CGSize(width: 4 * frame.width, height: frame.height)
    }
    
    private func setup() {
        self.view.addSubview(self.scrollView)
        self.view.bringSubviewToFront(pageControl)
        self.scrollView.backgroundColor = .black
        self.scrollView.addSubview(onboardView1)
        self.scrollView.addSubview(onboardView2)
        self.scrollView.addSubview(onboardView3)
        self.scrollView.addSubview(onboardView4)
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.bounces = false
        self.scrollView.delegate = self
        self.pageControl.numberOfPages = 4
        self.pageControl.currentPage = 0
        self.pageControl.pageIndicatorTintColor = UIColor(named: "AccentHalfColor") ?? .red.withAlphaComponent(21)
        self.pageControl.currentPageIndicatorTintColor = UIColor(named: "AccentColor") ?? .red
        self.onboardTop1.constant = 22 + self.view.safeAreaTopHeight
        self.onboardTop2.constant = self.onboardTop1.constant
        self.onboardTop3.constant = self.onboardTop1.constant
        self.onboardTop4.constant = self.onboardTop1.constant
        self.onboardImage1.constant = self.hasSafeArea ? 292 : 140
        self.onboardImage2.constant = self.hasSafeArea ? 165 : 82
        self.onboardImage3.constant = self.onboardImage2.constant
        self.onboardImage4.constant = self.hasSafeArea ? 292 : 220
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

extension AGOnboardViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.pageControl.currentPage = Int(pageNumber)
   }
}
