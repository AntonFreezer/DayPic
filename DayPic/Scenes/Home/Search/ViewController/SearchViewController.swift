//
//  SearchViewController.swift
//  DayPic
//
//  Created by Anton Kholodkov on 21.02.2024.
//

import UIKit
import Combine

final class SearchViewController: GenericViewController<SearchView> {
    
    //MARK: - Properties
    private typealias DataSource = UITableViewDiffableDataSource<SearchViewModel.Section, Picture>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<SearchViewModel.Section, Picture>
    
    private var dataSource: DataSource!
    
    //MARK: - IO
    private let viewModel: SearchViewModel
    
    private var output: AnyPublisher<SearchViewModel.Input, Never> {
        return subject.eraseToAnyPublisher()
    }
    private let subject = PassthroughSubject<SearchViewModel.Input, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Lifecycle & Setup
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bindViewModel()
        
        subject.send(.viewDidLoad)
    }
    
    private func setupView() {
        
//        rootView.viewModel = self.viewModel
        rootView.tableView.delegate = self
        rootView.backgroundColor = .black
    }
    
    private func bindViewModel() {
        viewModel.transform(input: output).sink { [unowned self] event in
            switch event {
            case .didLoadPictures:
                self.applyShapshot()
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
    
}

//MARK: - UICollectionViewDiffableDataSource && Snapshot
private extension SearchViewController {
    func configureDataSource() {
        
        dataSource = DataSource
        
        dataSource = DataSource(tableView: rootView.tableView, cellProvider: { (collectionView, indexPath, picture) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCollectionViewCell.cellIdentifier, for: indexPath) as? PictureCollectionViewCell
            
            cell?.configure(with: PictureCollectionViewCellViewModel(
                pictureTitle: picture.title,
                pictureImageURL: URL(string: picture.imageURL))
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
extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let picture = dataSource.itemIdentifier(for: indexPath) else { return }
        
        subject.send(.didSelectPicture(picture: picture))
        // coordinator logic
        // coordinator.didSelectPicture(picture)
    }
    
}

//MARK: - CollectionView Delegate FlowLayout & Supplementary Views
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
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

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
////        guard viewModel.shouldShowMoreIndicator else {
////            return .zero
////        }
//        // footer for the last section
//        guard section == collectionView.numberOfSections - 1 else {
//            return CGSize()
//        }
//
//        return CGSize(width: collectionView.frame.width, height: 100)
//    }
//}

//MARK: - ScrollView Delegate & Pagination
extension SearchViewController: UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
        guard elementKind == UICollectionView.elementKindSectionFooter//,
                //              !viewModel.isLoadingCharacters,
                //              viewModel.shouldShowMoreIndicator
        else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            //            if let nextURL = self?.viewModel.currentResponseInfo?.next,
            //               let url = URL(string: nextURL) {
            //                  self?.viewModel.fetchPictures(url)
            
            // if there is nothing to fetch
            view.removeFromSuperview()
            self?.rootView.collectionView.scrollToLastItem()
        }
        
    }
}


//
////MARK: - Navigation
//
//extension SearchViewController {
//
//    func didSelectPicture(_ picture: Picture) {
//        let viewModel = PictureDetailViewModel(picture: picture)
//        let pictureDetailViewController = PictureDetailViewController(viewModel: viewModel)
//        pictureDetailViewController.navigationItem.largeTitleDisplayMode = .never
//
//        navigationController?.pushViewController(pictureDetailViewController, animated: true)
//    }
//
//}

