//
//  PictureRepresentable.swift
//  DayPic
//
//  Created by Anton Kholodkov on 26.02.2024.
//

import Foundation
import NasaNetwork

protocol PictureRepresentable {
    var date: String { get }
    var title: String { get }
    var description: String { get }
    var imageURL: String { get }
}

extension NasaPictureEntity: PictureRepresentable {
    var description: String {
        return explanation
    }

    var imageURL: String {
        return url
    }
}

extension NasaLibraryItem: PictureRepresentable {
    var date: String {
        return data.first?.dateCreated ?? ""
    }
    
    var title: String {
        return data.first?.title ?? ""
    }

    var description: String {
        return data.first?.description ?? ""
    }

    var imageURL: String {
        guard let url = links.first?.href else { return "" }
        return url.absoluteString
    }
}

