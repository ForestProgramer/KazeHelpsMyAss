//
//  AppDelegate.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 01.02.2022.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FBSDKCoreKit
import GoogleSignIn
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let apiCall = APIManager.shared
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GMSServices.provideAPIKey("AIzaSyBzA9qMUExvCNphRcb71vIucKxm8EPqR1c")
        GMSPlacesClient.provideAPIKey("AIzaSyBzA9qMUExvCNphRcb71vIucKxm8EPqR1c")
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // Show the app's signed-out state.
            } else {
                // Show the app's signed-in state.
            }
        }
        if UserDefaults.standard.value(forKey: "usedTrialBefore") != nil {
                UserDefaults.standard.set(true, forKey: "usedTrialBefore")
            }
        if let uuid = getUUID(){
            print("UUID!!! : \(uuid)")
            UserDefaults.standard.setValue(uuid, forKey: "id_device")
            apiCall.initUser(idDevice: uuid) { result in
                switch result{
                case .success():
                    print("Success id: \(uuid)")
                    UserDefaults.standard.set(false, forKey: "usedTrialBefore")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    UserDefaults.standard.set(true, forKey: "usedTrialBefore")
                    print("Succesfuly changed on true usedTrialBefore")
                    /// міняєм кнопку в onboarding можем просто якусь зміну булівську UserDefaults записати і перевіряти в останньому слайді цю змінну і тоді взагежності міняти кнопку
                }
            }
        }

        
        return true
    }
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        return GIDSignIn.sharedInstance.handle(url)
    }
    //    func customizeNavigationBarAppearance() {
    //            let navigationBarAppearance = UINavigationBar.appearance()
    //            navigationBarAppearance.barTintColor = UIColor.black  // Встановіть бажаний фоновий колір
    ////            navigationBarAppearance.tintColor = UIColor.white  // Встановіть бажаний колір тексту та іконок
    //        }
    
    func getUUID() -> String? {
        
        // create a keychain helper instance
        let keychain = KeyChainAccess()
        
        // this is the key we'll use to store the uuid in the keychain
        let uuidKey = "Funcosoft--Inc..AudioGuide.user.unique_uuid"
        
        // check if we already have a uuid stored, if so return it
        if let uuid = try? keychain.queryKeychainData(itemKey: uuidKey), uuid != nil {
            return uuid
        }
        
        // generate a new id
        guard let newId = UIDevice.current.identifierForVendor?.uuidString else {
            return nil
        }
        
        // store new identifier in keychain
        try? keychain.addKeychainData(itemKey: uuidKey, itemValue: newId)
        
        // return new id
        return newId
    }

}
