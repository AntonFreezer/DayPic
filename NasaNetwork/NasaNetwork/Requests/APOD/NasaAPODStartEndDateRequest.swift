//
//  NasaAPODStartEndDateRequest.swift
//  NasaNetwork
//
//  Created by Anton Kholodkov on 23.02.2024.
//

import Foundation

public struct NasaAPODStartEndDateRequest: NasaNetworkRequest {
    public typealias Response = [NasaPictureEntity]
    
    public var url: String {
        "/planetary/apod"
    }
    
    public init(startDate: String, endDate: String? = nil) {
        parameters["start_date"] = startDate
        
        if let endDate {
            parameters["end_date"] = endDate
        }
    }
    
    public var method: NasaHTTPMethod {
        .GET
    }
    
    public var parameters = [String : Any]()
}

