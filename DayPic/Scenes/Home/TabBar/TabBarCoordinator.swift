//
//  TabBarCoordinator.swift
//  DayPic
//
//  Created by Anton Kholodkov on 16.02.2024.
//

import UIKit

final class TabBarCoordinator<R: AppRouter>: NSObject, UITabBarControllerDelegate {
    let appRouter: R
    var defaultTabItem: TabBarItem?

    private lazy var tabBarController: UITabBarController = {
        let tabBar = UITabBarController()
        
        tabBar.tabBar.isTranslucent = false
        tabBar.tabBar.barStyle = .black
        
        return tabBar
    }()

    private lazy var picturesCoordinator: PicturesCoordinator = {
        let picturesRoute = PicturesFlow(router: appRouter)
        let coordinator = PicturesCoordinator(router: picturesRoute)
        coordinator.start()
        return coordinator
    }()

    private lazy var searchCoordinator: SearchCoordinator = {
        let searchRoute = SearchFlow(router: appRouter)
        let coordinator = SearchCoordinator(router: searchRoute)
        coordinator.start()
        return coordinator
    }()


    init(router: R, defaultTabItem: TabBarItem? = nil) {
        self.appRouter = router
        self.defaultTabItem = defaultTabItem
    }

    /// Creates a UITabBarItem from a given TabBarItem.
    /// - Parameter item: The TabBarItem to convert into a UITabBarItem.
    /// - Returns: A configured UITabBarItem.
    /// - Note: The `tag` property of the UITabBarItem is set to the index of the TabBarItem.
    private func tabBarItem(from item: TabBarItem) -> UITabBarItem {
        UITabBarItem(
            title: item.tabTitle,
            image: item.tabImage,
            tag: item.index
        )
    }

    /// Returns the appropriate view controller for a given TabBarItem.
    /// - Parameter transition: The TabBarItem to transition to.
    /// - Returns: A UIViewController corresponding to the TabBarItem.
    private func getTabController(for transition: TabBarItem) -> UIViewController {
        let navigationController: UINavigationController

        switch transition {
        case .pictures:
            navigationController = picturesCoordinator.router.navigationController
        case .search:
            navigationController = searchCoordinator.router.navigationController
        }

        navigationController.tabBarItem = tabBarItem(from: transition)
        return navigationController
    }

    /// Prepares and sets the main tab bar controller of the app.
    /// Sets the initial view controller if default tab is set
    /// - Parameter tabControllers: An array of view controllers to be set in the tab bar.
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.delegate = self
        tabBarController.setViewControllers(tabControllers, animated: false)

        if appRouter.navigationController.viewControllers.first !== tabBarController {
            appRouter.navigationController.viewControllers.removeAll()
            appRouter.navigationController.viewControllers = [tabBarController]
            
            if let defaultTabItem {
                tabBarController.selectedViewController = tabControllers[defaultTabItem.index]
            }
        }
        
    }
}

extension TabBarCoordinator: Coordinator {
    func start() {
        let transitions: [TabBarItem] = [.pictures(nil), .search(nil)]

        let controllers: [UIViewController] = transitions.map({ getTabController(for: $0) })
        prepareTabBarController(withTabControllers: controllers)
    }
}

