//
//  PictureCollectionViewCell.swift
//  DayPic
//
//  Created by Anton Kholodkov on 15.02.2024.
//

import UIKit

final class PictureCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    static var cellIdentifier: String {
        return String(describing: PictureCollectionViewCell.self)
    }
    
    //MARK: - UI Components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    //MARK: - Lifecycle & Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.backgroundColor = .clear
        contentView.addSubviews(imageView, titleLabel)
    }
    
    private func setupLayout() {
        // imageView
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // nameLabel
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(imageView).inset(16)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.titleLabel.text = nil
    }
    
    //MARK: - PictureCollectionViewCell ViewModel
    
    public func configure(with viewModel: PictureCollectionViewCellViewModel) {
        // imageView
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let url):
                self?.imageView.setImage(with: url)
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
        
        // nameLabel
        titleLabel.text = viewModel.pictureTitle
        
    }
}

