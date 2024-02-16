//
//  PicturesFlow.swift
//  DayPic
//
//  Created by Anton Kholodkov on 16.02.2024.
//

import UIKit

final class PicturesFlow<R: AppRouter>: NavigationFlow {
    let router: R
    var navigationController = NavigationController()

    init(router: R) {
        self.router = router
    }
}

extension PicturesFlow: Coordinator {
    func start() {
        process(route: .initialScreen)
    }
}

extension PicturesFlow: PicturesRouter {

    func exit() {
        router.exit()
    }

    func process(route: PicturesTransition) {
        let coordinator = route.coordinatorFor(router: self)

        coordinator.start()

        print(route.identifier)
    }
    
}
