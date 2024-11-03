//
//  SceneDelegate.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 01.02.2022.
//

import UIKit
import FBSDKCoreKit
import SystemConfiguration
import SwiftUI
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    let apiCall = APIManager.shared
    // Додати слухача подій для моніторингу змін стану мережі
    let reachability = SCNetworkReachabilityCreateWithName(nil, "www.apple.com")
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
                guard let windowScene = (scene as? UIWindowScene) else { return }
        
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let window = UIWindow(windowScene: windowScene)
                print("isUserAuthorizationPassed : \(String(describing: UserDefaults.isUserAuthorizationPassed))")
                UITabBar.appearance().barTintColor = UIColor(hexString: "#F8F8F8").withAlphaComponent(0.65)
                if let isFirstLaunchPassed = UserDefaults.isFirstLaunchPassed, isFirstLaunchPassed == false {
                    // Перший запуск, показати onboarding
                    print("isFirstLaunch : \(isFirstLaunchPassed)")
                    startStartScreen(storyboard: storyboard, window: window)
                } else if let isFreeVersion = UserDefaults.isFreeVersion, let isUserAuthorizationPassed = UserDefaults.isUserAuthorizationPassed {
                    if isFreeVersion == true || isUserAuthorizationPassed == true{
                        startApp(storyboard: storyboard, window: window)
                    }
        
                }
    }
    private func startApp(storyboard : UIStoryboard, window : UIWindow){
        let viewController = storyboard.instantiateViewController(withIdentifier: "AGMainTabBarController")
        let navViewController = UINavigationController(rootViewController: viewController)
        navViewController.isNavigationBarHidden = true
        window.rootViewController = navViewController
        self.window = window
        window.makeKeyAndVisible()
    }
    private func isInternetConnected(){
            // Додати слухача подій для моніторингу змін стану мережі
            var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
            context.info = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
            
            if SCNetworkReachabilitySetCallback(reachability!, { (reachability, flags, info) in
                if let info = info {
                    let sceneDelegate = Unmanaged<SceneDelegate>.fromOpaque(info).takeUnretainedValue()
                    sceneDelegate.handleNetworkChange(flags: flags)
                }
            }, &context) {
                SCNetworkReachabilityScheduleWithRunLoop(reachability!, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
            }
    }
    // Функція для обробки змін стану мережі
    func handleNetworkChange(flags: SCNetworkReachabilityFlags) {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

           if isReachable && !needsConnection {
               // Інтернет доступний, нічого не робимо
           } else {
               // Немає інтернет-з'єднання, показуємо повідомлення
               showNoWifi4PopUp()
           }
    }
    private func showNoWifi4PopUp() {
        DispatchQueue.main.async {
            guard let currentViewController = self.visibleViewController() else {
                print("No Controller")
                return
            }

            let wifiPopUpView = LostWifiConnectionUIView()
            wifiPopUpView.frame = currentViewController.view.bounds
            currentViewController.view.addSubview(wifiPopUpView)

            print("Everything must work")
            wifiPopUpView.alpha = 0.0

            // Анімація відображення затемнення і поп-апу
            UIView.animate(withDuration: 0.3) {
                wifiPopUpView.alpha = 1.0
            }
        }
    }
    private func visibleViewController() -> UIViewController? {
        if let rootViewController = self.window?.rootViewController {
           print("Available root view controller")
            var visibleViewController: UIViewController? = rootViewController

            while let presentedViewController = visibleViewController?.presentedViewController {
                visibleViewController = presentedViewController
            }

            if let navigationController = visibleViewController as? UINavigationController {
                visibleViewController = navigationController.visibleViewController
            } else if let tabBarController = visibleViewController as? UITabBarController {
                visibleViewController = tabBarController.selectedViewController
            }

            return visibleViewController
        }
        print("No root view controller")
        return nil
    }
    private func startStartScreen(storyboard : UIStoryboard, window : UIWindow){
        let viewController = storyboard.instantiateViewController(withIdentifier: "AGOnboardViewController")
        window.rootViewController = UINavigationController(rootViewController: viewController)
        self.window = window
        window.makeKeyAndVisible()
    }
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
//        isInternetConnected()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    deinit {
            SCNetworkReachabilityUnscheduleFromRunLoop(reachability!, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
        }
}

