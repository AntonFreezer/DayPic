//
//  NavigationController.swift
//  DayPic
//
//  Created by Anton Kholodkov on 15.02.2024.
//

import UIKit

final class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure() {
        let standardAppearance = makeStandardBarAppearance()
        navigationBar.scrollEdgeAppearance = standardAppearance
        navigationBar.standardAppearance = standardAppearance
        
        navigationBar.isHidden = true
    }
    
    private func makeStandardBarAppearance() -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
        ]
        
        appearance.backButtonAppearance = makeStandardBackItemAppearance()
        let backItemImage = UIImage(systemName: "chevron.left.circle.fill")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        appearance.setBackIndicatorImage(backItemImage, transitionMaskImage: backItemImage)
        
        return appearance
    }
    
    private func makeStandardBackItemAppearance() -> UIBarButtonItemAppearance {
        let backItemAppearance = UIBarButtonItemAppearance()
        
        backItemAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.white,
        ]
        
        return backItemAppearance
    }
}
