//
//  ImageManager.swift
//  DayPic
//
//  Created by Anton Kholodkov on 15.02.2024.
//

import Kingfisher
import UIKit

class ImageManager {
    static var shared = ImageManager()
    
    private init() { }
    
    public func setImage(with url: URL,
                         for imageView: UIImageView?,
                         cornerRadius: Int = 20) {
        DispatchQueue.main.async {
            if let imageView {
                let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
                |> RoundCornerImageProcessor(cornerRadius: CGFloat(cornerRadius))
                
                imageView.kf.indicatorType = .activity
                imageView.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "DefaultImagePlaceholder"),
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ])
            }
            // completion handler
        }
        
    }
}
