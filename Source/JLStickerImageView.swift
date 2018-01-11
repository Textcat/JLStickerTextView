//
//  stickerView.swift
//  stickerTextView
//
//  Created by 刘业臻 on 16/4/20.
//  Copyright © 2016年 luiyezheng. All rights reserved.
//

import UIKit

public class JLStickerImageView: UIImageView, UIGestureRecognizerDelegate {
    public var currentlyEditingLabel: JLStickerLabelView!
    fileprivate var labels: NSMutableArray!
    private var renderedView: UIView!
    
    fileprivate lazy var tapOutsideGestureRecognizer: UITapGestureRecognizer! = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(JLStickerImageView.tapOutside))
        tapGesture.delegate = self
        return tapGesture
        
    }()
    
    //MARK: -
    //MARK: init

    
    init() {
        super.init(frame: CGRect.zero)
        isUserInteractionEnabled = true
        labels = []
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        labels = []
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isUserInteractionEnabled = true
        labels = []
    }
    
}

//MARK: -
//MARK: Functions
extension JLStickerImageView {
    public func addLabel() {
        if let label: JLStickerLabelView = currentlyEditingLabel {
            label.hideEditingHandlers()
        }
    
        let labelFrame = CGRect(x: bounds.midX - CGFloat(arc4random()).truncatingRemainder(dividingBy: 20),
                                    y: bounds.midY - CGFloat(arc4random()).truncatingRemainder(dividingBy: 20),
                                    width: 60, height: 50)
        let labelView = JLStickerLabelView(frame: labelFrame)
        labelView.delegate = self
        labelView.showsContentShadow = false
        //labelView.enableMoveRestriction = false
        labelView.borderColor = UIColor.white
        labelView.labelTextView.fontName = "Baskerville-BoldItalic"
        addSubview(labelView)
        currentlyEditingLabel = labelView
        adjustsWidthToFillItsContens(currentlyEditingLabel, labelView: currentlyEditingLabel.labelTextView)
        labels.add(labelView)

        addGestureRecognizer(tapOutsideGestureRecognizer)
        
    }
    
    public func renderTextOnView(_ view: UIView) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
        
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return img
    }
    
    public func limitImageViewToSuperView() {
        if superview == nil {
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = true
        let imageSize = self.image?.size
        let aspectRatio = imageSize!.width / imageSize!.height
        
        if let width = imageSize?.width, let height = imageSize?.height {
            if width > height {
                bounds.size.width = superview!.bounds.size.width
                bounds.size.height = superview!.bounds.size.width / aspectRatio
            }else {
                bounds.size.height = superview!.bounds.size.height
                bounds.size.width = superview!.bounds.size.height * aspectRatio
            }
            
        }
    }
    
}

//MARK-
//MARK: Gesture
extension JLStickerImageView {
    func tapOutside() {
        if let _: JLStickerLabelView = currentlyEditingLabel {
            currentlyEditingLabel.hideEditingHandlers()
        }
        
    }
}

//MARK-
//MARK: stickerViewDelegate
extension JLStickerImageView: JLStickerLabelViewDelegate {
    public func labelViewDidBeginEditing(_ label: JLStickerLabelView) {
        //labels.removeObject(label)
        
    }
    
    public func labelViewDidClose(_ label: JLStickerLabelView) {
        
    }
    
    public func labelViewDidShowEditingHandles(_ label: JLStickerLabelView) {
        currentlyEditingLabel = label
        
    }
    
    public func labelViewDidHideEditingHandles(_ label: JLStickerLabelView) {
        currentlyEditingLabel = nil
        
    }
    
    public func labelViewDidStartEditing(_ label: JLStickerLabelView) {
        currentlyEditingLabel = label
        
    }
    
    public func labelViewDidChangeEditing(_ label: JLStickerLabelView) {
        
    }
    
    public func labelViewDidEndEditing(_ label: JLStickerLabelView) {

        
    }
    
    public func labelViewDidSelected(_ label: JLStickerLabelView) {
        for labelItem in labels {
            if let label: JLStickerLabelView = labelItem as? JLStickerLabelView {
                label.hideEditingHandlers()
            }
        }
        
        label.showEditingHandles()
        
    }
    
}

//MARK: -
//MARK: Set propeties

extension JLStickerImageView: adjustFontSizeToFillRectProtocol {
    
    public enum textShadowPropterties {
        case offSet(CGSize)
        case color(UIColor)
        case blurRadius(CGFloat)
    }
    
    public var fontName: String! {
        set {
            if currentlyEditingLabel != nil {
                currentlyEditingLabel.labelTextView.fontName = newValue
                adjustsWidthToFillItsContens(currentlyEditingLabel, labelView: currentlyEditingLabel.labelTextView)

            }
        }
        get {
            return currentlyEditingLabel.labelTextView.fontName
        }
    }
    
    public var textColor: UIColor! {
        set {
            if currentlyEditingLabel != nil {
                currentlyEditingLabel.labelTextView.foregroundColor = newValue
            }
        }
        get {
            return currentlyEditingLabel.labelTextView.foregroundColor
        }
    }
    
    public var textAlpha: CGFloat! {
        set {
            if currentlyEditingLabel != nil {
                currentlyEditingLabel.labelTextView.textAlpha = newValue
            }
            
        }
        get {
            return currentlyEditingLabel.labelTextView.textAlpha
        }
    }
    
    //MARK: -
    //MARK: text Format
    
    public var textAlignment: NSTextAlignment! {
        set {
            if currentlyEditingLabel != nil {
                currentlyEditingLabel.labelTextView.alignment = newValue
            }
            
        }
        get {
            return currentlyEditingLabel.labelTextView.alignment
        }
    }
    
    public var lineSpacing: CGFloat! {
        set {
            if currentlyEditingLabel != nil {
                currentlyEditingLabel.labelTextView.lineSpacing = newValue
                adjustsWidthToFillItsContens(currentlyEditingLabel, labelView: currentlyEditingLabel.labelTextView)
            }
            
        }
        get {
            return currentlyEditingLabel.labelTextView.lineSpacing
            
        }
    }
    
    //MARK: -
    //MARK: text Background

    public var textBackgroundColor: UIColor! {
        set {
            if currentlyEditingLabel != nil {
                currentlyEditingLabel.labelTextView.textBackgroundColor = newValue
            }
            
        }
        
        get {
            return currentlyEditingLabel.labelTextView.textBackgroundColor
        }
    }
    
    public var textBackgroundAlpha: CGFloat! {
        set {
            if currentlyEditingLabel != nil {
                currentlyEditingLabel.labelTextView.textBackgroundAlpha = newValue
            }
            
        }
        get {
            return currentlyEditingLabel.labelTextView.textBackgroundAlpha

        }
    }
    
    //MARK: -
    //MARK: text shadow

    public var textShadowOffset: CGSize! {
        set {
            if currentlyEditingLabel != nil {
                currentlyEditingLabel.labelTextView.textShadowOffset = newValue
            }
            
        }
        get {
            return currentlyEditingLabel.labelTextView.shadow?.shadowOffset
        }
    }
    
    public var textShadowColor: UIColor! {
        set {
            if currentlyEditingLabel != nil {
                currentlyEditingLabel.labelTextView.textShadowColor = newValue
            }
            
        }
        get {
            return (currentlyEditingLabel.labelTextView.shadow?.shadowColor) as? UIColor
        }
    }
    
    public var textShadowBlur: CGFloat! {
        set {
            if currentlyEditingLabel != nil {
                currentlyEditingLabel.labelTextView.textShadowBlur = newValue
            }
            
        }
        get {
            return currentlyEditingLabel.labelTextView.shadow?.shadowBlurRadius
        }
    }
    
    
}
