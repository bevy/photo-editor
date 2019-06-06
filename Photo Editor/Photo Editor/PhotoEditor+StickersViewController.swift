//
//  PhotoEditor+StickersViewController.swift
//  Pods
//
//  Created by Mohamed Hamed on 6/16/17.
//
//

import Foundation
import UIKit

extension PhotoEditorViewController {
    
    func addStickersViewController() {
        stickersVCIsVisible = true
        hideToolbar(hide: true)
        self.canvasImageView.isUserInteractionEnabled = false
        stickersViewController.stickersViewControllerDelegate = self
        
        for image in self.stickers {
            stickersViewController.stickers.append(image)
        }
        self.addChild(stickersViewController)
        self.view.addSubview(stickersViewController.view)
        stickersViewController.didMove(toParent: self)
        let height = view.frame.height
        let width  = view.frame.width
        stickersViewController.view.frame = CGRect(x: 0, y: self.view.frame.maxY , width: width, height: height)
    }
    
    func removeStickersView() {
        stickersVCIsVisible = false
        self.canvasImageView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        var frame = self.stickersViewController.view.frame
                        frame.origin.y = UIScreen.main.bounds.maxY
                        self.stickersViewController.view.frame = frame
                        
        }, completion: { (finished) -> Void in
            self.stickersViewController.view.removeFromSuperview()
            self.stickersViewController.removeFromParent()
            self.hideToolbar(hide: false)
        })
    }    
}

extension PhotoEditorViewController: StickersViewControllerDelegate, UIScrollViewDelegate {
    
    func didSelectView(view: UIView) {
        self.removeStickersView()
        view.center = CGPoint(x:canvasImageView.frame.width / 2, y: canvasImageView.frame.height / 2)
        self.canvasImageView.addSubview(view)
        addGestures(view: view)
        let pinchGesture = UIPinchGestureRecognizer(target: self,
                                                    action: #selector(PhotoEditorViewController.pinchGestureDidFire(_:)))
        pinchGesture.delegate = self
        view.addGestureRecognizer(pinchGesture)
    }
    
    @objc func pinchGestureDidFire(_ pinch: UIPinchGestureRecognizer) {
        let pinchView = pinch.view!
        let bounds = pinchView.bounds
        var pinchCenter = pinch.location(in: canvasImageView)
        pinchCenter.x = pinchCenter.x - bounds.midX
        pinchCenter.y = pinchCenter.y - bounds.midY
        var transform = pinchView.transform
        let scale = pinch.scale;
        transform = transform.scaledBy(x: scale, y: scale)
        //        transform = transform.translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
        pinchView.transform = transform
        pinch.scale = 1.0
    }
    
    
    
    func didSelectImage(image: UIImage) {
        self.removeStickersView()
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame.size = CGSize(width: 150, height: 150)
        imageView.center = CGPoint(x:canvasImageView.frame.width / 2, y: canvasImageView.frame.height / 2)
        
        self.canvasImageView.addSubview(imageView)
        //Gestures
        addGestures(view: imageView)
    }
    
    func stickersViewDidDisappear() {
        stickersVCIsVisible = false
        hideToolbar(hide: false)
    }
    
    func addGestures(view: UIView) {
        //Gestures
        view.isUserInteractionEnabled = true
        
        
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(PhotoEditorViewController.panGesture))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        
//        let pinchGesture = UIPinchGestureRecognizer(target: self,
//                                                    action: #selector(PhotoEditorViewController.panGesture(_:)))
//        pinchGesture.delegate = self
//        view.addGestureRecognizer(pinchGesture)
        
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self,
                                                                    action:#selector(PhotoEditorViewController.rotationGesture(_:)))
        rotationGestureRecognizer.delegate = self
        view.addGestureRecognizer(rotationGestureRecognizer)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PhotoEditorViewController.tapGesture(_:)))
        view.addGestureRecognizer(tapGesture)
        
    }
}
