//
//  PictureDetailViewController.swift
//  DayPic
//
//  Created by Anton Kholodkov on 19.02.2024.
//

import UIKit
import Combine

final class PictureDetailViewController: GenericViewController<PictureDetailView> {
    
    //MARK: - IO
    private let viewModel: PictureDetailViewModel
    
    private var output: AnyPublisher<PictureDetailViewModel.Input, Never> {
        return subject.eraseToAnyPublisher()
    }
    private let subject = PassthroughSubject<PictureDetailViewModel.Input, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Lifecycle & Setup
    init(viewModel: PictureDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    override func loadView() {
        self.view = PictureDetailView(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
//        bindViewModel()
        
//        subject.send(.viewDidLoad)
    }
    
    private func setupView() {
        rootView.scrollView.delegate = self
        rootView.viewModel = self.viewModel
        rootView.backgroundColor = .black
    }
    
//    private func bindViewModel() {
//        viewModel.transform(input: output).sink { [unowned self] event in
//            switch event {
//            case .didLoadPictures:
//                self.applyShapshot()
//            }
//        }.store(in: &cancellables)
//    }
    
}

extension PictureDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let statusBarHeight = (rootView.window?.windowScene?.statusBarManager?.statusBarFrame.height)!
        let navigationBarHeight = (navigationController?.navigationBar.bounds.height)!
        
        applyFadeToNavigationStatusBars()
        setNavigationBarTitle()
        
        func applyFadeToNavigationStatusBars() {
            let headerHeight = rootView.pictureImageContainer.bounds.height
            let headerTargetHeight = headerHeight - navigationBarHeight - statusBarHeight
            
            var headerOffset = scrollView.contentOffset.y / headerTargetHeight
            if headerOffset > 1 { headerOffset = 1 } // capping
            if headerOffset > 0.5 {
                self.navigationController?.navigationBar.barStyle = UIBarStyle.default
            } else {
                self.navigationController?.navigationBar.barStyle = UIBarStyle.black
            }
            
            let clearToBlack: UIColor = .black.withAlphaComponent(headerOffset)
            navigationController?.navigationBar.standardAppearance.backgroundColor = clearToBlack
        }
        
        func setNavigationBarTitle() {
            let pictureTitleTarget = scrollView.convert(
                rootView.pictureTextElementsContainer.frame.origin,
                to: rootView).y - navigationBarHeight - statusBarHeight
            
            if pictureTitleTarget <= 0  {
                navigationController?.navigationBar.topItem?.title = viewModel.pictureTitle
            } else {
                navigationController?.navigationBar.topItem?.title = ""
            }
        }
        
    }
}
