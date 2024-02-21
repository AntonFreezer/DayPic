//
//  SearchViewModel.swift
//  DayPic
//
//  Created by Anton Kholodkov on 21.02.2024.
//

import UIKit
import Combine

final class SearchViewModel: NSObject, ViewModelType {
    typealias Router = SearchRouter
    
    //MARK: - Properties
    private(set) var router: any Router
    
    enum Section: CaseIterable {
        case searchList
    }
    
    private(set) var isLoadingCharacters = false
    private(set) var pictures: [Picture] = []
    
    //MARK: - IO
    enum Input {
        case viewDidLoad
        case didEnterSearchPrompt(prompt: String)
        case onScrollPaginated(url: URL)
        case didSelectPicture(picture: Picture)
    }
    
    enum Output {
        case didLoadPictures
    }
    
    var output: AnyPublisher<Output, Never> {
        return subject.eraseToAnyPublisher()
    }
    private let subject = PassthroughSubject<Output, Never>()
    
    var cancellables = Set<AnyCancellable>()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [unowned self] event in
            switch event {
            case .viewDidLoad:
                fetchFirstPictures()
                subject.send(.didLoadPictures)
            case .didEnterSearchPrompt(let prompt):
                fetchPictures(with: prompt)
                subject.send(.didLoadPictures)
            case .onScrollPaginated(let url):
                fetchPictures(with: url)
                subject.send(.didLoadPictures)
            case .didSelectPicture(let picture):
                break
//                router.process(route: .detailScreen(picture: picture)) // different routers problem
            }
        }.store(in: &cancellables)
        
        return output
    }
    
    // private(set) var currentResponseInfo: GetPicturesResponse.Info? = nil
    
    // public var shouldShowMoreIndicator: Bool {
    // return currentResponseInfo?.next != nil
    // }
    
    //MARK: - Setup && Lifecycle
    init(router: any Router) {
        self.router = router
    }
    
    //MARK: - Network
    public func fetchFirstPictures() {
        self.pictures = [
            Picture(
                title: "Moon2",
                imageURL: "https://images-assets.nasa.gov/image/iss014e08916/iss014e08916~thumb.jpg",
                description: String(repeating: "description", count: 999)),
            Picture(
                title: "Moon3",
                imageURL: "https://images-assets.nasa.gov/image/PIA25626/PIA25626~thumb.jpg",
                description: String(repeating: "description", count: 999)),
            Picture(
                title: "Moon4",
                imageURL: "https://images-assets.nasa.gov/image/S69-39333/S69-39333~thumb.jpg",
                description: String(repeating: "description ", count: 999)),
            Picture(
                title: "Astronaut Edwin Aldrin descends steps of Lunar Module ladder to walk on moon",
                imageURL: "https://images-assets.nasa.gov/image/as11-40-5868/as11-40-5868~thumb.jpg",
                description: String(repeating: "description ", count: 999)),
            Picture(
                title: "Moon6",
                imageURL: "https://images-assets.nasa.gov/image/as11-40-5868/as11-40-5868~thumb.jpg",
                description: "some description"),
            Picture(
                title: "Moon7",
                imageURL: "https://images-assets.nasa.gov/image/as11-40-5868/as11-40-5868~thumb.jpg",
                description: "some description"),
            Picture(
                title: "Moon8",
                imageURL: "https://images-assets.nasa.gov/image/as11-40-5868/as11-40-5868~thumb.jpg",
                description: "some description"),
            Picture(
                title: "Moon9",
                imageURL: "https://images-assets.nasa.gov/image/as11-40-5868/as11-40-5868~thumb.jpg",
                description: "some description"),
            Picture(
                title: "Moon10",
                imageURL: "https://images-assets.nasa.gov/image/as11-40-5868/as11-40-5868~thumb.jpg",
                description: "some description"),
        ]
        
        DispatchQueue.main.async {
            self.subject.send(.didLoadPictures)
        }
    }
    
    public func fetchPictures(with prompt: String) {
        self.pictures.append(contentsOf: [
            Picture(title: "Moon11",
                    imageURL: "https://images-assets.nasa.gov/image/as11-40-5868/as11-40-5868~thumb.jpg", description: ""),
            Picture(title: "Moon12",
                    imageURL: "https://images-assets.nasa.gov/image/as11-40-5868/as11-40-5868~thumb.jpg", description: ""),
            Picture(title: "Moon13",
                    imageURL: "https://images-assets.nasa.gov/image/as11-40-5868/as11-40-5868~thumb.jpg", description: ""),
        ])

        DispatchQueue.main.async {
            self.subject.send(.didLoadPictures)
        }
    }
    
    public func fetchPictures(with url: URL) {
        self.pictures.append(contentsOf: [
            Picture(title: "Moon11",
                    imageURL: "https://images-assets.nasa.gov/image/as11-40-5868/as11-40-5868~thumb.jpg", description: ""),
            Picture(title: "Moon12",
                    imageURL: "https://images-assets.nasa.gov/image/as11-40-5868/as11-40-5868~thumb.jpg", description: ""),
            Picture(title: "Moon13",
                    imageURL: "https://images-assets.nasa.gov/image/as11-40-5868/as11-40-5868~thumb.jpg", description: ""),
        ])

        DispatchQueue.main.async {
            self.subject.send(.didLoadPictures)
        }
    }

}


