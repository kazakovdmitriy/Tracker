//
//  LaunchViewController.swift
//  Tracker
//
//  Created by Дмитрий on 13.08.2024.
//

import UIKit

final class SplashViewController: BaseController {
    private lazy var imageLogo: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "launch_screen_logo")
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        return imageView
        
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "isOnboardingHidden") {
            print("TabBar")
            switchToTabBar()
        } else {
            print("Onboarding")
            switchToOnboarding()
        }
    }
    
    private func switchToOnboarding() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let onboardingVC = OnboardingViewController(transitionStyle: .scroll,
                                                    navigationOrientation: .horizontal)
        
        window.rootViewController = onboardingVC
    }
    
    private func switchToTabBar() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = TabBarController()
        
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    
    override func setupViews() {
        super.setupViews()
        
        view.setupView(imageLogo)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            imageLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageLogo.heightAnchor.constraint(equalToConstant: 94),
            imageLogo.widthAnchor.constraint(equalToConstant: 91)
        ])
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        view.backgroundColor = .ypBlue
    }
}
