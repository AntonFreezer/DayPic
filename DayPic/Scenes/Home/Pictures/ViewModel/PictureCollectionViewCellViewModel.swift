//
//  PictureCollectionViewCellViewModel.swift
//  DayPic
//
//  Created by Anton Kholodkov on 15.02.2024.
//

import Foundation

final class PictureCollectionViewCellViewModel {
    
    //MARK: - Properties
    public let pictureTitle: String
    private var pictureImageURL: URL?
    
    
    //MARK: - Lifecycle && Setup
    init(pictureTitle: String, pictureImageURL: URL?) {
        self.pictureTitle = pictureTitle
        self.pictureImageURL = pictureImageURL
    }
    
    //MARK: - Network
    public func fetchImage(completion: @escaping (Result<URL, Error>) -> Void) {
        guard let url = pictureImageURL else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        completion(.success(url))
    }
}

//MARK: - Hashable & Equatable
extension PictureCollectionViewCellViewModel: Hashable, Equatable {
    static func == (lhs: PictureCollectionViewCellViewModel, rhs: PictureCollectionViewCellViewModel) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(pictureTitle)
        hasher.combine(pictureImageURL)
    }
    
}
