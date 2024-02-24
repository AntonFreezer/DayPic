//
//  SearchViewModel.swift
//  DayPic
//
//  Created by Anton Kholodkov on 21.02.2024.
//

import UIKit
import Combine
import NasaNetwork

final class SearchViewModel: NSObject, ViewModelType {
    typealias Router = SearchRouter
    
    //MARK: - Properties
    private(set) var router: any Router
    private let networkService: NasaNetworkClient
    
    enum Section: CaseIterable {
        case searchList
    }
    
    private var currentPrompt: String?
    
    private(set) var isLoadingPictures = false
    private(set) var pictures: [NasaLibraryItem] = []
    private(set) var currentResponseInfo: [NasaLibraryLink]? = nil
    public var nextPageInfo: NasaLibraryLink? {
        currentResponseInfo?.first(where: { link in
            link.rel == "next"
        })
    }
    
    //MARK: - IO
    enum Input {
        case viewIsAppearing
        case didEnterSearchPrompt(prompt: String)
        case onScrollPaginated(url: URL)
        case didSelectPicture(picture: NasaLibraryItem)
    }
    
    enum Output {
        case didLoadPictures
        case didReceiveError(error: Error)
    }
    
    var output: AnyPublisher<Output, Never> {
        return subject.eraseToAnyPublisher()
    }
    private let subject = PassthroughSubject<Output, Never>()
    
    var cancellables = Set<AnyCancellable>()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [unowned self] event in
            switch event {
            case .viewIsAppearing:
                retrySearch()
                subject.send(.didLoadPictures)
            case .didEnterSearchPrompt(let prompt):
                fetchPictures(with: prompt)
                subject.send(.didLoadPictures)
            case .onScrollPaginated(let url):
                fetchPictures(with: url)
                subject.send(.didLoadPictures)
            case .didSelectPicture(let picture):
                router.process(route: .detailScreen(picture: picture)) // different routers problem
            }
        }.store(in: &cancellables)
        
        return output
    }
    
    //MARK: - Setup && Lifecycle
    init(router: any Router,
         networkService: NasaNetworkClient) {
        self.router = router
        self.networkService = networkService
    }
    
    //MARK: - Network
    private func search(query: String) {
        currentPrompt = query
        fetchPictures(with: query)
    }

    private func retrySearch() {
        guard let currentPrompt else { return }
        fetchPictures(with: currentPrompt)
    }
    
    private func fetchPictures(with prompt: String) {
        isLoadingPictures = true
        
        Task {
            let result = await networkService.sendRequest(
                request: NasaLibraryPictureRequest(query: prompt))
            
            switch result {
            case .success(let response):
                currentResponseInfo = response.collection.links
                pictures = response.collection.items
                subject.send(.didLoadPictures)
            case .failure(let error):
                subject.send(.didReceiveError(error: error))
            }
        }
        
        isLoadingPictures = false
    }
    
    private func fetchPictures(with url: URL) {
        isLoadingPictures = true
        
        Task {
            guard let nextPageInfo else {
                isLoadingPictures = false
                return
            }
            let url = nextPageInfo.href.absoluteString
            
            let result = await networkService.sendRequest(
                request: NasaLibraryPictureRequest(
                    url: url))
            
            switch result {
            case .success(let response):
                currentResponseInfo = response.collection.links
                pictures.append(contentsOf: response.collection.items)
                subject.send(.didLoadPictures)
            case .failure(let error):
                subject.send(.didReceiveError(error: error))
            }
            
            isLoadingPictures = false
        }
    }
    
    

}


