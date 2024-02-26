//
//  PicturesViewModel.swift
//  DayPic
//
//  Created by Anton Kholodkov on 15.02.2024.
//

import UIKit
import Combine
import NasaNetwork

final class PicturesViewModel: NSObject, IOViewModelType {
    
    //MARK: - Properties
    typealias Router = PicturesRouter
    private(set) var router: any Router
    private let networkService: NasaNetworkClient
    
    enum Section: CaseIterable {
        case pictureOfTheDay
        case picturesList
    }
    
    private(set) var isLoadingPictures = false
    private(set) var pictureOfTheDay: [NasaPictureEntity] = []
    private(set) var pictures: [NasaPictureEntity] = []
    
    private let apodDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    private var currentEarliestPictureDate: Date? = nil
    private var earliestPossiblePictureDate: Date {
        apodDateFormatter.date(from: "1995-06-16")!
    }
    
    public var shouldShowMoreIndicator: Bool {
        guard let currentEarliestPictureDate else { return false }
        return currentEarliestPictureDate >= earliestPossiblePictureDate
    }
    
    private let subject = PassthroughSubject<Output, Never>()
    var output: AnyPublisher<Output, Never> {
        return subject.eraseToAnyPublisher()
    }
    
    var cancellables = Set<AnyCancellable>()
    
    //MARK: - Setup && Lifecycle
    init(router: any Router, networkService: NasaNetworkClient) {
        self.router = router
        self.networkService = networkService
    }
    
    
    //MARK: - IO
    enum Input {
        case viewDidLoad
        case onScrollPaginated
        case didSelectPicture(picture: NasaPictureEntity)
    }
    
    enum Output {
        case didLoadPictures
        case didReceiveError(Error)
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [unowned self] event in
            switch event {
            case .viewDidLoad:
                fetchFirstAndSubsequentPictures()
            case .onScrollPaginated:
                fetchSubsequentPictures(fromDate: currentEarliestPictureDate,
                                        amount: 10)
                subject.send(.didLoadPictures)
            case .didSelectPicture(let picture):
                router.process(route: .detailScreen(picture: picture))
            }
        }.store(in: &cancellables)
        
        return output
    }
    
}
//MARK: - Network
extension PicturesViewModel {
    private func fetchFirstAndSubsequentPictures() {
        isLoadingPictures = true
        Task {
            try await Task.sleep(until: .now + .seconds(0.85), clock: .continuous)
            let result = await networkService.sendRequest(request: NasaAPODRequest())
            switch result {
            case .success(let response):
                pictureOfTheDay = [response]
                currentEarliestPictureDate = apodDateFormatter.date(from: response.date)
                fetchSubsequentPictures(fromDate: currentEarliestPictureDate!, amount: 10)
            case .failure(let error):
                subject.send(.didReceiveError(error))
            }
        }
    }
    
    private func fetchSubsequentPictures(fromDate date: Date?, amount: Int) {
        isLoadingPictures = true
        
        guard let date,
              let startDate = Calendar.current.date(
                byAdding: .day, value: -amount,
                to: date),
              startDate > earliestPossiblePictureDate else { return }
        
        currentEarliestPictureDate = startDate
        
        let endDate = Calendar.current.date(
            byAdding: .day, value: -1,
            to: date) ?? startDate
        
        let startDateString = apodDateFormatter.string(from: startDate)
        let endDateString = apodDateFormatter.string(from: endDate)
        
        Task {
            let result = await networkService.sendRequest(
                request: NasaAPODStartEndDateRequest(startDate: startDateString,
                                                     endDate: endDateString))
            switch result {
            case .success(let response):
                self.pictures.append(contentsOf: response.sorted(by: { $0.date > $1.date }))
                subject.send(.didLoadPictures)
            case .failure(let error):
                subject.send(.didReceiveError(error))
            }
        }
        
        isLoadingPictures = false
    }
    
}

//MARK: - CollectionView Rendering
extension PicturesViewModel: PicturesViewRendering {
    
    private func createDefaultEdgeInsets() -> NSDirectionalEdgeInsets {
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
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(248)),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = createDefaultEdgeInsets()
        
        return section
    }
    
    func createPicturesListLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = createDefaultEdgeInsets()
        
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

