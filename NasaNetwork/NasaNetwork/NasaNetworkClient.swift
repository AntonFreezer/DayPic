//
//  NasaNetworkClient.swift
//  NasaNetwork
//
//  Created by Anton Kholodkov on 22.02.2024.
//

import Foundation

public protocol NasaNetworkClient {
    func sendRequest<Request>(request: Request) async -> Result<Request.Response, NasaNetworkError> where Request: NasaNetworkRequest
}
