//
//  DrawItem.swift
//  Photo Editor
//
//  Created by user on 10/2/18.
//  Copyright © 2018 Mohamed Hamed. All rights reserved.
//

import UIKit

struct DrawItem {
    var segments: [DrawItemSegment] = []
    let color: CGColor
    
    init(_ color: CGColor) {
        self.color = color
    }
}

struct DrawItemSegment {
    let fromPoint: CGPoint
    let toPoint: CGPoint
    
    init(_ fromPoint: CGPoint, _ toPoint: CGPoint) {
        self.fromPoint = fromPoint
        self.toPoint = toPoint
    }
}
