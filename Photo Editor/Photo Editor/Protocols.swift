//
//  Protocols.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 6/15/17.
//
//

import Foundation
import UIKit
/**
 - didSelectView
 - didSelectImage
 - stickersViewDidDisappear
 */

@objc public protocol PhotoEditorDelegate {
    /**
     - Parameter image: edited Image
     */
    func doneEditing(image: UIImage)
    /**
     StickersViewController did Disappear
     */
    func canceledEditing()
}


/**
 - didSelectView
 - didSelectImage
 - stickersViewDidDisappear
 */
@objc protocol StickersViewControllerDelegate {
    /**
     - Parameter view: selected view from StickersViewController
     */
    func didSelectView(view: UIView)
    /**
     - Parameter image: selected Image from StickersViewController
     */
    func didSelectImage(image: UIImage)
    /**
     StickersViewController did Disappear
     */
    func stickersViewDidDisappear()
}

/**
 - didSelectColor
 */
@objc protocol ColorDelegate {
    func didSelectColor(color: UIColor)
}
