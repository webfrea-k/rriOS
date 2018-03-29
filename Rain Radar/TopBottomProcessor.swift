//
//  TopBottomProcessor.swift
//  Rain Radar
//
//  Created by Simon Hočevar on 29/03/2018.
//  Copyright © 2018 Simon Hočevar. All rights reserved.
//

import Foundation
import Kingfisher

struct TopBottomProcessor: ImageProcessor {
    // `identifier` should be the same for processors with same properties/functionality
    // It will be used when storing and retrieving the image to/from cache.
    let identifier = "si.webfreak.topbottomprocessor"
    
    // Convert input data/image to target image and return it.
    func process(item: ImageProcessItem, options: KingfisherOptionsInfo) -> Image? {
        switch item {
        case .image(let image):
            let imageSize = image.size
            let scale: CGFloat = 0
            UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
            image.draw(at: CGPoint(x: 0.0, y: 0.0))
            let rectangleTop = CGRect(x: 0, y: 0, width: (imageSize.width), height: 50)
            let rectangleBottom = CGRect(x: 0, y: (imageSize.height)-50, width: (imageSize.width), height: 50)
            UIColor.clear.setFill()
            UIRectFill(rectangleTop)
            UIRectFill(rectangleBottom)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        case .data(_):
            return (DefaultImageProcessor.default >> self).process(item: item, options: options)
        }
}
}
