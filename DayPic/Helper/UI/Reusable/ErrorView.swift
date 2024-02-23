//
//  ErrorView.swift
//  DayPic
//
//  Created by Anton Kholodkov on 15.02.2024.
//

import UIKit

final class ErrorView: CustomView {
    
    //MARK: - Properties
    var title: String = "" {
        didSet {
            titleLabel.update(
                with: .init(
                    text: title,
                    font: .boldSystemFont(ofSize: 16),
                    textColor: .white,
                    numberOfLines: 2,
                    alignment: .center
                )
            )
        }
    }
    
    var message: String? {
        didSet {
            messageLabel.update(
                with: .init(
                    text: message ?? "",
                    font: .italicSystemFont(ofSize: 14),
                    textColor: .white,
                    numberOfLines: 3,
                    alignment: .center
                )
            )
            messageLabel.isHidden = message == nil
        }
    }
    
    var actionTitle: String? {
        didSet {
            actionButton.setTitle(actionTitle, for: .normal)
        }
    }
    
    var action: ((UIView) -> Void)? {
        didSet {
            actionButton.isHidden = action == nil
        }
    }
    
    //MARK: - UI Components
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let actionButton = UIButton(type: .system)
    
    
    //MARK: - Setup & Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        addSubviews(titleLabel, messageLabel, actionButton)
    
        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .darkGray
        configuration.baseForegroundColor = .white
        configuration.titleAlignment = .center
        configuration.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
        actionButton.configuration = configuration
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
        }
    }
    
    //MARK: - Button Actions
    @objc private func didTapActionButton() {
        action?(self)
    }
}
