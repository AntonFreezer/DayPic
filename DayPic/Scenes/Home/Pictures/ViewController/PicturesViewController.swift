//
//  PicturesViewController.swift
//  DayPic
//
//  Created by Anton Kholodkov on 15.02.2024.
//

import UIKit
import Combine

final class PicturesViewController: GenericViewController<PicturesView> {
    
    //MARK: - Properties
    private typealias DataSource = UICollectionViewDiffableDataSource<PicturesViewModel.Section, Picture>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<PicturesViewModel.Section, Picture>
    
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
        
        configureDataSource()
        setupView()
        bindViewModel()
        
        subject.send(.viewDidLoad)
    }
    
    private func setupView() {
        rootView.collectionView.delegate = self
        
        title = "Characters"
        rootView.backgroundColor = UIColor.black
    }
    
    private func bindViewModel() {
        viewModel.transform(input: output).sink { [unowned self] event in
            switch event {
            case .didLoadPictures:
                self.applyShapshot()
            }
        }.store(in: &cancellables)
    }
    
}

//MARK: - UICollectionViewDiffableDataSource && Snapshot
private extension PicturesViewController {
    func configureDataSource() {
        dataSource = DataSource(collectionView: rootView.collectionView, cellProvider: { (collectionView, indexPath, picture) -> UICollectionViewCell? in
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
        snapshot.appendSections([.PictureOfTheDay, .PicturesList])
        snapshot.appendItems(viewModel.pictureOfTheDay, toSection: .PictureOfTheDay)
        snapshot.appendItems(viewModel.pictures, toSection: .PicturesList)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

//MARK: - CollectionView Delegate
extension PicturesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        
        let width = (bounds.width-25) / 2
        let height = width * 1.35
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let picture = dataSource.itemIdentifier(for: indexPath) else { return }
        
        // coordinator logic
        // self.didSelectPicture(picture)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        guard viewModel.shouldShowMoreIndicator else {
//            return .zero
//        }
        
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

////MARK: - ScrollView Delegate & Pagination
//extension PicturesViewController: UIScrollViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
//
//        guard elementKind == UICollectionView.elementKindSectionFooter,
//              !viewModel.isLoadingCharacters,
//              viewModel.shouldShowMoreIndicator
//        else { return }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
//            if let nextURL = self?.viewModel.currentResponseInfo?.next,
//               let url = URL(string: nextURL) {
//                self?.viewModel.fetchCharacters(url: url)
//            }
//
//        }
//    }
//
//}
//
////MARK: - Navigation
//
//extension CharactersListViewController {
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