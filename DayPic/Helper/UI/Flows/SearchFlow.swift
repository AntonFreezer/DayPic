//
//  SearchFlow.swift
//  DayPic
//
//  Created by Anton Kholodkov on 21.02.2024.
//

import UIKit

final class SearchFlow<R: AppRouter>: NavigationFlow {
    let router: R
    var navigationController = NavigationController()

    init(router: R) {
        self.router = router
    }
}

extension SearchFlow: Coordinator {
    func start() {
        process(route: .initialScreen)
    }
}

extension SearchFlow: SearchRouter {

    func exit() {
        router.exit()
    }

    func process(route: SearchTransition) {
        let coordinator = route.coordinatorFor(router: self)

        coordinator.start()

        print(route.identifier)
    }
    
}

