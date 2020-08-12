//
//  AppDelegate.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/11/20.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let contactsViewController = ContactsViewController()
        let navigationController = UINavigationController(rootViewController: contactsViewController)
        
        navigationController.navigationBar.barTintColor = .myBlackColor
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        self.window = window
        
        return true
    }
    
}

