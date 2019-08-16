//
//  PhotoEditor+Crop.swift
//  Pods
//
//  Created by Mohamed Hamed on 6/16/17.
//
//

import Foundation
import UIKit

// MARK: - CropView
extension PhotoEditorViewController: CropViewControllerDelegate {
    
    public func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage, transform: CGAffineTransform, cropRect: CGRect) {
        controller.dismiss(animated: true, completion: nil)
        self.setImageView(image: image)
    }
    
    public func cropViewControllerDidCancel(_ controller: CropViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDoneClicked(_ btn: UIButton) {
        self.setImageView(image: cropView.croppedImage!)
        for viewSub in self.canvasImageView.subviews {
            viewSub.removeFromSuperview()
        }
        self.cropBaseView.isHidden = true
        self.hideToolbar(hide: false)
        self.textView.isHidden = false
    }
    
   @IBAction func btnCropClicked(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let original = UIAlertAction(title: "Original", style: .default) { [unowned self] action in
            guard let image = self.cropView?.image else {
                return
            }
            guard var cropRect = self.cropView?.cropRect else {
                return
            }
            let width = image.size.width
            let height = image.size.height
            let ratio: CGFloat
            if width < height {
                ratio = width / height
                cropRect.size = CGSize(width: cropRect.height * ratio, height: cropRect.height)
            } else {
                ratio = height / width
                cropRect.size = CGSize(width: cropRect.width, height: cropRect.width * ratio)
            }
            self.cropView?.cropRect = cropRect
        }
        actionSheet.addAction(original)
        let square = UIAlertAction(title: "Square", style: .default) { [unowned self] action in
            let ratio: CGFloat = 1.0
            //            self.cropView?.cropAspectRatio = ratio
            if var cropRect = self.cropView?.cropRect {
                let width = cropRect.width
                cropRect.size = CGSize(width: width, height: width * ratio)
                self.cropView?.cropRect = cropRect
            }
        }
        actionSheet.addAction(square)
    let threeByTwo = UIAlertAction(title: "3:2", style: .default) { [unowned self] action in
            self.cropView?.cropAspectRatio = 3.0 / 2.0
        }
        actionSheet.addAction(threeByTwo)
    let threeByFive = UIAlertAction(title: "5:3", style: .default) { [unowned self] action in
            self.cropView?.cropAspectRatio = 5.0 / 3.0
        }
        actionSheet.addAction(threeByFive)
    let fourByThree = UIAlertAction(title: "4:3", style: .default) { [unowned self] action in
//            let ratio: CGFloat = 4.0 / 3.0
         self.cropView?.cropAspectRatio = 4.0 / 3.0
//            if var cropRect = self.cropView?.cropRect {
        
//                let width = cropRect.width
//                cropRect.size = CGSize(width: width, height: width * ratio)
//                self.cropView?.cropRect = cropRect
//            }
        }
        actionSheet.addAction(fourByThree)
    let fourBySix = UIAlertAction(title: "5:4", style: .default) { [unowned self] action in
            self.cropView?.cropAspectRatio = 5.0 / 4.0
        }
        actionSheet.addAction(fourBySix)
    let fiveBySeven = UIAlertAction(title: "7:5", style: .default) { [unowned self] action in
            self.cropView?.cropAspectRatio = 7.0 / 5.0
        }
        actionSheet.addAction(fiveBySeven)
//        let eightByTen = UIAlertAction(title: "8 x 10", style: .default) { [unowned self] action in
//            self.cropView?.cropAspectRatio = 8.0 / 10.0
//        }
//        actionSheet.addAction(eightByTen)
//        let widescreen = UIAlertAction(title: "16 x 9", style: .default) { [unowned self] action in
//            let ratio: CGFloat = 9.0 / 16.0
//            if var cropRect = self.cropView?.cropRect {
//                let width = cropRect.width
//                cropRect.size = CGSize(width: width, height: width * ratio)
//                self.cropView?.cropRect = cropRect
//            }
//        }
//        actionSheet.addAction(widescreen)
        let cancel = UIAlertAction(title: "Cancel", style: .default) { [unowned self] action in
            //self.dismiss(animated: true, completion: nil)
            self.cropBaseView.isHidden = true
            
        }
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
     func adjustCropRect() {
        imageCropRect = CGRect.zero
        
        guard var cropViewCropRect = cropView?.cropRect else {
            return
        }
        cropViewCropRect.origin.x += cropRect.origin.x
        cropViewCropRect.origin.y += cropRect.origin.y
        
        let minWidth = min(cropViewCropRect.maxX - cropViewCropRect.minX, cropRect.width)
        let minHeight = min(cropViewCropRect.maxY - cropViewCropRect.minY, cropRect.height)
        let size = CGSize(width: minWidth, height: minHeight)
        cropViewCropRect.size = size
        cropView?.cropRect = cropViewCropRect
    }
    
     func initialize() {
        
        if cropAspectRatio != 0 {
            cropView?.cropAspectRatio = cropAspectRatio
        }
        
        if !cropRect.equalTo(CGRect.zero) {
            adjustCropRect()
        }
        
        if !imageCropRect.equalTo(CGRect.zero) {
            cropView?.imageCropRect = imageCropRect
        }
        
        cropView?.keepAspectRatio = keepAspectRatio
    }
    
    @IBAction func resetCropRect() {
        guard let image = self.cropView?.image else {
            return
        }
        guard var cropRect = self.cropView?.cropRect else {
            return
        }
        let width = image.size.width
        let height = image.size.height
        let ratio: CGFloat
        if width < height {
            ratio = width / height
            cropRect.size = CGSize(width: cropRect.height * ratio, height: cropRect.height)
        } else {
            ratio = height / width
            cropRect.size = CGSize(width: cropRect.width, height: cropRect.width * ratio)
        }
        self.cropView?.cropRect = cropRect
        cropView?.resetCropRect()
        cropView.zoomToCropRect(cropRect)
    }
    
    public func resetCropRectAnimated(_ animated: Bool) {
        cropView?.resetCropRectAnimated(animated)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        //delegate?.cropViewControllerDidCancel(self)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        if (cropView?.croppedImage) != nil {
//            guard let rotation = cropView?.rotation else {
//                return
//            }
//            guard let rect = cropView?.zoomedCropRect() else {
//                return
//            }
            //delegate?.cropViewController(self, didFinishCroppingImage: image, transform: rotation, cropRect: rect)
        }
    }
}
