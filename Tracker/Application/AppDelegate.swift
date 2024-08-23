//
//  AppDelegate.swift
//  Tracker
//
//  Created by Дмитрий on 20.06.2024.
//

import UIKit
import CoreData
import YandexMobileMetrica

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        DaysValueTransformer.register()
        TrackerCategoryStore.shared.checkAndCreatePinCategory()
        AnalyticsService.activate()
        
        UserDefaults.standard.set(0, forKey: UserDefaultsKeys.selectedFilter)
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", 
                                    sessionRole: connectingSceneSession.role)
    }
}
