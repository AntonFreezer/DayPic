//
//  Configurable.swift
//  DayPic
//
//  Created by Anton Kholodkov on 15.02.2024.
//

import UIKit

protocol Configurable: UIView {
    associatedtype Model
    
    func update(with model: Model?)
}
