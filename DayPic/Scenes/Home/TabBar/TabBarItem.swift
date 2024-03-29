//
//  TabBarItem.swift
//  DayPic
//
//  Created by Anton Kholodkov on 16.02.2024.
//

import UIKit

enum TabBarItem {
    case pictures(PicturesTransition?)
    case search(SearchTransition?)

    var tabTitle: String {
        switch self {
        case .pictures:
            return String(localized: "Picture of the day")
        case .search:
            return String(localized: "Search")
        }
    }

    var index: Int {
        switch self {
        case .pictures:
            return 0
        case .search:
            return 1
        }
    }

    var tabImage: UIImage? {
        switch self {
        case .pictures:
            let configuration = UIImage.SymbolConfiguration(hierarchicalColor: .white)
            return UIImage(systemName: "photo.on.rectangle.angled",
                           withConfiguration: configuration)
        case .search:
            let configuration = UIImage.SymbolConfiguration(hierarchicalColor: .white)
            return UIImage(systemName: "magnifyingglass",
            withConfiguration: configuration)
        }
    }
}

