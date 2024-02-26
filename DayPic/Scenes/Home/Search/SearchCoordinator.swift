//
//  SearchCoordinator.swift
//  DayPic
//
//  Created by Anton Kholodkov on 15.02.2024.
//

import UIKit

final class SearchCoordinator<R: Routable> {
    let router: R

    init(router: R) {
        self.router = router
    }

    private lazy var primaryViewController: UIViewController = {
        let viewModel = SearchViewModel(router: router,
                                        networkService: DIContainer.shared.nasaLibraryService)
        let viewController = SearchViewController(viewModel: viewModel)
        return viewController
    }()
}

extension SearchCoordinator: Coordinator {
    func start() {
        router.navigationController.pushViewController(primaryViewController, animated: true)
    }
}
