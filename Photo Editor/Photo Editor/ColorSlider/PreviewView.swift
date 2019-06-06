//
//  PreviewView.swift
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

public typealias PreviewView = UIView & ColorSliderPreviewing

/// The display state of a preview view.
public enum PreviewState {
	/// The color is not being changed and the preview view is centered at the last modified point.
	case inactive
	
	/// The color is still being changed, but the preview view center is fixed.
	/// This occurs when a touch begins inside the slider but continues outside of it.
	/// In this case, the color is actively being modified, but the preview remains fixed at
	/// the same position that it was when the touch moved outside of the slider.
	case activeFixed
	
	/// The color is being actively changed and the preview view center will be updated to match the current color.
	case active
}

/// A protocol defining callback methods for a `ColorSlider` preview view.
///
/// To create a custom preview view, create a `UIView` subclass and implement `ColorSliderPreviewing`.
/// Then, create an instance of your custom preview view and pass it to the `ColorSlider` initializer.
/// As a user drags their finger, `ColorSlider` will automatically set your preview view's `center`
/// to the point closest to the touch, centered along the axis perpendicular to the `ColorSlider`'s orientation.
///
/// If `autoresizesSubviews` is `true` (the default value on all `UIView`s) on your `ColorSlider`, your preview view
/// will also be automatically resized when its `center` point is being set. To disable resizing your preview, set
/// the `autoresizesSubviews` property on your `ColorSlider` to `false`.

public protocol ColorSliderPreviewing {
	/// Called when the color of the slider changes, so the preview can respond correctly.
	/// - parameter color: The newly selected color.
	func colorChanged(to color: UIColor)
	
	/// Called when the preview changes state and should update its appearance appropriately.
	/// Since `ColorSlider` sets the `center` of your preview automatically, you should use your
	/// view's `transform` to adjust or animate most changes. See `DefaultPreviewView` for an example.
	/// - parameter state: The new state of the preview view.
	func transition(to state: PreviewState)
}
