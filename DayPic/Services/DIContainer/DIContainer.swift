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
    
    let nasaAPODNetworkService: NasaNetworkClient
    let nasaLibraryService: NasaNetworkClient
    
    init() {
        self.nasaAPODNetworkService = DefaultNasaNetworkClient(
            baseURL: "https://api.nasa.gov",
            apiKey: ProcessInfo.processInfo.environment["NASA_API_KEY"] ?? "")

        
        self.nasaLibraryService = DefaultNasaNetworkClient(
            baseURL: "https://images-api.nasa.gov")
        
    }
}
