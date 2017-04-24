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
    
    func imageTapped(image: UIImage) {
        self.removeBottomSheetView()
        let rect = CGRect(x: UIScreen.main.bounds.width / 2 - 50, y: UIScreen.main.bounds.height / 2 - 50, width: 100, height: 100)
        let view = UIView(frame: rect)
        view.backgroundColor = UIColor(patternImage: image)
        self.view.addSubview(view)
    }
}
