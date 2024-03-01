//
//  AGOnboardViewControll.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 02.02.2022.
//

import UIKit

class AGOnboardViewController: AGViewController {

    @IBOutlet private weak var onboardView2: UIView!
    @IBOutlet private weak var onboardView3: UIView!
    @IBOutlet private weak var onboardView4: OnBoard3View!
    @IBOutlet private weak var pageControl: UIPageControl!
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
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setup()
        UserDefaults.isOnboard = true
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16) // Встановлюємо жирний шрифт з розміром 16
        ]
        let useTrial = UserDefaults.standard.bool(forKey: "usedTrialBefore")
        print("Bool : \(useTrial)")
        if useTrial{
            let attributedTitle = NSAttributedString(string: "Explore App", attributes: attributes)
            onboardView4.startTrialOrExploreAppBtn.setAttributedTitle(attributedTitle, for: .normal)
            onboardView4.tryLatterBtn.isHidden = true
        }else{
            let attributedTitle = NSAttributedString(string: "Start Your Trial Day", attributes: attributes)
            onboardView4.startTrialOrExploreAppBtn.setAttributedTitle(attributedTitle, for: .normal)
            onboardView4.tryLatterBtn.isHidden = true
        }
    }

    
    @available(iOSApplicationExtension, unavailable)
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.frame = CGRect(origin:  CGPoint(x: 0, y: self.view.safeAreaTopHeight), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        let frame = CGRect(origin: self.view.frame.origin, size: CGSize(width: self.view.frame.width, height: self.view.frame.height - self.view.safeAreaTopHeight))
        self.onboardView2.frame = CGRect(origin:  CGPoint(x: 0, y: frame.origin.y), size: CGSize(width: frame.width, height: frame.height))
        self.onboardView3.frame = CGRect(origin:  CGPoint(x: frame.width, y: frame.origin.y), size: CGSize(width: frame.width, height: frame.height))
        self.onboardView4.frame = CGRect(origin:  CGPoint(x: frame.width * 2, y: frame.origin.y), size: CGSize(width: frame.width, height: frame.height))
        self.scrollView.contentSize = CGSize(width: 3 * frame.width, height: frame.height)
    }
    
    private func setup() {
        self.view.addSubview(scrollView)
        self.view.bringSubviewToFront(pageControl)
        self.scrollView.addSubview(onboardView4)
        self.scrollView.addSubview(onboardView2)
        self.scrollView.addSubview(onboardView3)
        self.onboardView4.setUpBtn()
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.bounces = false
        self.scrollView.delegate = self
        self.pageControl.numberOfPages = 3
        self.pageControl.currentPage = 0
        self.pageControl.pageIndicatorTintColor = UIColor(named: "AccentHalfColor") ?? .red.withAlphaComponent(21)
        self.pageControl.currentPageIndicatorTintColor = UIColor(named: "AccentColor") ?? .red

        self.onboardTop2.constant = self.safeAreaTopHeight
        self.onboardTop3.constant = self.onboardTop2.constant
        self.onboardTop4.constant = self.onboardTop2.constant
        self.onboardImage1.constant = self.hasSafeArea ? 250 : 150
        self.onboardImage2.constant = self.hasSafeArea ? 150 : 110
        self.onboardImage3.constant = self.onboardImage2.constant
        self.onboardImage4.constant = self.hasSafeArea ? 250 : 190
    }
    
    @IBAction func didTapSegueBtn(_ sender: Any) {
        let useTrial = UserDefaults.standard.bool(forKey: "usedTrialBefore")
        if useTrial{
            guard let loginVC = storyboard?.instantiateViewController(withIdentifier: "AGLoginViewController") else{
                return
            }
            navigationController?.pushViewController(loginVC, animated: true)
        }else{
            guard let regVC = storyboard?.instantiateViewController(withIdentifier: "AGRegistrationViewController") else{
                return
            }
            navigationController?.pushViewController(regVC, animated: true)
        }
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
