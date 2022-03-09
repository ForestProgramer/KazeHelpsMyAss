//
//  AGTopPanel.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 07.02.2022.
//

import UIKit

class AGTopPanel: UIView {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var filterButton: UIButton!
    @IBOutlet private weak var topLabel: AGLabel!
    
    var showMenu: (() -> Void)?
    var hideMenu: (() -> Void)?
    var showFilter: (() -> Void)?
    var hideFilter: (() -> Void)?
    var isMenuShow = false
    var isFilterShow = false
    var selectIndex = 0 {
        didSet {
            self.filterButton.isHidden = selectIndex < 3
            self.topLabel.text = ""
            if selectIndex == 0 {
                self.topLabel.text = "What are you looking for?"
            } else if selectIndex == 1 {
                self.topLabel.text = "Your favorites"
            } else if selectIndex == 2 {
                self.topLabel.text = "Where to go?"
            } else if selectIndex == 3 {
                self.topLabel.text = "Taras Shevchenko st."
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
  
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    @IBAction private func menuClicked() {
        isMenuShow = !isMenuShow
        if isMenuShow {
            self.showMenu?()
        } else {
            self.hideMenu?()
        }
    }
    
    @IBAction private func filterClicked() {
        isFilterShow = !isFilterShow
        if isFilterShow {
            self.showFilter?()
        } else {
            self.hideFilter?()
        }
    }
}
