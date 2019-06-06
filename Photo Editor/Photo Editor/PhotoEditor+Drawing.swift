//
//  PhotoEditor+Drawing.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 6/16/17.
//
//

import UIKit

extension PhotoEditorViewController {
    
    override public func touchesBegan(_ touches: Set<UITouch>,
                                      with event: UIEvent?){
        if isDrawing {
            
            swiped = false
            if let touch = touches.first {
                lastPoint = touch.location(in: self.canvasImageView)
            }
        }
            //Hide stickersVC if clicked outside it
        else if stickersVCIsVisible == true {
            if let touch = touches.first {
                let location = touch.location(in: self.view)
                if !stickersViewController.view.frame.contains(location) {
                    removeStickersView()
                }
            }
        }
        
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>,
                                      with event: UIEvent?){
        if isDrawing {
            // 6
            swiped = true
            if let touch = touches.first {
                let currentPoint = touch.location(in: canvasImageView)
                drawLineFrom(lastPoint, toPoint: currentPoint)
                
                // 7
                lastPoint = currentPoint
            }
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>,
                                      with event: UIEvent?){
        if isDrawing {
            
            if !swiped {
                // draw a single point
                //drawLineFrom(lastPoint, toPoint: lastPoint)
            }
            //canvasImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            
        }
        
    }
    
    func drawLineFrom(_ fromPoint: CGPoint, toPoint: CGPoint) {
        // 1
//        bezierPath.move(to: CGPoint(x:fromPoint.x, y:fromPoint.y))
//        bezierPath.addLine(to: CGPoint(x:toPoint.x, y:toPoint.y))
//
//        let shapeLayer = CAShapeLayer()
//
//        // The Bezier path that we made needs to be converted to
//        // a CGPath before it can be used on a layer.
//        shapeLayer.path = self.bezierPath.cgPath
//
//        // apply other properties related to the path
//        shapeLayer.strokeColor = drawColor.cgColor
//        //            shapeLayer.fillColor = UIColor.white.cgColor
//        shapeLayer.lineWidth = 5.0
//        //            shapeLayer.position = CGPoint(x: 10, y: 10)
//
//        // add the new layer to our custom view
//        self.canvasImageView.layer.addSublayer(shapeLayer)
        UIGraphicsBeginImageContextWithOptions(canvasImageView.frame.size, false, UIScreen.main.scale)
//        UIGraphicsBeginImageContext(canvasImageView.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            canvasImageView.image?.draw(in : CGRect(x: 0, y: 0, width: canvasImageView.frame.size.width, height: canvasImageView.frame.size.height))
            // 2
            context.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
            context.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
            // 3
            context.setLineCap( CGLineCap.round)
            context.setLineWidth(5.0)
            context.setStrokeColor(drawColor.cgColor)
            context.setBlendMode( CGBlendMode.normal)
            // 4
            context.strokePath()
            // 5
            canvasImageView.image = UIImage(cgImage: context.makeImage()!)
            UIGraphicsEndImageContext()
        }
    }
    
}
