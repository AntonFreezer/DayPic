//
//  PicturesTransition.swift
//  DayPic
//
//  Created by Anton Kholodkov on 16.02.2024.
//

import Foundation

enum PicturesTransition {
    case initialScreen
    case detailScreen(picture: Picture)

    var identifier: String { "\(self)" }

    func coordinatorFor<R: PicturesRouter>(router: R) -> Coordinator {
        switch self {
        case .initialScreen:
            return PicturesCoordinator(router: router)
        case .detailScreen(let picture):
            return PictureDetailCoordinator(picture: picture, router: router)
        }
    }
}

