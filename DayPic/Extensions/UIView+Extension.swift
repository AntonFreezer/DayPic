//
//  UIView+Extension.swift
//  DayPic
//
//  Created by Anton Kholodkov on 19.02.2024.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }
}
