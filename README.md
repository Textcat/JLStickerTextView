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

```Ruby
use_frameworks!
pod "JLStickerTextView", "~> 0.1.1"
```

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
```Swift
stickerView.addLabel()
```

###set the Label
You can only set the color, font and alpha of the label now, more will be added in the future. (alignment, lineSpacing and so on)

####Color
```Swift
stickerView.textColor = UIColor.whiteColor()
```
####Alpha
```Swift
sticker.textAlpha = CGFloat(textAlpha)
```
####Font
```Swift
stickerView.fontName = fontName
```

**Note**: when you set the properties, you make change to the selected TextLabel.

###Render Text on Image
When you feel good, you are going to render the Text on Image:

```Swift
let image = stickerView.renderTextOnView(stickerView)
UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
```

###Scale stickerView  proportionally
This function is not complete yet, I just make it to fit my requirement.

```Swift
stickerView.limitImageViewToSuperView()
```

When you render the text on UIImageView whose content mode is AspectFit, it is possible you will get some unwanted border. This function will scale UIImageView to fit the image. 

##Plan
Here are some ideas:

* more options for text(alignment, lineSpacing.....)
* interface to custome the appearance of StickerLabelView(close Button, rotate button, border,etc)
* more general solution for Scaling stickerView proportionally

##Reference
Inspired by

* [IQLabelView](https://github.com/kcandr/IQLabelView)
*  [TextDrawer](https://github.com/remirobert/TextDrawer)




