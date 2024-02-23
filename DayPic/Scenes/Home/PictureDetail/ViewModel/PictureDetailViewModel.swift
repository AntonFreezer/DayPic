//
//  PictureDetailViewModel.swift
//  DayPic
//
//  Created by Anton Kholodkov on 19.02.2024.
//

import UIKit
import Combine
import NasaNetwork

final class PictureDetailViewModel: NSObject, ViewModelType {
    typealias Router = PicturesRouter
    
    //MARK: - Properties
    private(set) var router: any Router
        
    private let picture: NasaPictureEntity
    
    public var pictureTitle: String {
        picture.title
    }
    
    public var pictureExplanation: String {
        picture.explanation
    }
    
    private var pictureImageURL: URL? {
        URL(string: picture.url)
    }
    
    //MARK: - IO
    enum Input { }
    enum Output { }
    
    var output: AnyPublisher<Output, Never> {
        return subject.eraseToAnyPublisher()
    }
    private let subject = PassthroughSubject<Output, Never>()
    var cancellables = Set<AnyCancellable>()
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        return output
    }
    
    //MARK: - Setup && Lifecycle
    init(picture: NasaPictureEntity, router: any Router) {
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
