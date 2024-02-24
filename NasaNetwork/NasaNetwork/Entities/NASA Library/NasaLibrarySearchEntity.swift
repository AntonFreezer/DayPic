//
//  NasaLibraryEntity.swift
//  NasaNetwork
//
//  Created by Anton Kholodkov on 24.02.2024.
//

import Foundation

import Foundation

// MARK: - SearchResponse
struct SearchResponse: Decodable {
    let collection: Collection
}

// MARK: - Collection
struct Collection: Decodable {
    let version: String
    let href: URL
    let items: [Item]
    let links: [Link]
}

// MARK: - Item
struct Item: Decodable {
    let href: URL
    let data: [Data]
    let links: [Link]
}

// MARK: - Data
struct Data: Decodable {
    let center: String
    let dateCreated: Date
    let description: String
    let description508: String?
    let keywords: [String]?
    let mediaType: String
    let nasaId: String
    let secondaryCreator: String?
    let title: String
}

// MARK: - Link
struct Link: Decodable {
    let href: URL
    let rel: String
    let render: String?
}
