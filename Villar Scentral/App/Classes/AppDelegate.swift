//
//  AppDelegate.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 04/12/20.
//

import UIKit
import IQKeyboardManagerSwift
import CoreLocation

func appDelegate() -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate , LocationServiceDelegate {
    
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        getLoggedUser()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func getAddressForLocation(locationAddress: String, currentAddress: [String : Any]) {
        print(locationAddress)
        print(currentAddress)
        LocationData.init(long: Double(currentAddress["lat"] as? String ?? "") ?? 0.0, lat: Double(currentAddress["long"] as? String ?? "") ?? 0.0)
        
        Singleton.sharedInstance.lat = Double(currentAddress["lat"] as? String ?? "") ?? 0.0
        Singleton.sharedInstance.long = Double(currentAddress["long"] as? String ?? "") ?? 0.0
        
    }
    
    func Logout1(){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        let nav = UINavigationController(rootViewController: homeViewController)
        nav.setNavigationBarHidden(true, animated: true)
        appdelegate.window?.rootViewController = nav
    }
    
    func getLoggedUser(){
        let credentials = UserDefaults.standard.bool(forKey: "tokenFString")
        if credentials == true{
            
            let navigationController: UINavigationController? = (self.window?.rootViewController as? UINavigationController)
            let storyBoard = UIStoryboard.init(name: "SideMenu", bundle: nil)
            let rootVc = storyBoard.instantiateViewController(withIdentifier: "SideMenuControllerID") as! SideMenuController
            navigationController?.pushViewController(rootVc, animated: false)
        }else{
            let navigationController: UINavigationController? = (self.window?.rootViewController as? UINavigationController)
            let storyBoard = UIStoryboard.init(name: "Auth", bundle: nil)
            let rootVc = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
            navigationController?.pushViewController(rootVc, animated: false)
        }
    }
}

