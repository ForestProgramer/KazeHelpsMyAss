//
//  SplashScreenViewController.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 29.10.2023.
//

import UIKit

class SplashScreenViewController: AGViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Navigation

    @IBAction func didTapLetsGoBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "showLogAndReg", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
