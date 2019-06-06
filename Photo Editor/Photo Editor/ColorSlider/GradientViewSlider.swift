//
//  GradientView.swift
//
//  Created by Sachin Patel on 8/12/17.
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

/// A gradient view that acts as the background of any `ColorSlider`.
/// This class draws colors based on the `orientation` passed to the initializer
/// and determines the output color of `ColorSlider` after a touch event.
///
/// Customize the appearance of ColorSlider by setting layer properties on
/// this class, including `borderWidth`, `borderColor`, and `cornerRadius`.

public final class GradientViewSlider: UIView {
	/// Whether the gradient should adjust its corner radius based on its bounds.
	/// When `true`, the layer's corner radius is set to `min(bounds.width, bounds.height) / 2.0` in `layoutSubviews`.
	public var automaticallyAdjustsCornerRadius: Bool = true {
		didSet {
			setNeedsLayout()
		}
	}
	
	/// The saturation of all colors in the view.
	/// Defaults to `1`.
	public var saturation: CGFloat = 1 {
		didSet {
			gradient = Gradient.colorSliderGradient(saturation: saturation, whiteInset: whiteInset, blackInset: blackInset)
		}
	}
	
	/// The percent of space at the beginning (top for orientation `.vertical` and left for orientation `.horizontal`) end of the slider reserved for the color white.
	/// Defaults to `0.15`.
	public var whiteInset: CGFloat = 0.15 {
		didSet {
			gradient = Gradient.colorSliderGradient(saturation: saturation, whiteInset: whiteInset, blackInset: blackInset)
		}
	}
	
	/// The percent of space at the end (bottom for orientation `.vertical` and right for orientation `.horizontal`) end of the slider reserved for the color black.
	/// Defaults to `0.15`.
	public var blackInset: CGFloat = 0.15 {
		didSet {
			gradient = Gradient.colorSliderGradient(saturation: saturation, whiteInset: whiteInset, blackInset: blackInset)
		}
	}

	/// :nodoc:
	/// The internal gradient used to draw the view.
	fileprivate var gradient: Gradient {
		didSet {
			setNeedsDisplay()
		}
	}
	
	/// :nodoc:
	/// The orientation of the gradient view. This is always equal to the value of `orientation` in the corresponding `ColorSlider` instance.
	fileprivate let orientation: Orientation
	
	/// - parameter orientation: The orientation of the gradient view.
	required public init(orientation: Orientation) {
		self.orientation = orientation
		self.gradient = Gradient.colorSliderGradient(saturation: 1, whiteInset: 0.15, blackInset: 0.15)
		
		super.init(frame: .zero)
		
		backgroundColor = .clear
		isUserInteractionEnabled = false
		
		// By default, show a border
		layer.masksToBounds = true
		layer.borderColor = UIColor.white.cgColor
		layer.borderWidth = 2
		
		// Set up based on orientation
		switch orientation {
		case .vertical:
			gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
			gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
		case .horizontal:
			gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
			gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
		}
	}
	
	/// :nodoc:
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

/// :nodoc:
// MARK: - Layer and Internal Drawing
public extension GradientViewSlider {
	override public class var layerClass: AnyClass {
		return CAGradientLayer.self
	}
	
	fileprivate var gradientLayer: CAGradientLayer {
		guard let gradientLayer = self.layer as? CAGradientLayer else {
			fatalError("Layer must be a gradient layer.")
		}
		return gradientLayer
	}
	
	override public func draw(_ rect: CGRect) {
		gradientLayer.colors = gradient.colors.map({ (hsbColor) -> CGColor in
			return UIColor(hsbColor: hsbColor).cgColor
		})
		gradientLayer.locations = gradient.locations as [NSNumber]
	}
	
	override public func layoutSubviews() {
		super.layoutSubviews()
		
		// Automatically adjust corner radius if needed
		if automaticallyAdjustsCornerRadius {
			let shortestSide = min(bounds.width, bounds.height)
			let automaticCornerRadius = shortestSide / 2.0
			if layer.cornerRadius != automaticCornerRadius {
				layer.cornerRadius = automaticCornerRadius
			}
		}
	}
}

// MARK: - Math
/// :nodoc:
internal extension GradientViewSlider {
	/// Determines the new color value after a touch event occurs. The behavior is defined as follows:
	/// **When `insideSlider == true`, if the touch is:**
	/// 	* In the first `whiteInset` percent of the slider, return white.
	/// 	* In the last `blackInset` percent of the slider, return black.
	/// 	* In between, return the `HSBColor` with the following values:
	/// 		* Hue: Determined based on the touch position within the slider, given the orientation.
	/// 		* Saturation: `self.saturation`
	///			* Brightness: `1`
	/// **When `insideSlider == false`**:
	/// 	* Hue: Keep constant.
	///		* Saturation: Adjust based on touch location along axis parallel to `orientation`.
	///		* Brightness: Adjust based on touch location along axis perpendicular to `orientation`.
	///
	/// - parameter oldColor: The last color before the touch occurred.
	/// - parameter touch: The touch that triggered the color change.
	/// - parameter insideSlider: Whether the touch that triggered the color change was inside the slider.
	/// - returns: The resulting color.
	internal func color(from oldColor: HSBColor, after touch: UITouch, insideSlider: Bool) -> HSBColor {
		var color = oldColor

		if insideSlider {
			// Hue: adjust based on touch location in ColorSlider bounds.
			// Saturation: Keep constant.
			// Brightness: Set equal to 100%.
			
			// Determine the progress of a touch along the slider given self.orientation
			let progress = touch.progress(in: self, withOrientation: orientation)
			
			// Set hue based on percent
			color = calculateColor(for: progress)
		} else {
			// Hue: Keep constant.
			// Saturation: Adjust based on touch location along axis parallel to self.orientation.
			// Brightness: Adjust based on touch location along axis perpendicular to self.orientation.
			
			guard let containingView = touch.view?.superview else { return color }
			let horizontalPercent = touch.progress(in: containingView, withOrientation: .horizontal)
			let verticalPercent = touch.progress(in: containingView, withOrientation: .vertical)
			
			switch orientation {
			case .vertical:
				color.saturation = horizontalPercent
				color.brightness = 1 - verticalPercent
			case .horizontal:
				color.saturation = 1 - verticalPercent
				color.brightness = horizontalPercent
			}
			
			// If `oldColor` is grayscale, black or white was selected before the touch exited the bounds of the slider.
			// Maintain the grayscale color as the touch continues outside the bounds so gray colors can be selected.
			if oldColor.isGrayscale {
				color.saturation = 0
			}
		}
		
		return color
	}
	
	/// Determines the corresponding HSBColor for a point the slider.
	/// The `sliderProgress` (ranging from 0.0 to 1.0) is used in `color(from:after:insideSlider:)` for touches inside the slider.
	/// - parameter sliderProgress: The "progress" of a touch relative to the width or height of the gradient view, given the `orientation`.
	///				The hue is equal to `point.x / bounds.width` when `orientation == .horizontal` and `point.y / bounds.height` when `orientation == .vertical`.
	/// - returns: The corresponding HSBColor.
	internal func calculateColor(for sliderProgress: CGFloat) -> HSBColor {
		return gradient.color(at: sliderProgress)
	}
	
	/// Determines the corresponding point on the slider for a HSBColor.
	/// The `sliderProgress` (ranging from 0.0 to 1.0) is used in `color(from:after:insideSlider:)` for touches inside the slider.
	/// - parameter color: A HSBColor value for which a closest-match "progress" value along the slider is to be determined.
	/// - returns: The closest-match "progress" value along the slider for `color`.
	internal func calculateSliderProgress(for color: HSBColor) -> CGFloat {
		var sliderProgress: CGFloat = 0.0
		if color.isGrayscale {
			// If the color is grayscale, find the closest matching percent along the slider
			if color.brightness > 0.5 {
				sliderProgress = whiteInset / 2
			} else {
				sliderProgress = 1 - (blackInset / 2)
			}
		} else {
			// Otherwise, calculate the percent corresponding to the color's hue in the non-grayscale part of the slider
			let spaceForNonGrayscaleColors = 1 - blackInset - whiteInset
			sliderProgress = ((1 - color.hue) * spaceForNonGrayscaleColors) + whiteInset
		}
		return sliderProgress
	}
}

fileprivate extension Gradient {
	static func colorSliderGradient(saturation: CGFloat, whiteInset: CGFloat, blackInset: CGFloat) -> Gradient {
		// Values from 0 to 1 at intervals of 0.1
		let values: [CGFloat] = [0.01, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.99]
		
		// Use these values as the hues for non-white and non-black colors
		let hues = values
		let nonGrayscaleColors = hues.map({ (hue) -> HSBColor in
			return HSBColor(hue: hue, saturation: saturation, brightness: 1)
		}).reversed()
		
		// Black and white are at the top and bottom of the slider, insert colors in between
		let spaceForNonGrayscaleColors = 1 - whiteInset - blackInset
		let nonGrayscaleLocations = values.map { (location) -> CGFloat in
			return whiteInset + (location * spaceForNonGrayscaleColors)
		}
		
		// Add black and white to locations and colors, set up gradient layer
		let colors = [HSBColor.white] + nonGrayscaleColors + [HSBColor.black]
		let locations = [0] + nonGrayscaleLocations + [1]
		return Gradient(colors: colors, locations: locations)
	}
}
