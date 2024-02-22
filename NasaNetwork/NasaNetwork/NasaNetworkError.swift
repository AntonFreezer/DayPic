//
//  NasaNetworkError.swift
//  NasaNetwork
//
//  Created by Anton Kholodkov on 22.02.2024.
//

import Foundation

public enum NasaNetworkError: Error {
    case invalidDecoding
    case invalidURL
    case failedRequest
}
