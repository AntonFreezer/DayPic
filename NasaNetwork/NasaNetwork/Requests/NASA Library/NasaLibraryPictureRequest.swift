//
//  NasaLibraryPictureRequest.swift
//  NasaNetwork
//
//  Created by Anton Kholodkov on 24.02.2024.
//

import Foundation

public struct NasaLibraryPictureRequest: NasaNetworkRequest {
    public typealias Response = NasaLibrarySearchEntity
    
    private var basePath: String = "/search"
    private var fullURL: String?
    
    public var url: String {
        fullURL ?? basePath
    }
    
    public init(url: String) {
        self.fullURL = url
        parameters = [:]
    }
    
    public init(query: String? = nil,
                startingWith page: Int? = 1,
                pageSize: Int? = 10) {
        parameters["q"] = query
        
        if let page {
            parameters["page"] = "\(page)"
        }
        if let pageSize {
            parameters["page_size"] = "\(pageSize)"
        }
    }
    
    public var method: NasaHTTPMethod {
        .GET
    }
    
    public var parameters: [String: Any] = {
        ["media_type": "image"]
    }()
}

