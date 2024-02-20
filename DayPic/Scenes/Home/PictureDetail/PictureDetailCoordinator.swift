//
//  PictureDetailCoordinator.swift
//  DayPic
//
//  Created by Anton Kholodkov on 19.02.2024.
//

import UIKit

final class PictureDetailCoordinator<R: PicturesRouter> {
    let picture: Picture
    let router: R

    init(picture: Picture, router: R) {
        self.picture = picture
        self.router = router
    }

    private lazy var primaryViewController: UIViewController = {
        let viewModel = PictureDetailViewModel(picture: picture, router: router)
        let viewController = PictureDetailViewController(viewModel: viewModel)
        
        return viewController
    }()
}

extension PictureDetailCoordinator: Coordinator {
    func start() {
        router.navigationController.pushViewController(primaryViewController, animated: true)
    }
}
