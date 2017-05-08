//
//  ViewGestures.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 4/24/17.
//  Copyright © 2017 Mohamed Hamed. All rights reserved.
//

import UIKit


extension PhotoEditorViewController : UIGestureRecognizerDelegate  {
    //Translation is moving object
    
    
    func panGesture(_ recognizer: UIPanGestureRecognizer) {
        if let view = recognizer.view {
            hideToolbar(hide: true)
            deleteView.isHidden = false
            //
            view.superview?.bringSubview(toFront: view)
            let point = recognizer.location(in: self.view)
            view.center = point
            recognizer.setTranslation(CGPoint.zero, in: self.view)
            
            if let previousPoint = lastPanPoint {
                //View is going into deleteView
                if deleteView.frame.contains(point) && !deleteView.frame.contains(previousPoint) {
                    if #available(iOS 10.0, *) {
                        let generator = UIImpactFeedbackGenerator(style: .heavy)
                        generator.impactOccurred()
                    }
                    UIView.animate(withDuration: 0.3, animations: {
                        view.transform = view.transform.scaledBy(x: 0.25, y: 0.25)
                        view.center = point
                    })
                }
                    //View is going out of deleteView
                else if deleteView.frame.contains(previousPoint) && !deleteView.frame.contains(point) {
                    //Scale to original Size
                    UIView.animate(withDuration: 0.3, animations: {
                        view.transform = view.transform.scaledBy(x: 4, y: 4)
                        view.center = point
                    })
                }
            }
            lastPanPoint = point
            
            if recognizer.state == .ended {
                lastPanPoint = nil
                hideToolbar(hide: false)
                deleteView.isHidden = true
                let point = recognizer.location(in: self.view)
                if deleteView.frame.contains(point) {
                    view.removeFromSuperview()
                    if #available(iOS 10.0, *) {
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)
                    }
                }
            }
        }
    }
    
    func pinchGesture(_ recognizer: UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            if view is UITextView {
                let textView = view as! UITextView
                let font = UIFont(name: textView.font!.fontName, size: textView.font!.pointSize * recognizer.scale)
                textView.font = font
                
                let sizeToFit = textView.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width,
                                                             height:CGFloat.greatestFiniteMagnitude))
                
                textView.bounds.size = CGSize(width: textView.intrinsicContentSize.width,
                                              height: sizeToFit.height)

                textView.setNeedsDisplay()
            } else {
                view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            }
            recognizer.scale = 1
        }
    }
    
    func rotationGesture(_ recognizer: UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }
    
    func tapGesture(_ recognizer: UITapGestureRecognizer) {
        if let view = recognizer.view {
            view.superview?.bringSubview(toFront: view)
            if #available(iOS 10.0, *) {
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
            }
            let previouTransform =  view.transform
            UIView.animate(withDuration: 0.2,
                           animations: {
                            view.transform = view.transform.scaledBy(x: 1.2, y: 1.2)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.2) {
                                view.transform  = previouTransform
                            }
            })
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            if !bottomSheetIsVisible {
                addBottomSheetView()
            }
        }
    }
    
    
    // to Override Control Center screen edge pan from bottom
    override public var prefersStatusBarHidden: Bool {
        return true
    }
    
}
