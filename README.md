StickerTextView is an subclass of UIImageView. You can add multiple text to it, edit, rotate, resize the text as you want with one finger, then render the text on Image.

##Features
* You can add multiple Text to StickerTextView at the same time
* Multiple line Text support
* Rotate, resize the text with one finger
* set the Color, alpha, font of the text
* StickerTextView also handle the process of rendering text on Image
* Written in Swift

##Installation
###CocoaPods
To integrate StickerTextView into your Xcode project using CocoaPods, specify it in your Podfile:


###Manually
Just drag the file in Source to your project

##Usage
###Start
First, import StickerView, then subclass the UIImageView, which you want to add text on, to StickerTextView, like this:

```Swift
import StickerTextView
class ViewController: UIViewController {
	@IBOutlet var stickerView: stickerImageView!
}
```
###Add new Label
It is quite easy to add new label to current StickerImageView:
```
stickerView.addLabel()
```

###