//
//  SearchViewController.swift
//  DayPic
//
//  Created by Anton Kholodkov on 21.02.2024.
//

import UIKit
import Combine
import NasaNetwork

final class SearchViewController: GenericViewController<SearchView> {
    
    //MARK: - Properties
    private typealias DataSource = UICollectionViewDiffableDataSource<SearchViewModel.Section, NasaLibraryItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<SearchViewModel.Section, NasaLibraryItem>
    
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
        
        configureDataSource()
        setupView()
        bindViewModel()
    }
    
    private func setupView() {
        rootView.collectionView.delegate = self
        rootView.backgroundColor = .black
        rootView.searchBar.searchTextField.becomeFirstResponder()
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
                    self.rootView.collectionView.scrollToLastItem()
                }
            }.store(in: &cancellables)
        
        bindToSearchTextField()
    }
    
    private func bindToSearchTextField() {
        rootView.searchBar.searchTextField.textPublisher
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [unowned self] prompt in
            subject.send(.didEnterSearchPrompt(prompt: prompt))
        }.store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        subject.send(.viewIsAppearing)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func showError(_ error: Error) {
        self.showError(
            String(localized: "Couldn't load pictures"),
            message: error.localizedDescription,
            actionTitle: String(localized: "OK"),
            action: { stub in
                stub.removeFromSuperview()
            }
        )
    }
}

//MARK: - UICollectionViewDiffableDataSource && Snapshot
private extension SearchViewController {
    func configureDataSource() {
        
        dataSource = DataSource(collectionView: rootView.collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCollectionViewCell.cellIdentifier, for: indexPath) as? PictureCollectionViewCell
            
            cell?.configure(with: PictureCollectionViewCellViewModel(
                pictureTitle: item.data.first?.title ?? "",
                pictureImageURL: item.links.first?.href)
            )
            
            return cell
        })
        
        setupSupplementaryViews()
    }
    
    func applyShapshot(animatingDifferences: Bool = true) {
            var snapshot = Snapshot()
            snapshot.appendSections([.searchList])
            snapshot.appendItems(viewModel.pictures, toSection: .searchList)
            dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

//MARK: - CollectionView Delegate
extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        
        let width = bounds.width
        let height = width * 0.6
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let picture = dataSource.itemIdentifier(for: indexPath) else { return }
        
        subject.send(.didSelectPicture(picture: picture))
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        guard !viewModel.isLoadingPictures,
              viewModel.nextPageInfo != nil else {
            return CGSize.zero
        }
        
        return CGSize(width: collectionView.bounds.width, height: 100)
    }

    
}

//MARK: - ScrollView Delegate & Pagination
extension SearchViewController: UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
        guard elementKind == UICollectionView.elementKindSectionFooter,
              !viewModel.isLoadingPictures,
              let nextPage = viewModel.nextPageInfo
        else {
            rootView.collectionView.scrollToLastItem()
            return
        }
        
        subject.send(.onScrollPaginated(url: nextPage.href))
    }
}

