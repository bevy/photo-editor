//
//  ViewController.swift
//  editorTest
//
//  Created by Mohamed Hamed on 5/4/17.
//  Copyright © 2017 Mohamed Hamed. All rights reserved.
//

import UIKit
import iOSPhotoEditor

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pickImageButtonTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
}

extension ViewController: PhotoEditorDelegate {
    
    func imageEdited(image: UIImage) {
        imageView.image = image
    }
    
    func editorCanceled() {
        print("Canceled")
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        picker.dismiss(animated: true, completion: nil)
        
        let photoEditor = UIStoryboard(name: "PhotoEditor", bundle: Bundle(for: PhotoEditorViewController.self)).instantiateViewController(withIdentifier: "PhotoEditorViewController") as! PhotoEditorViewController

        photoEditor.photoEditorDelegate = self
        photoEditor.image = image
        
        for i in 0...10 {
            photoEditor.stickers.append(UIImage(named: i.description )!)
        }
        
//        photoEditor.hiddenControls = [.crop, .draw, .share]
        present(photoEditor, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
