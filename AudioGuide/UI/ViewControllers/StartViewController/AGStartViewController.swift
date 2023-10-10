//
//  AGStartViewController.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 03.02.2022.
//

import UIKit
/// Контроллер початкового скроллера
class AGStartViewController: AGViewController {

    @IBOutlet private weak var topConstant: NSLayoutConstraint!
    @IBOutlet private weak var imageConstant: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    private func setup() {
        //self.topConstant.constant = 22 + self.view.safeAreaTopHeight
        self.imageConstant.constant = self.hasSafeArea ? 292 : 180
    }
    
    @IBAction private func continueFree() {
        UserDefaults.isFreeVersion = true
        self.performSegue(withIdentifier: "showRegistrationSeque", sender: self)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
