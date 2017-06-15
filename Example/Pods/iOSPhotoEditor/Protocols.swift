//
//  Protocols.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 6/15/17.
//
//

import Foundation

/**
 # Delegate methods for StickersViewController.
 
 ## Methods
 
 - didSelectView
 - didSelectImage
 - stickersViewDidDisappear
 
 */
protocol StickersViewControllerDelegate {
    /**
     selected view from StickersViewController
     */
    func didSelectView(view: UIView)
    /**
     selected Image from StickersViewController
     */
    func didSelectImage(image: UIImage)
    /**
     StickersViewController did Disappear
     */
    func stickersViewDidDisappear()
}
