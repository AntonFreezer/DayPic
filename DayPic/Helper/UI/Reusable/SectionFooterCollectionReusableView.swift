//
//  SectionFooterCollectionReusableView.swift
//  DayPic
//
//  Created by Anton Kholodkov on 15.02.2024.
//

import UIKit

final class SectionFooterCollectionReusableView: UICollectionReusableView {
    
    let loadingView = LoadingView()
    
    static var identifier: String {
        return String(describing: SectionFooterCollectionReusableView.self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
}

extension SectionFooterCollectionReusableView: Loadable {
    func showLoading() {
        loadingView.spinner.startAnimating()
        addSubview(loadingView)
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        loadingView.backgroundColor = backgroundColor
    }
    
    func hideLoading() {
        loadingView.spinner.stopAnimating()
        loadingView.removeFromSuperview()
    }
    
    
}


