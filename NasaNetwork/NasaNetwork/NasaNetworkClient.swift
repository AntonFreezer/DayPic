//
//  NasaNetworkClient.swift
//  NasaNetwork
//
//  Created by Anton Kholodkov on 22.02.2024.
//

import Foundation

public protocol NasaNetworkClient: Actor {
    func sendRequest<Request>(request: Request) async -> Result<Request.Response, NasaNetworkError> where Request: NasaNetworkRequest
}

public actor DefaultNasaNetworkClient: NasaNetworkClient {
    
    private let baseURL: String
    private var apiKey: String?
    
    public init(baseURL: String, apiKey: String? = nil) {
        self.baseURL = baseURL
        self.apiKey = apiKey
    }
    
    public func sendRequest<Request>(request: Request) async -> Result<Request.Response, NasaNetworkError> where Request : NasaNetworkRequest {
        
        let fullURL = request.url.starts(with: "http") ? request.url : baseURL + request.url
        guard var urlComponents = URLComponents(string: fullURL) else {
            return .failure(.invalidURL)
        }
        
        if urlComponents.queryItems == nil {
            urlComponents.queryItems = []
        }
        
        if let apiKey {
            urlComponents.queryItems?.append(URLQueryItem(
                name: "api_key",
                value: self.apiKey))
        }
        
        if !request.parameters.isEmpty {
            var additionalQueryItems = request.parameters.compactMap { item -> URLQueryItem? in
                if let value = item.value as? String { // may be 'Any' -> 'nil' from protocol definition
                    return URLQueryItem(name: item.key, value: value)
                } else {
                    return nil
                }
            }
            
            request.parameters.forEach { item in
                if let value = item.value as? [String] { // multiple values
                    additionalQueryItems.append(contentsOf: value.map {
                        .init(name: item.key, value: $0)
                    })
                }
            }
            
            urlComponents.queryItems?.append(contentsOf: additionalQueryItems)
        }
        
        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.failedRequest)
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            switch response.statusCode {
            case 200...299:
                guard let decoded = try? decoder.decode(Request.Response.self, from: data) 
                else {
                    return .failure(.invalidDecoding)
                }
                return .success(decoded)
                
            case 401, 403:
                return .failure(.invalidApiKey)
                
            default:
                guard let decoded = try? decoder.decode(NasaNetworkErrorEntity.self, from: data) 
                else {
                    return .failure(.invalidErrorDecoding)
                }
                
                return .failure(.networkError(decoded, nil))
            }
            
        } catch {
            return .failure(.networkError(nil, error as? URLError))
        }
    }
    
}
