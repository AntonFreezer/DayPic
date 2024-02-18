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
    
    enum Section: CaseIterable {
        case pictureOfTheDay
        case picturesList
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
            Picture(
                title: "Moon6",
                imageURL: "https://images-assets.nasa.gov/image/as11-40-5868/as11-40-5868~thumb.jpg"),
            Picture(
                title: "Moon7",
                imageURL: "https://images-assets.nasa.gov/image/as11-40-5868/as11-40-5868~thumb.jpg"),
            Picture(
                title: "Moon8",
                imageURL: "https://images-assets.nasa.gov/image/as11-40-5868/as11-40-5868~thumb.jpg"),
            Picture(
                title: "Moon9",
                imageURL: "https://images-assets.nasa.gov/image/as11-40-5868/as11-40-5868~thumb.jpg"),
            Picture(
                title: "Moon10",
                imageURL: "https://images-assets.nasa.gov/image/as11-40-5868/as11-40-5868~thumb.jpg"),
        ]
        
        
        DispatchQueue.main.async {
            self.subject.send(.didLoadPictures)
        }
    }

}

//MARK: - CollectionView Rendering
extension PicturesViewModel: PicturesViewRendering {

    private func createDefaultItemInsets() -> NSDirectionalEdgeInsets {
        .init(top: 5, leading: 5, bottom: 5, trailing: 5)
    }
    
    private func createSectionFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),                                                      heightDimension: .absolute(100.0))
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: footerSize,
                        elementKind: UICollectionView.elementKindSectionFooter,
                        alignment: .bottom)
            
        return footer
    }
    
    func createPictureOfTheDaySectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = createDefaultItemInsets()
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(248)),
            subitems: [item]
        )
                
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func createPicturesListLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = createDefaultItemInsets()
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.5)
            ),
            subitems: [item]
        )
        
        let footer = createSectionFooter()
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [footer]
        return section
    }

}

