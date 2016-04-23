##About

StickerTextView is an subclass of UIImageView. You can add multiple text to it, edit, rotate, resize the text as you want with one finger, then render the text on Image.

![](https://github.com/luiyezheng/JLStickerTextView/blob/master/demoScreenshot.png)

##Features
* You can add multiple Text to StickerTextView at the same time
* Multiple line Text support
* Rotate, resize the text with one finger
* set the Color, alpha, font, alignment of the text
* StickerTextView also handle the process of rendering text on Image
* Written in Swift

##Installation
###CocoaPods
To integrate StickerTextView into your Xcode project using CocoaPods, specify it in your Podfile and run `pod install`:

```Ruby
use_frameworks!
pod "JLStickerTextView", "~> 0.1.1"
```
To get the latest version:
```Ruby
use_frameworks!
pod "JLStickerTextView", :git =>
"https://github.com/luiyezheng/JLStickerTextView.git"
```

###Manually
Just drag the Source files into your project

##Usage
###Start
First, import `JLStickerTextView`, then subclass the UIImageView, which you want to add text on, to JLStickerImageView, like this:

```Swift
import JLStickerTextView
class ViewController: UIViewController {
	@IBOutlet var stickerView: JLStickerImageView!
}
```

If you use Storyboard, you also need connect the UIImageView to `JLStikcerImageView` Class in Identity Inspector.
![](https://github.com/luiyezheng/JLStickerTextView/blob/master/Inspector.png)

###Add new Label
It is quite easy to add new label to current StickerImageView:
```Swift
stickerView.addLabel()
```

###set the Label
You can set the color, font , alignment and alpha of the label
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

####Alignment

```
stickerView.textAlignment = NSTextAlignment.Center
```

**Note**: when you set the properties, you make change to the current selected TextLabel.

###Render Text on Image
When you feel good, you are going to render the Text on Image and save the image:

```Swift
let image = stickerView.renderTextOnView(stickerView)
UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
```

###Scale stickerView  proportionally
This function is not complete yet, I just make it to fit my requirement.

```
stickerView.limitImageViewToSuperView()
```

When you render the text on UIImageView whose content mode is AspectFit, it is possible you will get some unwanted border. This function will scale UIImageView to fit the image. 

##Plan
Here are some ideas:

* more options for text(eg: lineSpacing)
* interface to custome the appearance of StickerLabelView(close Button, rotate button, border,etc)
* more general solution for Scaling stickerView proportionally
* add placeholder

##Contributon
No specific restriction for contribution yet. Any suggestion, request, pull are welcome. If you encounter any problem, feel free to create an issue.

##Reference

Based on 
* [IQLabelView](https://github.com/kcandr/IQLabelView)

Also inspired by
*  [TextDrawer](https://github.com/remirobert/TextDrawer)




