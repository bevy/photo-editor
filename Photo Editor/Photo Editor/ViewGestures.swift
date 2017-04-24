//
//  ViewGestures.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 4/24/17.
//  Copyright © 2017 Mohamed Hamed. All rights reserved.
//

import UIKit


extension ViewController {
//Translation is moving object 
    func panGesture(_ recognizer: UIPanGestureRecognizer) {
        let view = recognizer.view!
        let point = recognizer.location(in: self.view) //recognizer.translation(in: view)
        view.center = point// CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
    }
    func pinchGesture(_ recognizer: UIPinchGestureRecognizer) {
        let view = recognizer.view!
        view.transform = CGAffineTransform(scaleX: recognizer.scale, y: recognizer.scale)
        if recognizer.state == .ended {
            recognizer.scale = 1.0
        }
    }
    
}
