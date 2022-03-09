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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    @available(iOSApplicationExtension, unavailable)
    private func setup() {
        self.scrollView.addSubview(self.mainView)
        self.searchField.clearButtonTintColor = UIColor(named: "AccentColor")
        self.searchField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: (UIColor(hexString: "#3C3C43").withAlphaComponent(0.6)), NSAttributedString.Key.font: UIFont.PoppinsFont(ofSize: 14)])
    }

    @available(iOSApplicationExtension, unavailable)
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.frame = self.view.frame
        self.mainView.frame = self.scrollView.frame
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + AGMainTabBarController.tabBarHeight -  self.view.safeAreaBottomHeight - self.view.safeAreaTopHeight)
        
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
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AGLocationCollectionViewCell", for: indexPath as IndexPath) as? AGLocationCollectionViewCell, collectionView == locationCollectionView {
                cell.setup()
                return cell
            }
        } else if collectionView == guideCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AGCuideCollectionViewCell", for: indexPath as IndexPath) as? AGCuideCollectionViewCell, collectionView == guideCollectionView {
                cell.setup()
                return cell
            }
        } else if collectionView == cafeCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AGCafeCollectionViewCell", for: indexPath as IndexPath) as? AGCafeCollectionViewCell, collectionView == cafeCollectionView {
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
        self.showDetails()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AGAudioTourController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == locationCollectionView {
            return CGSize(width: 80, height: 104)
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
        }
        return 16
    }
}
