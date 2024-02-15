//
//  GenericViewController.swift
//  DayPic
//
//  Created by Anton Kholodkov on 15.02.2024.
//

import UIKit

class GenericViewController<T: UIView>: UIViewController {
    
    //MARK: - Properties
    let loadingView = LoadingView()
    let errorView = ErrorView()
    
    public var rootView: T { return view as! T }
    
    //MARK: - Lifecycle && Setup
    override public func loadView() {
        self.view = T()
    }
    
}

//MARK: - Loadable
extension GenericViewController: Loadable {
    func showLoading() {
        loadingView.spinner.startAnimating()
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        loadingView.backgroundColor = view.backgroundColor
    }
    
    func hideLoading() {
        loadingView.spinner.stopAnimating()
        loadingView.removeFromSuperview()
    }
}

//MARK: - ErrorPresentable
extension GenericViewController: ErrorPresentable {
    func showError(
        _ title: String,
        message: String?,
        actionTitle: String?,
        action: ((UIView) -> Void)?
    ) {
        errorView.title = title
        errorView.message = message
        errorView.actionTitle = actionTitle
        errorView.action = action
        
        view.addSubview(errorView)
        errorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        errorView.backgroundColor = view.backgroundColor
    }
    
    func hideError() {
        errorView.removeFromSuperview()
    }
}
