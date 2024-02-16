//
//  PicturesViewModel.swift
//  DayPic
//
//  Created by Anton Kholodkov on 15.02.2024.
//

import UIKit
import Combine

final class PicturesViewModel: NSObject, ViewModelType {
    typealias Router = PicturesRouter
    
    //MARK: - Properties
    private(set) var router: any Router
    
    enum Section {
        case PictureOfTheDay
        case PicturesList
    }
    
    private(set) var isLoadingCharacters = false
    
    private(set) var pictureOfTheDay: [Picture] = []
    private(set) var pictures: [Picture] = []
    
    //MARK: - IO
    enum Input {
        case viewDidLoad
        case onScrollPaginated(url: URL)
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
            case .onScrollPaginated(let url):
                //                fetchPictures(url: url)
                subject.send(.didLoadPictures)
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
        self.pictureOfTheDay = [
            Picture(
                title: "Moon1",
                imageURL: "https://images-assets.nasa.gov/image/iss017e011436/iss017e011436~thumb.jpg")
        ]
        self.pictures = [
            Picture(
                title: "Moon2",
                imageURL: "https://images-assets.nasa.gov/image/iss014e08916/iss014e08916~thumb.jpg"),
            Picture(
                title: "Moon3",
                imageURL: "https://images-assets.nasa.gov/image/PIA25626/PIA25626~thumb.jpg"),
            Picture(
                title: "Moon4",
                imageURL: "https://images-assets.nasa.gov/image/S69-39333/S69-39333~thumb.jpg"),
            Picture(
                title: "Moon5",
                imageURL: "https://images-assets.nasa.gov/image/as11-40-5868/as11-40-5868~thumb.jpg"),
        ]
        
        
        DispatchQueue.main.async {
            self.subject.send(.didLoadPictures)
        }
    }
    
    //    public func fetchFirstPictures() {
    //        APIService.shared.execute(.allPicturesRequest, expecting: GetAllPicturessResponse.self) { [weak self] result in
    //            guard let self = self else { return }
    //
    //            switch result {
    //
    //            case .failure(let error):
    //                print(String(describing: error))
    //
    //            case.success(let responseModel):
    //                let results = responseModel.results
    //                let info = responseModel.info
    //
    //                self.pictures = results
    //                self.currentResponseInfo = info
    //
    //                DispatchQueue.main.async {
    //                    self.subject.send(.didLoadPictures)
    //                }
    //            }
    //        }
    //    }
    //
    //    /// General fetching from API
    //    public func fetchPictures(url: URL) {
    //        guard !isLoadingCharacters,
    //              shouldShowMoreIndicator
    //        else { return }
    //
    //        isLoadingCharacters = true
    //
    //        guard let request = APIRequest(url: url) else {
    //            isLoadingCharacters = false
    //            return
    //        }
    //
    //        APIService.shared.execute(request, expecting: GetAllCharactersResponse.self) { [weak self] result in
    //            guard let self = self else { return }
    //
    //            switch result {
    //
    //            case .failure(let error):
    //                self.isLoadingCharacters = false
    //                print(String(describing: error))
    //
    //            case.success(let responseModel):
    //                let results = responseModel.results
    //                let info = responseModel.info
    //                self.currentResponseInfo = info
    //                self.characters.append(contentsOf: results)
    //
    //                DispatchQueue.main.async {
    //                    self.subject.send(.didLoadCharacters)
    //                    self.isLoadingCharacters = false
    //                }
    //            }
    //        }
    //    }
}


