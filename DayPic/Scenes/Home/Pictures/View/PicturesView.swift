//
//  PicturesView.swift
//  DayPic
//
//  Created by Anton Kholodkov on 15.02.2024.
//

import UIKit

protocol PicturesViewRendering: BasicViewModelType {
    func createPictureOfTheDaySectionLayout() -> NSCollectionLayoutSection
    func createPicturesListLayout() -> NSCollectionLayoutSection
}

final class PicturesView: UIView {
    
    //MARK: - Properties
    var viewModel: (any PicturesViewRendering)?
    
    //MARK: - UI Components
    private(set) var collectionView: UICollectionView!
    
    //MARK: - Lifecycle & Setup
    init() {
        super.init(frame: .zero)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    private func setupView() {
        self.collectionView = createCollectionView()
        addSubview(collectionView!)
    }
    
    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.leading.equalTo(safeAreaLayoutGuide).inset(10)
        }
    }
    
    //MARK: - Collection View
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            return self?.createSection(for: sectionIndex)
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(PictureCollectionViewCell.self, forCellWithReuseIdentifier: PictureCollectionViewCell.cellIdentifier)
        collectionView.register(SectionFooterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SectionFooterCollectionReusableView.identifier)
                
        return collectionView
    }
    
    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection? {
        let sectionTypes = PicturesViewModel.Section.allCases
        
        switch sectionTypes[sectionIndex] {
        case .pictureOfTheDay:
            return viewModel?.createPictureOfTheDaySectionLayout()
        case .picturesList:
            return viewModel?.createPicturesListLayout()
        }
    }
    
}


