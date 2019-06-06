//
//  HSBColor.swift
//
//  Created by Sachin Patel on 8/11/17.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015-Present Sachin Patel (http://gizmosachin.com/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

/// :nodoc:
/// An [HSB](https://en.wikipedia.org/wiki/HSL_and_HSV) color value type.
internal struct HSBColor: Equatable {
	static let black = HSBColor(hue: 0, saturation: 1, brightness: 0)
	static let white = HSBColor(hue: 1, saturation: 0, brightness: 1)
	
	var hue: CGFloat = 0
	var saturation: CGFloat = 1
	var brightness: CGFloat = 1
	
	var isGrayscale: Bool {
		return saturation == 0
	}
	
	init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat) {
		self.hue = hue
		self.saturation = saturation
		self.brightness = brightness
	}
	
	init(color: UIColor) {
		color.getHue(&self.hue, saturation: &self.saturation, brightness: &self.brightness, alpha: nil)
	}
	
	static func between(color: HSBColor, and otherColor: HSBColor, percent: CGFloat) -> HSBColor {
		let hue = min(color.hue, otherColor.hue) + (abs(color.hue - otherColor.hue) * percent)
		let saturation = min(color.saturation, otherColor.saturation) + (abs(color.saturation - otherColor.saturation) * percent)
		let brightness = min(color.brightness, otherColor.brightness) + (abs(color.brightness - otherColor.brightness) * percent)
		return HSBColor(hue: hue, saturation: saturation, brightness: brightness)
	}
	
	static func ==(lhs: HSBColor, rhs: HSBColor) -> Bool {
		return lhs.hue == rhs.hue &&
			   lhs.saturation == rhs.saturation &&
			   lhs.brightness == rhs.brightness
	}
}

/// :nodoc:
internal extension UIColor {
	/// A convenience initializer to create a `UIColor` from an `HSBColor`.
	convenience init(hsbColor: HSBColor) {
		self.init(hue: hsbColor.hue, saturation: hsbColor.saturation, brightness: hsbColor.brightness, alpha: 1)
	}
}
