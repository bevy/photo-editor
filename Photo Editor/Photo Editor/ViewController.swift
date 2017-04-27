//
//  ViewController.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 4/23/17.
//  Copyright © 2017 Mohamed Hamed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var topToolbar: UIView!
    @IBOutlet weak var bottomToolbar: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var deleteView: UIView!
    
    //
    var isDrawing: Bool = false
    var lastPoint: CGPoint!
    var isSwiping: Bool!
    var lastPanPoint: CGPoint?
    var lastTextViewTransform: CGAffineTransform?
    var lastTextViewTransCenter: CGPoint?
    //

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "img.jpg")

        
        deleteView.layer.cornerRadius = deleteView.bounds.height / 2
        deleteView.clipsToBounds = true
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .bottom
        edgePan.delegate = self
        self.view.addGestureRecognizer(edgePan)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)

    }
    
    @IBAction func saveButtonTapped(_ sender: AnyObject) {
        if self.imageView.image == nil{
            return
        }
        UIImageWriteToSavedPhotosAlbum(self.imageView.toImage(),self, #selector(ViewController.image(_:withPotentialError:contextInfo:)), nil)
    }
    
    @IBAction func clearButtonTapped(_ sender: AnyObject) {
        //clear drawing
        imageView.image = UIImage(named: "img.jpg")
        //clear stickers and textviews
        for subview in imageView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        view.endEditing(true)
        doneButton.isHidden = true
        imageView.isUserInteractionEnabled = true
        hideToolbar(hide: false)
        isDrawing = false
    }
    
    func keyboardWillShow(notification: NSNotification) {
        doneButton.isHidden = false
        hideToolbar(hide: true)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        doneButton.isHidden = true
        hideToolbar(hide: false)
    }
    
    func image(_ image: UIImage, withPotentialError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
        let alert = UIAlertController(title: "Image Saved", message: "Image successfully saved to Photos library", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBAction func stickersButtonTapped(_ sender: Any) {
        addBottomSheetView()
    }
    
    @IBAction func textButtonTapped(_ sender: Any) {
        
        let textView = UITextView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height / 2,
                                                  width: UIScreen.main.bounds.width, height: 30))
        //Text Attributes
        textView.textAlignment = .center
        textView.font = UIFont(name: "Helvetica", size: 20)
        textView.textColor = .white
        textView.layer.shadowColor = UIColor.black.cgColor
        textView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        textView.layer.shadowOpacity = 1.0
        textView.layer.shadowRadius = 2.0
        textView.layer.backgroundColor = UIColor.clear.cgColor
        //
        textView.isScrollEnabled = false
        textView.delegate = self
        self.imageView.addSubview(textView)
        addGestures(view: textView)
        textView.becomeFirstResponder()
    }
    
    @IBAction func pencilButtonTapped(_ sender: Any) {
        isDrawing = true
        imageView.isUserInteractionEnabled = false
        doneButton.isHidden = false
        hideToolbar(hide: true)
    }
    

    let bottomSheetVC =  BottomSheetViewController()

    func addBottomSheetView() {
        hideToolbar(hide: true)
        
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
            self.hideToolbar(hide: false)
        })
    }
    
    func hideToolbar(hide: Bool) {
        topToolbar.isHidden = hide
        bottomToolbar.isHidden = hide
    }
    
}

extension ViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
       let rotation = atan2(textView.transform.b, textView.transform.a)
        if rotation == 0 {
            let oldFrame = textView.frame
            let sizeToFit = textView.sizeThatFits(CGSize(width: oldFrame.width, height:CGFloat.greatestFiniteMagnitude))
            textView.frame.size = CGSize(width: oldFrame.width, height: sizeToFit.height)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        lastTextViewTransform =  view.transform
        lastTextViewTransCenter = textView.center
        
        ///
        UIView.animate(withDuration: 0.4,
                       animations: {
                        textView.transform = CGAffineTransform.identity
                        textView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 100)
        }, completion: nil)

    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard lastTextViewTransform != nil && lastTextViewTransCenter != nil else {
            return
        }
        // Use Last Location and transform animated
        // Update Size
        UIView.animate(withDuration: 0.4,
                       animations: {
                        textView.transform = self.lastTextViewTransform!
                        textView.center = self.lastTextViewTransCenter!
        }, completion: nil)
    }
    
}

extension ViewController: StickerDelegate {
    
    func viewTapped(view: UIView) {
        let newView = view.toImageView()
        self.removeBottomSheetView()
        newView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        self.imageView.addSubview(newView)
        //Gestures
        addGestures(view: newView)
    }
    
    func bottomSheetDidDisappear() {
        hideToolbar(hide: false)
    }
    
    func addGestures(view: UIView) {
        //Gestures
        view.isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(ViewController.panGesture))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self,
                                                    action: #selector(ViewController.pinchGesture))
        pinchGesture.delegate = self
        view.addGestureRecognizer(pinchGesture)
        
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self,
                                                                    action:#selector(ViewController.rotationGesture) )
        rotationGestureRecognizer.delegate = self
        view.addGestureRecognizer(rotationGestureRecognizer)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapGesture))
        view.addGestureRecognizer(tapGesture)

    }
}

