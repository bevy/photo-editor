//
//  ColorSliderExtensions.swift
//
//  Created by Sachin Patel on 5/27/17.
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
internal extension Range {
	/// Constrain a `Bound` value by `self`.
	/// Equivalent to max(lowerBound, min(upperBound, value)).
	/// - parameter value: The value to be clamped.
	internal func clamp(_ value: Bound) -> Bound {
		return lowerBound > value ? lowerBound
			 : upperBound < value ? upperBound
			 : value
	}
}

/// :nodoc:
internal extension UITouch {
	/// Calculate the "progress" of a touch in a view with respect to an orientation.
	/// - parameter view: The view to be used as a frame of reference.
	/// - parameter orientation: The orientation with which to determine the return value.
	/// - returns: The percent across the `view` that the receiver's location is, relative to the `orientation`. Constrained to (0, 1).
	internal func progress(in view: UIView, withOrientation orientation: Orientation) -> CGFloat {
		let touchLocation = self.location(in: view)
		var progress: CGFloat = 0
		
		switch orientation {
		case .vertical:
			progress = touchLocation.y / view.bounds.height
		case .horizontal:
			progress = touchLocation.x / view.bounds.width
		}
		
		return (0.0..<1.0).clamp(progress)
	}
}
