//
//  SearchView.swift
//  DayPic
//
//  Created by Anton Kholodkov on 21.02.2024.
//

import UIKit
import SnapKit

final class SearchView: UIView {
    
    // MARK: - UI Components
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
    
        searchBar.barStyle = .black
        searchBar.barTintColor = .clear
        searchBar.searchTextField.font = .systemFont(ofSize: 20)
        searchBar.placeholder = String(localized: "Search for...")
        
        return searchBar
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumLineSpacing = 15
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear

        collectionView.register(PictureCollectionViewCell.self, forCellWithReuseIdentifier: PictureCollectionViewCell.cellIdentifier)
        collectionView.register(SectionFooterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SectionFooterCollectionReusableView.identifier)
        
        return collectionView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        addSubviews(searchBar, collectionView)
    }
    
    private func setupLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

