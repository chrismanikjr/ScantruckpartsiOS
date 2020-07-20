//
//  AppDelegate.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 6/16/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import UIKit
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UITabBar.appearance().barTintColor = #colorLiteral(red: 0.1441617906, green: 0.2710582912, blue: 0.5564466715, alpha: 1)
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.9529948831, green: 0.6848092675, blue: 0.1331576109, alpha: 1)
        
        FirebaseApp.configure()
//        let homeViewController = HomeViewController()
//        let navController = UINavigationController(rootViewController: homeViewController)
//
//        let iconImageView = UIImage(named: "SctLogo")
//        let iconButton = UIButton(type: .system)
//        iconButton.setImage(iconImageView, for: .normal)
//        iconButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//        navController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: iconButton)
     
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

