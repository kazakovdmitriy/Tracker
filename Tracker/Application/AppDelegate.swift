//
//  AppDelegate.swift
//  Tracker
//
//  Created by Дмитрий on 20.06.2024.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        DaysValueTransformer.register()
        
        window = UIWindow()
//        window?.rootViewController = TabBarController()
        window?.rootViewController = OnboardingViewController(transitionStyle: .scroll,
                                                              navigationOrientation: .horizontal)
        window?.makeKeyAndVisible()
        
        return true
    }
}
