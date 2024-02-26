//
//  Router.swift
//  DayPic
//
//  Created by Anton Kholodkov on 15.02.2024.
//

import UIKit

protocol Routable: AnyObject {
    associatedtype Route
    var navigationController: NavigationController { get set }
    @discardableResult func resetToRoot(animated: Bool) -> Self
    func exit()
    func process(route: Route)
}

extension Routable {
    /// Default implementation where current flow's router pops to root view controller
    /// - Parameter animated: should animate?
    /// - Returns: discardable instance of flow's router
    func resetToRoot(animated: Bool) -> Self {
        navigationController.popToRootViewController(animated: animated)
        return self
    }
}

protocol AppRouter: Routable where Route == AppTransition { }
protocol PicturesRouter: Routable where Route == PicturesTransition { }
protocol SearchRouter: Routable where Route == SearchTransition { }

