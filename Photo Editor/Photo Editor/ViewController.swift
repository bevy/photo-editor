//
//  ViewController.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 4/23/17.
//  Copyright © 2017 Mohamed Hamed. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    //
    var lastPoint:CGPoint!
    var isSwiping:Bool!
    var red:CGFloat!
    var green:CGFloat!
    var blue:CGFloat!
    //
    @IBOutlet var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "img.jpg")
        // Do any additional setup after loading the view, typically from a nib.
        red   = (0.0/255.0)
        green = (0.0/255.0)
        blue  = (0.0/255.0)
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .bottom
        edgePan.delegate = self
        self.view.addGestureRecognizer(edgePan)
    }
    
    func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            addBottomSheetView()
        }
    }
    
    // to Override Control Center screen edge pan from bottom
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func saveImage(_ sender: AnyObject) {
        if self.imageView.image == nil{
            return
        }
        UIImageWriteToSavedPhotosAlbum(self.imageView.toImage(),self, #selector(ViewController.image(_:withPotentialError:contextInfo:)), nil)
    }
    @IBAction func undoDrawing(_ sender: AnyObject) {
        self.imageView.image = UIImage(named: "img.jpg")
        let rect = CGRect(x: 200, y: 200, width: 100, height: 100)
        let tempView = UIView(frame: rect)
        tempView.backgroundColor = UIColor.red
        self.imageView.addSubview(tempView)
    }
    func image(_ image: UIImage, withPotentialError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
        let alert = UIAlertController(title: "Image Saved", message: "Image successfully saved to Photos library", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBAction func stickersButtonTapped(_ sender: Any) {
        addBottomSheetView()
    }

    let bottomSheetVC =  BottomSheetViewController()

    func addBottomSheetView() {
        bottomSheetVC.stickerDelegate = self
        self.addChildViewController(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParentViewController: self)
        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY , width: width, height: height)
    }
    
    func removeBottomSheetView() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        var frame = self.bottomSheetVC.view.frame
                        frame.origin.y = UIScreen.main.bounds.maxY
                        self.bottomSheetVC.view.frame = frame
                        
        }, completion: { (finished) -> Void in
            self.bottomSheetVC.view.removeFromSuperview()
            self.bottomSheetVC.removeFromParentViewController()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Pencil
    
//    override func touchesBegan(_ touches: Set<UITouch>,
//                               with event: UIEvent?){
//        isSwiping    = false
//        if let touch = touches.first{
//            lastPoint = touch.location(in: imageView)
//        }
//    }
    
//    override func touchesMoved(_ touches: Set<UITouch>,
//                               with event: UIEvent?){
//        
//        isSwiping = true;
//        if let touch = touches.first{
//            let currentPoint = touch.location(in: imageView)
//            UIGraphicsBeginImageContext(self.imageView.frame.size)
//            self.imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.imageView.frame.size.width, height: self.imageView.frame.size.height))
//            UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
//            UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: currentPoint.x, y: currentPoint.y))
//            UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
//            UIGraphicsGetCurrentContext()?.setLineWidth(5.0)
//            UIGraphicsGetCurrentContext()?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
//            UIGraphicsGetCurrentContext()?.strokePath()
//            self.imageView.image = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            lastPoint = currentPoint
//        }
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>,
//                               with event: UIEvent?){
//        if(!isSwiping) {
//            // This is a single touch, draw a point
//            UIGraphicsBeginImageContext(self.imageView.frame.size)
//            self.imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.imageView.frame.size.width, height: self.imageView.frame.size.height))
//            UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
//            UIGraphicsGetCurrentContext()?.setLineWidth(9.0)
//            UIGraphicsGetCurrentContext()?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
//            UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
//            UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
//            UIGraphicsGetCurrentContext()?.strokePath()
//            self.imageView.image = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//        }
//    }
    
}

extension ViewController: StickerDelegate {
    func viewTapped(view: UIView) {
        let newView = view.toImageView()
        self.removeBottomSheetView()
        newView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        self.imageView.addSubview(newView)
        //Gestures
        newView.isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(ViewController.panGesture))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self
        newView.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self,
                                                    action: #selector(ViewController.pinchGesture))
        pinchGesture.delegate = self
        newView.addGestureRecognizer(pinchGesture)
        
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self,
                                                                    action:#selector(ViewController.rotationGesture) )
        rotationGestureRecognizer.delegate = self
        newView.addGestureRecognizer(rotationGestureRecognizer)

    }
}

