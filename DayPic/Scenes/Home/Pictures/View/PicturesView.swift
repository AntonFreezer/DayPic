//
//  PicturesView.swift
//  DayPic
//
//  Created by Anton Kholodkov on 15.02.2024.
//

import UIKit

final class PicturesView: UIView {
    
    //MARK: - UI Components
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        let topInset: CGFloat = 50
        collectionView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = .clear
        
        collectionView.register(PictureCollectionViewCell.self, forCellWithReuseIdentifier: PictureCollectionViewCell.cellIdentifier)
        collectionView.register(SectionFooterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SectionFooterCollectionReusableView.identifier)
        
        return collectionView
    }()
    
    //MARK: - Lifecycle & Setup
    init() {
        super.init(frame: .zero)
        
        addSubview(collectionView)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
    
}


