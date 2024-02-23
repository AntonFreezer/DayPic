//
//  NasaAPODRequest.swift
//  NasaNetwork
//
//  Created by Anton Kholodkov on 22.02.2024.
//

import Foundation

public struct NasaAPODRequest: NasaNetworkRequest {
    public typealias Response = NasaPictureEntity
    
    public var url: String {
        "/planetary/apod"
    }
    
    public init(date: String? = nil) {
        parameters["date"] = date
    }
    
    public var method: NasaHTTPMethod {
        .GET
    }
    
    public var parameters = [String : Any]()
}
