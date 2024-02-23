//
//  NasaPictureEntity.swift
//  NasaNetwork
//
//  Created by Anton Kholodkov on 22.02.2024.
//

import Foundation

public struct NasaPictureEntity: Decodable, Hashable {
    public let date: String
    public let explanation: String
    public let title: String
    public let url: String
}
