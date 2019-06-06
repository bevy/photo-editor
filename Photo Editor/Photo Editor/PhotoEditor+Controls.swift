//
//  PhotoEditor+Controls.swift
//  Pods
//
//  Created by Mohamed Hamed on 6/16/17.
//
//

import Foundation
import UIKit

// MARK: - Control
public enum control {
    case crop
    case sticker
    case draw
    case text
    case save
    case share
    case clear
}

extension PhotoEditorViewController {

     //MARK: Top Toolbar
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        photoEditorDelegate?.canceledEditing()
        
    }

    @IBAction func cropButtonTapped(_ sender: UIButton) {
        manageSelectedButtons(sender)
        UIView.animate(withDuration: 0.2) {
            self.initialize()
            self.cropBaseView.isHidden = false
            self.cropView.image = self.canvasView.toImage()
//            self.cropView.addSubview(self.imageView)
            self.cropView.bringSubviewToFront(self.cropBaseView)
            self.hideToolbar(hide: true)
        }
        
        
//        let controller = CropViewController()
//        controller.delegate = self
//        controller.image = image
//        let navController = UINavigationController(rootViewController: controller)
//        present(navController, animated: true, completion: nil)
    }

    @IBAction func stickersButtonTapped(_ sender: UIButton) {
        manageSelectedButtons(sender)
        addStickersViewController()
    }
    

    @IBAction func drawButtonTapped(_ sender: UIButton) {
        manageSelectedButtons(sender)
        isDrawing = true
        canvasImageView.isUserInteractionEnabled = false
        //doneButton.isHidden = false
        colorPickerView.isHidden = false
//        hideToolbar(hide: true)
    }
    
    @IBAction func editingDoneButtonTapped(_ sender: UIButton) {
       self.continueButtonPressed(sender)
    }

    @IBAction func textButtonTapped(_ sender: UIButton) {
        manageSelectedButtons(sender)
        isTyping = true
        colorPickerView.isHidden = false
        let textView = UITextView(frame: CGRect(x: canvasImageView.frame.width / 2,  y: canvasImageView.frame.height / 2,
                                                width: UIScreen.main.bounds.width, height: 30))
        self.addDoneButtonOnKeyboard(textView)
        
        textView.textAlignment = .center
        textView.font = UIFont(name: "Helvetica", size: 30)
        textView.textColor = textColor
        textView.layer.shadowColor = UIColor.black.cgColor
        textView.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
        textView.layer.shadowOpacity = 0.2
        textView.layer.shadowRadius = 1.0
        textView.layer.backgroundColor = UIColor.clear.cgColor
        textView.autocorrectionType = .no
        textView.isScrollEnabled = false
        textView.delegate = self
        self.canvasImageView.addSubview(textView)
        addGestures(view: textView)
        textView.becomeFirstResponder()
    }    
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        view.endEditing(true)
        doneButton.isHidden = true
        colorPickerView.isHidden = true
        canvasImageView.isUserInteractionEnabled = true
        hideToolbar(hide: false)
        isDrawing = false
        manageSelectedButtons(UIButton())
    }
    
    func manageSelectedButtons(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender != self.drawButton {
            colorPickerView.isHidden = true
            canvasImageView.isUserInteractionEnabled = true
            isDrawing = false
        }
        self.textButton.isSelected = false
        self.drawButton.isSelected = false
        self.cropButton.isSelected = false
        sender.isSelected = true
        colorPickerView.isHidden = true
        self.textButton.setBackgroundColor(color: self.drawColor, forState: .selected)
        self.drawButton.setBackgroundColor(color: self.drawColor, forState: .selected)
    }
    
    //MARK: Bottom Toolbar
    
    @IBAction func saveButtonTapped(_ sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(canvasView.toImage(),self, #selector(PhotoEditorViewController.image(_:withPotentialError:contextInfo:)), nil)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        let activity = UIActivityViewController(activityItems: [canvasView.toImage()], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
        
    }
    
    @IBAction func clearButtonTapped(_ sender: AnyObject) {
        //clear drawing
        //clear stickers and textviews
        if canvasImageView.subviews.count > 0 {
            canvasImageView.subviews.last?.removeFromSuperview()
        }
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        let img = self.canvasView.toImage()
        photoEditorDelegate?.doneEditing(image:  img, caption: self.textView.text)
        
    }

    //MAKR: helper methods
    
    @objc func image(_ image: UIImage, withPotentialError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
        let alert = UIAlertController(title: "Image Saved", message: "Image successfully saved to Photos library", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func hideControls() {
        for control in hiddenControls {
            switch control {
                
            case .clear:
                clearButton.isHidden = true
            case .crop:
                cropButton.isHidden = true
            case .draw:
                drawButton.isHidden = true
            case .save:
                saveButton.isHidden = true
            case .share:
                shareButton.isHidden = true
            case .sticker:
                stickerButton.isHidden = true
            case .text:
                stickerButton.isHidden = true
            }
        }
    }
    
}


extension UIButton {
  
    func setBackgroundColor(color: UIColor = UIColor.blue, forState: UIControl.State = .highlighted) {
        self.layer.masksToBounds = true
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
    
}


extension UIView {
    var width: CGFloat {
        get { return self.frame.size.width }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    var height: CGFloat {
        get { return self.frame.size.height }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    var size: CGSize  {
        get { return self.frame.size }
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    var origin: CGPoint {
        get { return self.frame.origin }
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    
    var x: CGFloat {
        get { return self.frame.origin.x }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    var y: CGFloat {
        get { return self.frame.origin.y }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    var centerX: CGFloat {
        get { return self.center.x }
        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }
    
    var centerY: CGFloat {
        get { return self.center.y }
        set {
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }
    
    var top : CGFloat {
        get { return self.frame.origin.y }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    var bottom : CGFloat {
        get { return frame.origin.y + frame.size.height }
        set {
            var frame = self.frame
            frame.origin.y = newValue - self.frame.size.height
            self.frame = frame
        }
    }
    
    var right : CGFloat {
        get { return self.frame.origin.x + self.frame.size.width }
        set {
            var frame = self.frame
            frame.origin.x = newValue - self.frame.size.width
            self.frame = frame
        }
    }
    
    var left : CGFloat {
        get { return self.frame.origin.x }
        set {
            var frame = self.frame
            frame.origin.x  = newValue
            self.frame = frame
        }
    }
}
