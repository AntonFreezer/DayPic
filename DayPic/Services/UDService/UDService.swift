//
//  UDService.swift
//  DayPic
//
//  Created by Anton Kholodkov on 15.02.2024.
//

import Foundation

struct UDService {
    static let ud = UserDefaults.standard
    enum UDCases: String {
        case onboarding = "onboardingCompleted"
    }
    
    static func isOnboardingCompleted() -> Bool {
        ud.bool(forKey: UDCases.onboarding.rawValue)
        
        // temporarily defaults to true
        return true
    }
    
    static func onboardingCompleted() {
        ud.set(true, forKey: UDCases.onboarding.rawValue)
    }
    
}
