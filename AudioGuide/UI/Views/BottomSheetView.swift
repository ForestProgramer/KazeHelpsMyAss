//
//  BottomSheetView.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 07.03.2024.
//

import UIKit

class BottomSheetView: UIViewController {
    var height: CGFloat
    init(height: CGFloat) {
        self.height = height
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print("Passed viewBeforeWindow")
        guard let rootView = self.view.viewBeforeWindow else { return }
        
        let safeArea = rootView.safeAreaInsets
        self.view.frame = CGRect(
            origin: .zero,
            size: CGSize(width: rootView.frame.width, height: rootView.frame.height - height - safeArea.bottom))

        self.view.clipsToBounds = true
        for view in self.view.subviews {
            ///Removing Shadow
            view.layer.shadowColor = UIColor.clear.cgColor
            if let animationKeys = view.layer.animationKeys(), !animationKeys.isEmpty {
                if let cornerRadiusView = view.allSubviews.first(where: { $0.layer.animationKeys()?.contains("cornerRadius") ?? false }) {
                    cornerRadiusView.layer.maskedCorners = []
                }
            }
        }
    }
}


