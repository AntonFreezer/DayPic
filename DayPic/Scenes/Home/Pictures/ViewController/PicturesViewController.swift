//
//  PicturesViewController.swift
//  DayPic
//
//  Created by Anton Kholodkov on 15.02.2024.
//

import UIKit
import Combine
import NasaNetwork

final class PicturesViewController: GenericViewController<PicturesView> {
    
    //MARK: - Properties
    private typealias DataSource = UICollectionViewDiffableDataSource<PicturesViewModel.Section, NasaPictureEntity>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<PicturesViewModel.Section, NasaPictureEntity>
    
    private var dataSource: DataSource!
    
    //MARK: - IO
    private let viewModel: PicturesViewModel
    
    private var output: AnyPublisher<PicturesViewModel.Input, Never> {
        return subject.eraseToAnyPublisher()
    }
    private let subject = PassthroughSubject<PicturesViewModel.Input, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Lifecycle & Setup
    init(viewModel: PicturesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoading()
        
        configureDataSource()
        setupView()
        bindViewModel()
        
        subject.send(.viewDidLoad)
    }
    
    private func setupView() {
        self.showLoading()
        rootView.viewModel = self.viewModel
        rootView.collectionView?.delegate = self
        rootView.backgroundColor = .black
    }
    
    private func bindViewModel() {
        viewModel.transform(input: output)
            .receive(on: RunLoop.main)
            .sink { [unowned self] event in
                self.hideLoading()
                
                switch event {
                case .didLoadPictures:
                    self.applyShapshot()
                case .didReceiveError(let error):
                    self.showError(error)
                }
            }.store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func showError(_ error: Error) {
        self.showError(
            String(localized: "Couldn't load pictures"),
            message: error.localizedDescription,
            actionTitle: String(localized: "Refresh"),
            action: { stub in
                stub.removeFromSuperview()
                self.showLoading()
                self.subject.send(.viewDidLoad)
            }
        )
    }
    
}

//MARK: - UICollectionViewDiffableDataSource && Snapshot
private extension PicturesViewController {
    func configureDataSource() {
        dataSource = DataSource(collectionView: rootView.collectionView, cellProvider: { (collectionView, indexPath, picture) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCollectionViewCell.cellIdentifier, for: indexPath) as? PictureCollectionViewCell
            
            cell?.configure(with: PictureCollectionViewCellViewModel(
                pictureTitle: picture.title,
                pictureImageURL: URL(string: picture.url))
            )
            
            return cell
        })
        
        setupSupplementaryViews()
    }
    
    func applyShapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.pictureOfTheDay, .picturesList])
        snapshot.appendItems(viewModel.pictureOfTheDay, toSection: .pictureOfTheDay)
        snapshot.appendItems(viewModel.pictures, toSection: .picturesList)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

//MARK: - CollectionView Delegate
extension PicturesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let picture = dataSource.itemIdentifier(for: indexPath) else { return }
        
        subject.send(.didSelectPicture(picture: picture))
    }
    
}

//MARK: - CollectionView Delegate FlowLayout & Supplementary Views
extension PicturesViewController: UICollectionViewDelegateFlowLayout {
    
    func setupSupplementaryViews() {
        // Footer
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionFooter else {
                return nil
            }
            
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionFooterCollectionReusableView.identifier, for: indexPath) as? SectionFooterCollectionReusableView
            
            footer?.showLoading()
            return footer
        }
    }
    
}

//MARK: - ScrollView Delegate & Pagination
extension PicturesViewController: UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
        guard elementKind == UICollectionView.elementKindSectionFooter,
                              !viewModel.isLoadingPictures,
                              viewModel.shouldShowMoreIndicator
        else { 
            self.rootView.collectionView.scrollToLastItem()
            return
        }
        
        subject.send(.onScrollPaginated)
    }
}

