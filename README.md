## About

StickerTextView is an subclass of UIImageView. You can add multiple text to it, edit, rotate, resize the text as you want with one finger, then render the text on Image.

![](https://github.com/luiyezheng/JLStickerTextView/blob/master/demoScreenshot.jpg)

## Features
* You can add multiple Text to StickerTextView at the same time
* Multiple line Text support
* Rotate, resize the text with one finger
* Set the Color, alpha, font, alignment, TextShadow, lineSpacing...... of the text
* StickerTextView also handle the process of rendering text on Image
* Written in Swift

## Installation

### CocoaPods
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

### Manually
Just drag the Source files into your project

## Usage

### Start

First, import `JLStickerTextView`, then subclass the UIImageView, which you want to add text on, to JLStickerImageView, like this:

```Swift
import JLStickerTextView
class ViewController: UIViewController {
	@IBOutlet var stickerView: JLStickerImageView!
}
```

If you use Storyboard, you also need connect the UIImageView to `JLStikcerImageView` Class in Identity Inspector.
![](https://github.com/luiyezheng/JLStickerTextView/blob/master/Inspector.png)

### Add new Label

It is quite easy to add new label to current StickerImageView:
```Swift
stickerView.addLabel()
```

### Set the Label

You can set the color, font , alignment, alpha.... of the label.(<a href="#list">check all avaliable text attributes</a>)


```Swift
stickerView.textColor = UIColor.whiteColor()
```			

**Note**: when you set the properties, you make change to the current selected TextLabel.

### Render Text on Image

When you feel good, you are going to render the Text on Image and save the image:

```Swift
let image = stickerView.renderTextOnView(stickerView)
UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
```

### Customize the StickerTextView appearance 

Customize stickerTextView appearance is very strightforward:

```swift
//Set the image of close Button
stickerView.currentlyEditingLabel.closeView!.image = UIImage(named: "cancel")
//Set the image of rotate Button
stickerView.currentlyEditingLabel.rotateView?.image = UIImage(named: "rotate")
//Set the border color of textLabel
stickerView.currentlyEditingLabel.border?.strokeColor = UIColor.redColor().CGColor

```
**Note**: `closeView` and `rotateView` are both UIimageView, while `border` is CAShapeLayer

### Scale stickerView  proportionally

This function is not complete yet, I just make it to fit my requirement.

```
stickerView.limitImageViewToSuperView()
```

When you render the text on UIImageView whose content mode is AspectFit, it is possible you will get some unwanted border. This function will scale UIImageView to fit the image. 

<h2><a id="list">Avaliable Text Attributes Reference(Let's add more 😉)</a></h2>

|Key                                      | `JLStickerImageView` Property | value Type     |
| ------------------------- | ------------------------------ | ------------- |
| `Font`                                | `.fontName`                              | `String`            |
| `Alignment`                       | `.textAlignment`                       | `NSTextAlignment` |
| `Alpha`                              | `.textAlpha`                               | `CGFloat `      |
| `textColor`                        | `.textColor`                                | `UIColor`        |
| `lineSpacing`                    | `.lineSpacing`                            | `CGFloat`       |
|`TextShadow`                    | `.textShadowOffset`                 | `CGSize`         |
|     										 |	`.textShadowColor`                  | `UIColor`        |
|											 |	`.textShadowBlur`                    | `CGFloat`       |		

## Contributon

Any suggestion, request, pull are welcome. If you encounter any problem, feel free to create an issue.

If you want to add more text attributes:

1. Please fork this project
2. Define the attribute you want in `JLAttributedTextView.swift` 
3. implement user interface in `JLStickerImageVIew.swift`
4. Write appropriate docs and comments in the README.md
5. Submit a pull request

## Plan

Here are some ideas:

- [ ] More options for text(eg: lineSpacing)
- [x] Interface to customize the appearance of StickerLabelView(close Button, rotate button, border,etc)
- [ ] More general solution for Scaling stickerView proportionally
- [ ] Support placeholder

## Reference

Based on 

* [IQLabelView](https://github.com/kcandr/IQLabelView)

Also inspired by

*  [TextDrawer](https://github.com/remirobert/TextDrawer)
* [TextAttributes](https://github.com/delba/TextAttributes)

