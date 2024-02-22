//
//  NasaNetworkRequest.swift
//  NasaNetwork
//
//  Created by Anton Kholodkov on 22.02.2024.
//

import Foundation

public enum NasaHTTPMethod: String {
    case GET
}

public protocol NasaNetworkRequest {
    associatedtype Response: Decodable
    
    var url: String { get }
    var method: NasaHTTPMethod { get }
    var parameters: [String: Any] { get }
}
