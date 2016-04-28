//
//  JLAttributedTextView.swift
//  JLAttributesTextView
//
//  Created by 刘业臻 on 16/4/24.
//  Copyright © 2016年 luiyezheng. All rights reserved.
//

import UIKit

public class JLAttributedTextView: UITextView {

    
    public private(set) var textAttributes: [String: AnyObject] = [:]
    
    //MARK: -
    //MARK: Alpha
    public var textAlpha: CGFloat = 1 {
        didSet {
            textAttributes[NSForegroundColorAttributeName] = foregroundColor?.colorWithAlphaComponent(textAlpha)
            self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
        }
    }
    
    //MARK: -
    //MARK: Font
    
    public var fontName: String = "HelveticaNeue" {
        didSet {
            let font = UIFont(name: fontName, size: fontSize)
            textAttributes[NSFontAttributeName] = font
            self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
            
            self.font = font
        }
    }
    
    public var fontSize: CGFloat = 20 {
        didSet {
            let font = UIFont(name: fontName, size: fontSize)
            textAttributes[NSFontAttributeName] = font
            self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
            
            self.font = font
        }
    }
    
    //MARK: -
    //MARK: forgroundColor
    
    public var foregroundColor: UIColor? {
        didSet {
            textAttributes[NSForegroundColorAttributeName] = foregroundColor
            self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
        }
    }
    
    //MARK: -
    //MARK: backgroundColor
    public var textBackgroundColor: UIColor? {
        didSet {
            self.layer.backgroundColor = textBackgroundColor?.CGColor
            //textAttributes[NSBackgroundColorAttributeName] = textBackgroundColor
            //self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
        }
    }
    
    public var textBackgroundAlpha: CGFloat? {
        didSet {
            //textAttributes[NSBackgroundColorAttributeName] = textBackgroundColor?.colorWithAlphaComponent(textBackgroundAlpha!)
            //self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
            self.layer.backgroundColor = textBackgroundColor?.colorWithAlphaComponent(textBackgroundAlpha!).CGColor
        }
    }

    
    //MARK: -
    //MARK: Paragraph style

    public var paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle() {
        didSet {
            textAttributes[NSParagraphStyleAttributeName] = paragraphStyle
        }
    }

    public var alignment: NSTextAlignment {
        get {
            return paragraphStyle.alignment
        }
        set {
            paragraphStyle.alignment = newValue
            textAttributes[NSParagraphStyleAttributeName] = paragraphStyle
            self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
            
        }
    }
    
    public var lineSpacing: CGFloat {
        get {
            return paragraphStyle.lineSpacing
        }
        
        set {
            paragraphStyle.lineSpacing = newValue
            textAttributes[NSParagraphStyleAttributeName] = paragraphStyle
            self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
            
        }
    }
    
    public var paragraphSpacing: CGFloat {
        get {
            return paragraphStyle.paragraphSpacing
        }
        
        set {
            paragraphStyle.paragraphSpacing = newValue
            textAttributes[NSParagraphStyleAttributeName] = paragraphStyle
            self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
        }
    }
    
    #if os(iOS) || os(tvOS)
    //MARK: -
    //MARK: Shadow
    
    public var shadow: NSShadow? = NSShadow() {
        didSet {
            textAttributes[NSShadowAttributeName] = shadow
            textAttributes[NSParagraphStyleAttributeName] = paragraphStyle
            self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
        }
    }
    
    public var textShadowOffset: CGSize! {
        didSet {
            shadow?.shadowOffset = textShadowOffset
            textAttributes[NSShadowAttributeName] = shadow
            textAttributes[NSParagraphStyleAttributeName] = paragraphStyle
            self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
            
        }
    }
    
    public var textShadowColor: UIColor! {
        didSet {
            shadow?.shadowColor = textShadowColor
            textAttributes[NSShadowAttributeName] = shadow
            textAttributes[NSParagraphStyleAttributeName] = paragraphStyle
            self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
            
        }
    }
    
    public var textShadowBlur: CGFloat! {
        didSet {
            shadow?.shadowBlurRadius = textShadowBlur
            textAttributes[NSShadowAttributeName] = shadow
            textAttributes[NSParagraphStyleAttributeName] = paragraphStyle
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
        public func shadow(color color: AnyObject?, offset: CGSize, blurRadius: CGFloat) -> Self {
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
        public func shadow(shadow: NSShadow?) -> Self {
            self.shadow = shadow
            return self
        }
        

    }
#endif

//MARK: -
//MARK: CGRect of Cursor

extension JLAttributedTextView {
    override public func caretRectForPosition(position: UITextPosition) -> CGRect {
        var originalRect = super.caretRectForPosition(position)
        originalRect.size.height = self.font!.pointSize - self.font!.descender
        // "descender" is expressed as a negative value,
        // so to add its height you must subtract its value
        
        return originalRect
    }
    
}
































