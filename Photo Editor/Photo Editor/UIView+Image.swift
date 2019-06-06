//
//  UIView+Image.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 4/23/17.
//  Copyright © 2017 Mohamed Hamed. All rights reserved.
//

import UIKit

extension UIView {
    /**
     Convert UIView to UIImage
     */
    func toImage() -> UIImage {
        var areaBounds: CGRect? = nil
        if self.subviews.count > 0 {
            areaBounds = self.subviews[0].frame
        }
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let image = snapshotImageFromMyView, let rect = areaBounds else { return snapshotImageFromMyView! }
        
        // otherwise, grab specified `rect` of image
        
        let scale = image.scale
        let scaledRect = CGRect(x: rect.origin.x * scale, y: rect.origin.y * scale, width: rect.size.width * scale, height: rect.size.height * scale)
        guard let cgImage = image.cgImage?.cropping(to: scaledRect) else { return snapshotImageFromMyView! }
        return UIImage(cgImage: cgImage, scale: scale, orientation: .up)
        
//        return snapshotImageFromMyView!
        
    }
}
