//
//  PictureDetailViewModel.swift
//  DayPic
//
//  Created by Anton Kholodkov on 19.02.2024.
//

import UIKit
import Combine
import NasaNetwork

final class PictureDetailViewModel: NSObject, BasicViewModelType {
    
    //MARK: - Properties
    typealias Router = Routable
    private(set) var router: any Router
    
    private let picture: PictureRepresentable
    
    public var pictureTitle: String {
        picture.title
    }
    
    public var pictureDescription: String {
        picture.description
    }
    
    private var pictureImageURL: URL? {
        URL(string: picture.imageURL)
    }
    
    //MARK: - Setup && Lifecycle
    init(picture: PictureRepresentable, router: any Router) {
        self.picture = picture
        self.router = router
    }
}
    
//MARK: - Network
extension PictureDetailViewModel {
    public func fetchImage(completion: @escaping (Result<URL, Error>) -> Void) {
        guard let url = pictureImageURL else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        completion(.success(url))
    }
}
