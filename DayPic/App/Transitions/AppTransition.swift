//
//  AppTransition.swift
//  DayPic
//
//  Created by Anton Kholodkov on 16.02.2024.
//

import UIKit

enum AppTransition {
//    case showOnboarding
    case showMainView(TabBarItem)

    var identifier: String { "\(self)" }

    func coordinatorFor<R: AppRouter>(router: R) -> Coordinator {
        switch self {
//        case .showOnboarding:
//            return OnboardingCoordinator(router: router)
        case .showMainView(let tabItem):
            return TabBarCoordinator(router: router, defaultTabItem: tabItem)
        }
    }
}
