//
//  SearchTransition.swift
//  DayPic
//
//  Created by Anton Kholodkov on 21.02.2024.
//

import Foundation

protocol Picture: Hashable, Equatable {
    var date: String { get }
    var description: String { get }
    var title: String { get }
    var url: String { get }
}

enum SearchTransition {
    case initialScreen
//    case detailScreen(picture: Picture)
    
    var identifier: String { "\(self)" }
    
    func coordinatorFor<R: SearchRouter>(router: R) -> Coordinator {
        switch self {
        case .initialScreen:
            return SearchCoordinator(router: router)
//        case .detailScreen(let picture):
//            return PictureDetailCoordinator(picture: picture, router: router) // routers are different
        }
    }
    
    
}
