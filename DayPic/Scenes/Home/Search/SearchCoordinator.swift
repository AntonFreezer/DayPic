//
//  SearchCoordinator.swift
//  DayPic
//
//  Created by Anton Kholodkov on 15.02.2024.
//

import UIKit

final class SearchCoordinator<R: SearchRouter> {
    let router: R

    init(router: R) {
        self.router = router
    }

    private lazy var primaryViewController: UIViewController = {
        let viewModel = SearchViewModel(router: router)
        let viewController = SearchViewController(viewModel: viewModel)
        return viewController
    }()
}

extension SearchCoordinator: Coordinator {
    func start() {
        router.navigationController.pushViewController(primaryViewController, animated: true)
    }
}
