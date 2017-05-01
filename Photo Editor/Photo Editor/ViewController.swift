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
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var topToolbar: UIView!
    @IBOutlet weak var bottomToolbar: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    
    @IBOutlet weak var colorPickerView: UIView!
    var colorsCollectionViewDelegate: ColorsCollectionViewDelegate!

    //
    var drawColor: UIColor = UIColor.black
    var isDrawing: Bool = false
    var lastPoint: CGPoint!
    var swiped = false
    var opacity: CGFloat = 1.0
    var lastPanPoint: CGPoint?
    var lastTextViewTransform: CGAffineTransform?
    var lastTextViewTransCenter: CGPoint?
    //

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "img.jpg")

        
        deleteView.layer.cornerRadius = deleteView.bounds.height / 2
        deleteView.layer.borderWidth = 2.0
        deleteView.layer.borderColor = UIColor.white.cgColor
        deleteView.clipsToBounds = true
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .bottom
        edgePan.delegate = self
        self.view.addGestureRecognizer(edgePan)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        configureCollectionView()

    }
    
    func configureCollectionView() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 30, height: 30)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        colorsCollectionView.collectionViewLayout = layout
        colorsCollectionViewDelegate = ColorsCollectionViewDelegate()
        colorsCollectionViewDelegate.colorDelegate = self
        colorsCollectionView.delegate = colorsCollectionViewDelegate
        colorsCollectionView.dataSource = colorsCollectionViewDelegate
        
        colorsCollectionView.register(
            UINib(nibName: "ColorCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "ColorCollectionViewCell")
        
    }
    
    @IBAction func saveButtonTapped(_ sender: AnyObject) {
        if self.imageView.image == nil{
            return
        }
        UIImageWriteToSavedPhotosAlbum(self.imageView.toImage(),self, #selector(ViewController.image(_:withPotentialError:contextInfo:)), nil)
        
        ///To Share
        //let activity = UIActivityViewController(activityItems: [self.imageView.toImage()], applicationActivities: nil)
        //present(activity, animated: true, completion: nil)
        
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
        colorPickerView.isHidden = true
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
        textView.autocorrectionType = .no
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
        colorPickerView.isHidden = false
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

extension ViewController: ColorDelegate {
    func chosedColor(color: UIColor) {
        self.drawColor = color
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
        lastTextViewTransform =  textView.transform
        lastTextViewTransCenter = textView.center
        
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

