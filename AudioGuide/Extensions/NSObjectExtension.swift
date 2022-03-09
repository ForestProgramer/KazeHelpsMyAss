//
//  NSObjectExtension.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 30.12.2021.
//

import UIKit

extension UITableViewCell {
    func removeSectionSeparators() {
        for subview in subviews {
            if subview != contentView && subview.frame.width == frame.width {
                subview.removeFromSuperview()
            }
        }
    }
}

extension NSObject {
    
    @available(iOSApplicationExtension, unavailable)
    var hasSafeArea: Bool {
        guard #available(iOS 11.0, *), let topPadding = UIWindow.key?.safeAreaInsets.top, topPadding > 20 else {
            return false
        }
        return true
    }
    
    @available(iOSApplicationExtension, unavailable)
    var safeAreaTopHeight: CGFloat {
        if #available(iOS 11.0, *) {
            if let keyWindow = UIWindow.key {
             return keyWindow.safeAreaInsets.top
            }
        }
        return 0
    }
    
    @available(iOSApplicationExtension, unavailable)
    var safeAreaBottomHeight: CGFloat {
        if #available(iOS 11.0, *) {
            if let keyWindow = UIWindow.key {
                return keyWindow.safeAreaInsets.bottom
            }
        }
        return 0
    }
    
    @available(iOSApplicationExtension, unavailable)
    func topViewController(rootViewController: UIViewController?) -> UIViewController? {
        guard let rootViewController = rootViewController else { return nil }
        if let controller = rootViewController as? UITabBarController {
            return self.topViewController(rootViewController: controller.selectedViewController)
        } else if let controller = rootViewController as? UINavigationController {
            return self.topViewController(rootViewController: controller.visibleViewController)
        } else if let controller = rootViewController.presentedViewController {
            return self.topViewController(rootViewController: controller)
        } else {
            return rootViewController
        }
    }

    @available(iOSApplicationExtension, unavailable)
    func topViewController() -> UIViewController? {
        let scene = UIApplication.shared.connectedScenes.first
        guard let sd : SceneDelegate = (scene?.delegate as? SceneDelegate), let rootViewController = sd.window?.rootViewController else { return nil }
        return self.topViewController(rootViewController: rootViewController)
    }
}

