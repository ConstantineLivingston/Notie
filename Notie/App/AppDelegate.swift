//
//  AppDelegate.swift
//  Notie
//
//  Created by Konstantin Bratchenko on 21.11.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().tintColor = .black
        CoreDataManager.shared.load()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        CoreDataManager.shared.saveContext()
    }
}

