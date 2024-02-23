//
//  NasaPictureEntity.swift
//  NasaNetwork
//
//  Created by Anton Kholodkov on 22.02.2024.
//

import Foundation

public struct NasaPictureEntity: Decodable, Hashable {
    let date: String
    let explanation: String
    let title: String
    let url: String
}
