//
//  NasaNetworkError.swift
//  NasaNetwork
//
//  Created by Anton Kholodkov on 22.02.2024.
//

import Foundation

public enum NasaNetworkError: Error {
    case invalidURL
    case invalidApiKey
    case invalidDecoding
    case invalidErrorDecoding
    case failedRequest
    case resourceNotFound
    case networkError(NasaNetworkErrorEntity?, URLError?)
}

public struct NasaNetworkErrorEntity: Decodable {
    let code: Int
    let msg: String
}
