//
//  JLAttributedTextView.swift
//  JLAttributesTextView
//
//  Created by 刘业臻 on 16/4/24.
//  Copyright © 2016年 luiyezheng. All rights reserved.
//

import UIKit

public class JLAttributedTextView: UITextView {

    
    public private(set) var textAttributes: [NSAttributedString.Key: AnyObject] = [:]
    
    //MARK: -
    //MARK: Alpha
    public var textAlpha: CGFloat = 1 {
        didSet {
            textAttributes[NSAttributedString.Key.foregroundColor] = foregroundColor?.withAlphaComponent(textAlpha)
            self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
        }
    }
    
    //MARK: -
    //MARK: Font
    
    public var fontName: String = "HelveticaNeue" {
        didSet {
            let font = UIFont(name: fontName, size: fontSize)
            textAttributes[NSAttributedString.Key.font] = font
            self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
            
            self.font = font
        }
    }
    
    public var fontSize: CGFloat = 20 {
        didSet {
            let font = UIFont(name: fontName, size: fontSize)
            textAttributes[NSAttributedString.Key.font] = font
            self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
            
            self.font = font
        }
    }
    
    //MARK: -
    //MARK: forgroundColor
    
    public var foregroundColor: UIColor? {
        didSet {
            textAttributes[NSAttributedString.Key.foregroundColor] = foregroundColor
            self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
        }
    }
    
    //MARK: -
    //MARK: backgroundColor
    public var textBackgroundColor: UIColor? {
        didSet {
            self.layer.backgroundColor = textBackgroundColor?.cgColor
            //textAttributes[NSBackgroundColorAttributeName] = textBackgroundColor
            //self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
        }
    }
    
    public var textBackgroundAlpha: CGFloat? {
        didSet {
            //textAttributes[NSBackgroundColorAttributeName] = textBackgroundColor?.colorWithAlphaComponent(textBackgroundAlpha!)
            //self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
            self.layer.backgroundColor = textBackgroundColor?.withAlphaComponent(textBackgroundAlpha!).cgColor
        }
    }

    
    //MARK: -
    //MARK: Paragraph style

    public var paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle() {
        didSet {
            textAttributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        }
    }

    public var alignment: NSTextAlignment {
        get {
            return paragraphStyle.alignment
        }
        set {
            paragraphStyle.alignment = newValue
            textAttributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
            self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
            
        }
    }
    
    public var lineSpacing: CGFloat {
        get {
            return paragraphStyle.lineSpacing
        }
        
        set {
            paragraphStyle.lineSpacing = newValue
            textAttributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
            self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
            
        }
    }
    
    public var paragraphSpacing: CGFloat {
        get {
            return paragraphStyle.paragraphSpacing
        }
        
        set {
            paragraphStyle.paragraphSpacing = newValue
            textAttributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
            self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
        }
    }
    
    #if os(iOS) || os(tvOS)
    //MARK: -
    //MARK: Shadow
    
    public var shadow: NSShadow? = NSShadow() {
        didSet {
            textAttributes[NSAttributedString.Key.shadow] = shadow
            textAttributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
            self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
        }
    }
    
    public var textShadowOffset: CGSize! {
        didSet {
            shadow?.shadowOffset = textShadowOffset
            textAttributes[NSAttributedString.Key.shadow] = shadow
            textAttributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
            self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
            
        }
    }
    
    public var textShadowColor: UIColor! {
        didSet {
            shadow?.shadowColor = textShadowColor
            textAttributes[NSAttributedString.Key.shadow] = shadow
            textAttributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
            self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
            
        }
    }
    
    public var textShadowBlur: CGFloat! {
        didSet {
            shadow?.shadowBlurRadius = textShadowBlur
            textAttributes[NSAttributedString.Key.shadow] = shadow
            textAttributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
            self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
            
        }
    }

    #endif
    
}

#if os(iOS) || os(tvOS)
    extension JLAttributedTextView {
        // MARK: - Shadow
        
        /**
         Sets the shadow attribute and returns the receiver.
         
         - parameter color:      The color of the shadow.
         - parameter offset:     The offset values of the shadow.
         - parameter blurRadius: The blur radius of the shadow.
         
         - returns: The receiver.
         */
        public func shadow(color: AnyObject?, offset: CGSize, blurRadius: CGFloat) -> Self {
            return shadow({
                let shadow = NSShadow()
                shadow.shadowColor = color
                shadow.shadowOffset = offset
                shadow.shadowBlurRadius = blurRadius
                return shadow
                }() as NSShadow)
        }
        
        /**
         Sets the shadow attribute and returns the receiver.
         
         - parameter shadow: The shadow.
         
         - returns: The receiver.
         */
        public func shadow(_ shadow: NSShadow?) -> Self {
            self.shadow = shadow
            return self
        }
        

    }
#endif

//MARK: -
//MARK: CGRect of Cursor

extension JLAttributedTextView {
    override public func caretRect(for position: UITextPosition) -> CGRect {
        var originalRect = super.caretRect(for: position)
        originalRect.size.height = self.font!.pointSize - self.font!.descender
        // "descender" is expressed as a negative value,
        // so to add its height you must subtract its value
        
        return originalRect
    }
    
}
