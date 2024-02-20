//
//  Picture.swift
//  DayPic
//
//  Created by Anton Kholodkov on 15.02.2024.
//

import Foundation

public struct Picture: Decodable, Hashable {
    let title: String
    let imageURL: String
    let description: String
}
