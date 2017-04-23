# iOS Photo Editor

## Features
- [x] Cropping 
- [x] Adding images -Stickers-
- [x] Adding Text with colors
- [x] Drawing wihtcolors
- [x] Scaling and rotating objects 
- [x] Deleting objects 
- [x] Saving to photos and Sharing 
- [x] Cool animations 
- [x] Uses iOS Taptic Engine feedback 

## New Features in V 0.4 

Thanks to https://github.com/sprint84/PhotoCropEditor 

It now supports Cropping 💃🏻

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```
To integrate iOS Photo Editor into your Xcode project using CocoaPods, specify it in your `Podfile`:
```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'iOSPhotoEditor'
end
```

Then, run the following command:

```bash
$ pod install
```

## Usage

### Photo

The `PhotoEditorViewController`.

```swift
let photoEditor = UIStoryboard(name: "PhotoEditor", bundle: Bundle(for: PhotoEditorViewController.self)).instantiateViewController(withIdentifier: "PhotoEditorViewController") as! PhotoEditorViewController

//PhotoEditorDelegate
photoEditor.photoEditorDelegate = self

//The image to be edited 
photoEditor.image = image

//Stickers that the user will choose from to add on the image         
photoEditor.stickers.append(UIImage(named: "sticker" )!)

//To hide controls - array of enum control
photoEditor.hiddenControls = [.crop, .draw, .share]

//Present the View Controller
present(photoEditor, animated: true, completion: nil)
```
The `PhotoEditorDelegate` methods.

```swift
func imageEdited(image: UIImage) {
    // the edited image
}
    
func editorCanceled() {
    print("Canceled")
}

```

<img src="screenshot.PNG" width="350" height="600" />

# Live Demo appetize.io
[![Demo](appetize.png)](https://appetize.io/app/jtanmwtzbz1favhvhw5g24n7b0?device=iphone7plus&scale=50&orientation=portrait&osVersion=10.3)


# Demo Video 
[![Demo](https://img.youtube.com/vi/9VeIl9i30dI/0.jpg)](https://youtu.be/9VeIl9i30dI)

## Credits

Written by [Mohamed Hamed](https://github.com/M-Hamed).

Initially sponsored by [![Eventtus](http://assets.eventtus.com/logos/eventtus/standard.png)](http://eventtus.com)

## License

Released under the [MIT License](http://www.opensource.org/licenses/MIT).
