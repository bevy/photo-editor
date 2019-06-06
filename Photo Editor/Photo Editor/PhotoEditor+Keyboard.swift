//
//  PhotoEditor+Keyboard.swift
//  Pods
//
//  Created by Mohamed Hamed on 6/16/17.
//
//

import Foundation
import UIKit

extension PhotoEditorViewController {
    
    @objc func keyboardDidShow(notification: NSNotification) {
        if isTyping {
            //doneButton.isHidden = false
            colorPickerView.isHidden = false
            hideToolbar(hide: true)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        isTyping = false
        doneButton.isHidden = true
        hideToolbar(hide: false)
    }
    
    @objc func keyboardWillChangeFrame(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            
            let endFrame = (userInfo[UIWindow.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIWindow.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIWindow.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.colorPickerViewBottomConstraint?.constant = 0.0
            } else {
                self.colorPickerViewBottomConstraint?.constant = endFrame?.size.height ?? 0.0
            }

            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
        if let endFrame = (notification.userInfo?[UIWindow.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = view.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                }
            }
            textViewBottomConstraint.constant = -keyboardHeight - 8
            view.layoutIfNeeded()
        }
    }
    
    
    func initializeCustomItems(_ viewMain: UIView) {
        inputToolbar = UIView()
        inputToolbar.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        inputToolbar.translatesAutoresizingMaskIntoConstraints = false
        viewMain.addSubview(inputToolbar)
        //inputToolbar.backgroundColor = .clear
//        let btnSend = UIButton(type: .custom)
//        btnSend.translatesAutoresizingMaskIntoConstraints = false
//        inputToolbar.addSubview(btnSend)
//        btnSend.setImage(UIImage(named: "btn_send_comment"), for: .normal)
//
//        btnSend.addTarget(self, action: #selector(PhotoEditorViewController.continueButtonPressed(_:)), for: .touchUpInside)
        
        // *** Create GrowingTextView ***
        textView = GrowingTextView()
//        textView.delegate = self
        textView.layer.cornerRadius = 4.0
        textView.text = strCaption
        textView.maxLength = 200
        textView.maxHeight = 70
        textView.trimWhiteSpaceWhenEndEditing = true
        textView.placeholder = "Type here".localized()
        textView.placeholderColor = UIColor(white: 0.8, alpha: 1.0)
        textView.returnKeyType = .done
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.returnKeyType = .default
        inputToolbar.addSubview(textView)
        
        // *** Autolayout ***
        
//        NSLayoutConstraint(item: btnSend, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 35).isActive = true
//        NSLayoutConstraint(item: btnSend, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 35).isActive = true
//        NSLayoutConstraint(item: btnSend, attribute: .top, relatedBy: .equal, toItem: inputToolbar, attribute: .top, multiplier: 1, constant: 8).isActive = true
        
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                inputToolbar.leadingAnchor.constraint(equalTo: viewMain.leadingAnchor),
                inputToolbar.trailingAnchor.constraint(equalTo: viewMain.trailingAnchor),
                inputToolbar.bottomAnchor.constraint(equalTo: viewMain.safeAreaLayoutGuide.bottomAnchor),
                textView.topAnchor.constraint(equalTo: inputToolbar.topAnchor, constant: 8),
                ])
        } else {
            NSLayoutConstraint.activate([
                inputToolbar.leadingAnchor.constraint(equalTo: viewMain.leadingAnchor),
                inputToolbar.trailingAnchor.constraint(equalTo: viewMain.trailingAnchor),
                inputToolbar.bottomAnchor.constraint(equalTo: viewMain.bottomAnchor),
                textView.topAnchor.constraint(equalTo: inputToolbar.topAnchor, constant: 8),
                ])
        }
        
        if #available(iOS 11, *) {
            textViewBottomConstraint = textView.bottomAnchor.constraint(equalTo: inputToolbar.bottomAnchor, constant: -8)
//            NSLayoutConstraint.activate([
//                btnSend.trailingAnchor.constraint(equalTo: inputToolbar.safeAreaLayoutGuide.trailingAnchor, constant: -8)
//                ])
            NSLayoutConstraint.activate([
                textView.leadingAnchor.constraint(equalTo: inputToolbar.safeAreaLayoutGuide.leadingAnchor, constant: 8),
                textView.trailingAnchor.constraint(equalTo: inputToolbar.safeAreaLayoutGuide.trailingAnchor, constant: -8),
                textViewBottomConstraint
                ])
        } else {
            textViewBottomConstraint = textView.bottomAnchor.constraint(equalTo: inputToolbar.bottomAnchor, constant: -8)
//            NSLayoutConstraint.activate([
//                btnSend.trailingAnchor.constraint(equalTo: inputToolbar.trailingAnchor, constant: -8)
//                ])
            NSLayoutConstraint.activate([
                textView.leadingAnchor.constraint(equalTo: inputToolbar.leadingAnchor, constant: 8),
                textView.trailingAnchor.constraint(equalTo: inputToolbar.trailingAnchor, constant: -8),
                textViewBottomConstraint
                ])
        }
        // *** Listen to keyboard show / hide ***
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIWindow.keyboardWillChangeFrameNotification, object: nil)
        
        textView.setRoundCorner(radius: 17.0)
        textView.setBorder(color: UIColor.lightGray.withAlphaComponent(0.5), size: 1.0)
        textView.textContainerInset = UIEdgeInsets(top: textView.textContainerInset.top, left: 10, bottom: textView.textContainerInset.bottom, right: 10)

        
        // *** Hide keyboard when tapping outside ***
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
//        viewMain.addGestureRecognizer(tapGesture)
    }
    @objc private func tapGestureHandler() {
        view.endEditing(true)
    }
}

extension PhotoEditorViewController: GrowingTextViewDelegate {
    
    // *** Call layoutIfNeeded on superview for animation when changing height ***
    
    public func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

