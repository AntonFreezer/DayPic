//
//  PictureDetailView.swift
//  DayPic
//
//  Created by Anton Kholodkov on 19.02.2024.
//

import UIKit

final class PictureDetailView: UIView {
    
    //MARK: - Properties
    var viewModel: PictureDetailViewModel
    
    //MARK: - UI Components
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        
        scrollView.automaticallyAdjustsScrollIndicatorInsets = true
        scrollView.contentInsetAdjustmentBehavior = .never
        
        return scrollView
    }()
    
    let pictureImageContainer: UIView = {
        let view = UIView(frame: .zero)
        
        view.backgroundColor = .clear
        
        return view
    }()
    
    let pictureImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let pictureTextElementsContainer: UIView = {
        let view = UIView(frame: .zero)
        
        view.backgroundColor = .clear
        
        return view
    }()
    
    let pictureTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        
        return label
    }()
    
    let pictureDescriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        
        label.numberOfLines = 0
        label.backgroundColor = .black
        label.font = .systemFont(ofSize: 30, weight: .regular)
        label.textColor = .white
        
        return label
    }()
        
    //MARK: - Lifecycle & Setup
    init(viewModel: PictureDetailViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        setupView()
        setupLayout()
        populateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    private func setupView() {
        self.addSubviews(scrollView)
        
        scrollView.addSubviews(pictureImageContainer,
                         pictureTextElementsContainer)
        
        pictureImageContainer.addSubviews(pictureImageView)
        
        pictureTextElementsContainer.addSubviews(pictureTitleLabel,
                                                 pictureDescriptionLabel)
        
    }
    
    private func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pictureImageContainer.snp.makeConstraints { make in
            make.top.equalTo(scrollView)
            make.left.right.equalTo(self)
            make.height.equalTo(pictureImageContainer.snp.width).multipliedBy(0.75)
        }
        
        pictureImageView.snp.makeConstraints { make in
            make.top.equalTo(self).priority(.high)
            make.left.right.equalTo(pictureImageContainer)
            make.height.greaterThanOrEqualTo(pictureImageContainer.snp.height).priority(.required)
            make.bottom.equalTo(pictureImageContainer)
        }
        
        pictureTextElementsContainer.snp.makeConstraints { make in
            make.top.equalTo(pictureImageContainer.snp.bottom).offset(15)
            make.leading.trailing.equalTo(self)
            make.bottom.equalTo(scrollView)
        }
        
        pictureTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(pictureTextElementsContainer)
            make.leading.trailing.equalTo(pictureTextElementsContainer).inset(15)
        }
        
        pictureDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(pictureTitleLabel.snp.bottom)
            make.leading.trailing.bottom.equalTo(pictureTextElementsContainer).inset(15)
        }
    }
    
    private func populateUI() {
        // Image
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let url):
                self?.pictureImageView.setImage(with: url, cornerRadius: 0)
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
        // Title
        pictureTitleLabel.text = viewModel.pictureTitle
        // Description
        pictureDescriptionLabel.text = viewModel.pictureDescription
    }
    
}
