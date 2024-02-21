//
//  Router.swift
//  DayPic
//
//  Created by Anton Kholodkov on 15.02.2024.
//

import UIKit

protocol Router: AnyObject {
    associatedtype Route
    var navigationController: NavigationController { get set }
    @discardableResult func resetToRoot(animated: Bool) -> Self
    func exit()
    func process(route: Route)
}

extension Router {
    /// Default implementation where current flow's router pops to root view controller
    /// - Parameter animated: should animate?
    /// - Returns: discardable instance of flow's router
    func resetToRoot(animated: Bool) -> Self {
        navigationController.popToRootViewController(animated: animated)
        return self
    }
}

protocol AppRouter: Router where Route == AppTransition { }
protocol PicturesRouter: Router where Route == PicturesTransition { }
protocol SearchRouter: Router where Route == SearchTransition { }

