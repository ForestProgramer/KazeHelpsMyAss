//
//  SceneDelegate.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 01.02.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let window = UIWindow(windowScene: windowScene)
        
        UITextField.appearance().textColor = UIColor(named: "AccentColor")
        UITabBar.appearance().barTintColor = UIColor(hexString: "#F8F8F8").withAlphaComponent(0.65)
        
        if let isOnboard = UserDefaults.isOnboard, isOnboard, UserDefaults.userEmail == nil {
            //let viewController = storyboard.instantiateViewController(withIdentifier: "AGStartViewController")
            let viewController = storyboard.instantiateViewController(withIdentifier: "AGMainTabBarController")
            let navViewController = UINavigationController(rootViewController: viewController)
            navViewController.isNavigationBarHidden = true
            //let viewController = storyboard.instantiateViewController(withIdentifier: "AGSubscriptionsViewController")
            window.rootViewController = navViewController
            self.window = window
            window.makeKeyAndVisible()
        } else if UserDefaults.userEmail != nil {
            let viewController = storyboard.instantiateViewController(withIdentifier: "AGTabViewController")
            window.rootViewController = UINavigationController(rootViewController: viewController)
            self.window = window
            window.makeKeyAndVisible()
        }
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


}

