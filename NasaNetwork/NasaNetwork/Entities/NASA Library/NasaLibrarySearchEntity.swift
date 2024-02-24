//
//  NasaLibraryEntity.swift
//  NasaNetwork
//
//  Created by Anton Kholodkov on 24.02.2024.
//

import Foundation

import Foundation

// MARK: - SearchResponse
public struct NasaLibrarySearchEntity: Decodable {
    public let collection: NasaLibraryCollection
}

// MARK: - Collection
public struct NasaLibraryCollection: Decodable {
    public let items: [NasaLibraryItem]
    public let links: [NasaLibraryLink]
}

// MARK: - Item
public struct NasaLibraryItem: Decodable, Hashable, Equatable {
    public let data: [NasaLibraryData]
    public let links: [NasaLibraryLink]
}

// MARK: - Data
public struct NasaLibraryData: Decodable, Hashable, Equatable {
    public let description: String
    public let keywords: [String]?
    public let mediaType: String
    public let nasaId: String
    public let title: String
}

// MARK: - Link
public struct NasaLibraryLink: Decodable, Hashable, Equatable {
    public let href: URL
    public let rel: String
}
