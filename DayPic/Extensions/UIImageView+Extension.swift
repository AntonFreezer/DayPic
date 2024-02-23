//
//  UIImageView+Extension.swift
//  DayPic
//
//  Created by Anton Kholodkov on 16.02.2024.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with url: URL, cornerRadius: CGFloat = 16) {
        DispatchQueue.main.async {
            let size = self.bounds.size
            let resize = ResizingImageProcessor(referenceSize: size, mode: .aspectFill)
            let crop = CroppingImageProcessor(size: size)
            let round = RoundCornerImageProcessor(cornerRadius: cornerRadius)
            
            let processor = ((resize |> crop) |> round)
            
            self.kf.indicatorType = .activity
            self.kf.setImage(
                with: url,
                placeholder: UIImage(named: "DefaultImagePlaceholder"),
                options: [
                    .processor(processor),
                    .cacheSerializer(FormatIndicatedCacheSerializer.png),
                    .scaleFactor(self.window?.windowScene?.screen.scale ?? .leastNonzeroMagnitude),
                    .transition(.fade(1)),
                    .cacheMemoryOnly
                ]
            )
        }
    }
    
}
