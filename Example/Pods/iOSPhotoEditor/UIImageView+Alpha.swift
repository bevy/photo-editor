//
//  UIImageView+Alpha.swift
//  Pods
//
//  Created by Mohamed Hamed on 5/9/17.
//
//

import Foundation

extension UIImageView {
    
    // See: http://stackoverflow.com/questions/27923232/how-to-know-that-if-the-only-visible-area-of-a-png-is-touched-in-xcode-swift-o?rq=1
    func alphaAtPoint(_ point: CGPoint) -> CGFloat {
        
        var pixel: [UInt8] = [0, 0, 0, 0]
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        let alphaInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        
        guard let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: alphaInfo) else {
            return 0
        }
        
        context.translateBy(x: -point.x, y: -point.y);
        
        layer.render(in: context)
        
        let floatAlpha = CGFloat(pixel[3])
        
        return floatAlpha
    }
    
}
