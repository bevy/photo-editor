//
//  Pencil.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 4/26/17.
//  Copyright © 2017 Mohamed Hamed. All rights reserved.
//

import UIKit

extension ViewController {
    //MARK: Pencil
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?){
        if isDrawing {
            isSwiping    = false
            if let touch = touches.first{
                lastPoint = touch.location(in: imageView)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>,
                               with event: UIEvent?){
        if isDrawing {
            isSwiping = true;
            if let touch = touches.first{
                let currentPoint = touch.location(in: imageView)
                UIGraphicsBeginImageContext(self.imageView.frame.size)
                self.imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.imageView.frame.size.width, height: self.imageView.frame.size.height))
                UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
                UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: currentPoint.x, y: currentPoint.y))
                UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
                UIGraphicsGetCurrentContext()?.setLineWidth(5.0)
                UIGraphicsGetCurrentContext()?.setStrokeColor(UIColor.black.cgColor)
                UIGraphicsGetCurrentContext()?.strokePath()
                self.imageView.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                lastPoint = currentPoint
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?){
        if isDrawing {
            if(!isSwiping) {
                // This is a single touch, draw a point
                UIGraphicsBeginImageContext(self.imageView.frame.size)
                self.imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.imageView.frame.size.width, height: self.imageView.frame.size.height))
                UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
                UIGraphicsGetCurrentContext()?.setLineWidth(9.0)
                UIGraphicsGetCurrentContext()?.setStrokeColor(UIColor.black.cgColor)
                UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
                UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
                UIGraphicsGetCurrentContext()?.strokePath()
                self.imageView.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
        }
        
    }
}
