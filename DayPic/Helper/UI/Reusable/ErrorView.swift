//
//  ErrorView.swift
//  DayPic
//
//  Created by Anton Kholodkov on 15.02.2024.
//

import UIKit

final class ErrorView: CustomView {
    
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
                    numberOfLines: 3
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
    
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let actionButton = UIButton()
    private let textStack = UIStackView()
    
    override func configure() {
    
        addSubview(textStack)
        textStack.axis = .vertical
        textStack.alignment = .center
        textStack.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(messageLabel)
        
        addSubview(actionButton)
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .darkGray
        configuration.baseForegroundColor = .white
        configuration.titleAlignment = .center
        configuration.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
        actionButton.configuration = configuration
        actionButton.isHidden = true
        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        actionButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(textStack.snp.bottom).offset(16)
        }
    }
    
    @objc
    private func didTapActionButton() {
        action?(self)
    }
}

