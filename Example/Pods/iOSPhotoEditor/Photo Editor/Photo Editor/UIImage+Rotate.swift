//
//  UIImage+Rotate.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 5/2/17.
//  Copyright © 2017 Mohamed Hamed. All rights reserved.
//

import UIKit

public extension UIImage {
    
    func rotateImageIfNeeded() -> UIImage
    {
        if size.width > size.height { // Landscape
            return self.rotateImage(orientation: .right)
        } else { //Portrait
            return self
        }
    }
    
    func rotateImage(orientation: UIImageOrientation) -> UIImage {
        let rotatedImage = UIImage(cgImage:self.cgImage!,
                                   scale: 1,
                                   orientation:orientation);
        return rotatedImage
    }
}
