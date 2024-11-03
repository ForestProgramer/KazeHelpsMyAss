//
//  UISheetPresentationControllerExtension.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 07.03.2024.
//

import UIKit
extension UISheetPresentationController {
    func applyBottomSheetStyle(withHeight height: CGFloat) {
        _ = false
        var firstView: UIView?
        print("No enter rootView")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            guard let rootView = self.presentedViewController.view.viewBeforeWindow,
            let window = rootView.window else { return }
            print("Passed enter rootView")
            print("Root view type: \(type(of: rootView))")
            print("tabBarHeight : \(height)")
            // Обчислення нової висоти rootView з врахуванням висоти tabBar
            let newRootViewHeight = rootView.frame.height - self.presentedViewController.view.safeAreaInsets.bottom - height - 53 - self.safeAreaTopHeight
            print("New rootView height : \(newRootViewHeight)")
            // Оновлення розмірів rootView
            rootView.frame = CGRect(origin: .init(x: 0, y: 53 + self.safeAreaTopHeight), size: CGSize(width: rootView.frame.width, height: newRootViewHeight))
            rootView.clipsToBounds = true
            rootView.layer.maskedCorners = []
            rootView.layoutIfNeeded()
            firstView = window.subviews[0]
            firstView?.subviews.forEach({ dropShadowView in
                print("right view type: \(type(of: dropShadowView))")
                if String(describing: type(of: dropShadowView)).contains("UIDropShadowView"){
                    dropShadowView.subviews.forEach { dropShadowElents in
                        if String(describing: type(of: dropShadowElents)).contains("UIDimmingView") {
                            print("Found that one ")
                            dropShadowElents.frame = CGRect(origin: .init(x: 0, y: 53 + self.safeAreaTopHeight), size: CGSize(width: rootView.frame.width, height: newRootViewHeight))
                            dropShadowElents.isHidden = true
                            dropShadowElents.layoutIfNeeded()
                        }
                    }
                }
            })
            rootView.subviews.forEach { subview in
                print("subview view type: \(type(of: subview))")
                if String(describing: type(of: subview)).contains("UIDropShadowView") {
                    subview.layer.maskedCorners = []
                    subview.subviews.forEach { shadowSubview in
                        print("shadowSubview \(type(of: shadowSubview))")
                        if String(describing: type(of: shadowSubview)).contains("_UIRoundedRectShadowView") {
                            shadowSubview.layer.maskedCorners = []
                            shadowSubview.layer.masksToBounds = false
                            shadowSubview.layer.cornerRadius = 0
                            shadowSubview.clipsToBounds = false
                        }else if String(describing: type(of: shadowSubview)).contains("UIView"){
                            print("Enter UIview ")
                            shadowSubview.layer.maskedCorners = []
                            shadowSubview.layer.masksToBounds = false
                            shadowSubview.layer.cornerRadius = 0
                            shadowSubview.clipsToBounds = false
                        }
                    }
                }
//                else if String(describing: type(of: subview)).contains("UIDimmingView") {
//                    print("Enter UIDimmingView")
//                    subview.frame = CGRect(origin: .zero, size: CGSize(width: subview.frame.width, height: newRootViewHeight))
//                    subview.clipsToBounds = true
//        //            rootView.layer.maskedCorners = []
//                    subview.layoutIfNeeded()
//                }
            }
        }
    }
}

