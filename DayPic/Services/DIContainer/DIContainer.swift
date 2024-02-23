//
//  DIContainer.swift
//  DayPic
//
//  Created by Anton Kholodkov on 23.02.2024.
//

import Foundation
import NasaNetwork

final class DIContainer {
    static let shared = DIContainer()
    
    let networkService: NasaNetworkClient
    
    init() {
        self.networkService = DefaultNasaNetworkClient(
            baseURL: "https://api.nasa.gov",
            apiKey: "VYw1dDPTVePJfhc2fb71lXZWJZIk5f3wgSxV9JXu")
    }
}
