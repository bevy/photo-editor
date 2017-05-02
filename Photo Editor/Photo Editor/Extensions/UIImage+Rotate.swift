//
//  UIImage+Rotate.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 5/2/17.
//  Copyright © 2017 Mohamed Hamed. All rights reserved.
//

import UIKit

public extension UIImage {
    
    func rotateImage()->UIImage
    {
        if size.width > size.height {
            var rotatedImage = UIImage();
            switch self.imageOrientation
            {
            case UIImageOrientation.right:
                rotatedImage = UIImage(cgImage:self.cgImage!, scale: 1,
                                       orientation:UIImageOrientation.down);
                
            case UIImageOrientation.down:
                rotatedImage = UIImage(cgImage:self.cgImage!, scale: 1,
                                       orientation:UIImageOrientation.left);
                
            case UIImageOrientation.left:
                rotatedImage = UIImage(cgImage:self.cgImage!, scale: 1,
                                       orientation:UIImageOrientation.up);
                
            default:
                rotatedImage = UIImage(cgImage:self.cgImage!, scale: 1,
                                       orientation:UIImageOrientation.right);
            }
            return rotatedImage;
        } else {
            return self
        }
    }
}
