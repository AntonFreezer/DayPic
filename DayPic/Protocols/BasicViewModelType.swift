//
//  BasicViewModelType.swift
//  DayPic
//
//  Created by Anton Kholodkov on 25.02.2024.
//

import Foundation

protocol BasicViewModelType {
    associatedtype Router
    var router: Router { get }
}
