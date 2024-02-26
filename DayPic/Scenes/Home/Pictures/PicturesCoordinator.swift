//
//  PicturesCoordinator.swift
//  DayPic
//
//  Created by Anton Kholodkov on 15.02.2024.
//

import UIKit

final class PicturesCoordinator<R: Routable> {
    let router: R

    init(router: R) {
        self.router = router
    }

    private lazy var primaryViewController: UIViewController = {
        let viewModel = PicturesViewModel(
            router: router,
            networkService: DIContainer.shared.nasaAPODNetworkService)
        let viewController = PicturesViewController(viewModel: viewModel)
        return viewController
    }()
}

extension PicturesCoordinator: Coordinator {
    func start() {
        router.navigationController.pushViewController(primaryViewController, animated: true)
    }
}
