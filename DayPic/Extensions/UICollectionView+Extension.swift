//
//  UICollectionView+Extension.swift
//  DayPic
//
//  Created by Anton Kholodkov on 18.02.2024.
//

import UIKit

extension UICollectionView {
    func scrollToLastItem() {
        let section = self.numberOfSections - 1
        let item = self.numberOfItems(inSection: section) - 1
        let lastIndexPath = IndexPath(item: item, section: section)
        if section >= 0 && item >= 0 {
            self.scrollToItem(at: lastIndexPath, at: .bottom, animated: true)
        }
    }
}
