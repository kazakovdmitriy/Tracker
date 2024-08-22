//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Дмитрий on 21.08.2024.
//

import Foundation
import YandexMobileMetrica

enum AnalyticsEvent: String {
    case open
    case close
    case click
}

enum Screens: String {
    case Main
}

enum Buttons: String {
    case add_track
    case track
    case filter
    case edit
    case delete
    case none
}

final class AnalyticsService {
    
    static let shared = AnalyticsService()
    
    private init() {}
    
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "266154fe-a2ce-435f-906c-2644e6cfd0ff") else { return }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func openEvent(screen: Screens) {
        report(event: .open, screen: screen)
    }
    
    func closeEvent(screen: Screens) {
        report(event: .close, screen: screen)
    }
    
    func clickEvent(screen: Screens, button: Buttons) {
        report(event: .click, screen: screen, item: button)
    }
    
    private func report(event: AnalyticsEvent,
                        screen: Screens,
                        item: Buttons = .none) {
        var params = ["screen": screen.rawValue]
        
        if item != .none {
            params["item"] = item.rawValue
        }
        
        print("Event: \(event.rawValue), Screen: \(screen.rawValue), Item: \(item.rawValue)")
        
        YMMYandexMetrica.reportEvent(event.rawValue,
                                     parameters: params,
                                     onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
