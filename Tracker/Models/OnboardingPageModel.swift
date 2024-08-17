//
//  OnboardingPageModel.swift
//  Tracker
//
//  Created by Дмитрий on 17.08.2024.
//

import UIKit

enum OnboardingPageModel {
    case first
    case second
    
    var image: UIImage {
        switch self {
        case .first:
            return UIImage(named: "onboarding_first_bg") ?? UIImage()
        case .second:
            return UIImage(named: "onboarding_second_bg") ?? UIImage()
        }
    }
    
    var text: String {
        switch self {
        case .first:
            return Strings.Onboarding.first
        case .second:
            return Strings.Onboarding.second
        }
    }
}
