//
//  stickerView.swift
//  stickerTextView
//
//  Created by 刘业臻 on 16/4/20.
//  Copyright © 2016年 luiyezheng. All rights reserved.
//

import UIKit

public class JLStickerImageView: UIImageView, UIGestureRecognizerDelegate {
    private var currentlyEditingLabel: JLStickerLabelView!
    private var labels: NSMutableArray!
    private var renderedView: UIView!
    
    private lazy var tapOutsideGestureRecognizer: UITapGestureRecognizer! = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(JLStickerImageView.tapOutside))
        tapGesture.delegate = self
        return tapGesture
        
    }()
    
    public var shouldLimitImageView = false {
        didSet {
        }
    }
    
    //MARK: -
    //MARK: init

    
    init() {
        super.init(frame: CGRectZero)
        userInteractionEnabled = true
        labels = []
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        userInteractionEnabled = true
        labels = []
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        userInteractionEnabled = true
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
    
        let labelFrame = CGRectMake(CGRectGetMidX(self.bounds) - CGFloat(arc4random()) % 20,
                                    CGRectGetMidY(self.bounds) - CGFloat(arc4random()) % 20,
                                    60, 50)
        let labelView = JLStickerLabelView(frame: labelFrame)
        labelView.delegate = self
        labelView.showsContentShadow = false
        labelView.enableMoveRestriction = false
        labelView.borderColor = UIColor.whiteColor()
        labelView.labelTextView.fontName = "Baskerville-BoldItalic"
        self.addSubview(labelView)
        self.currentlyEditingLabel = labelView
        adjustsWidthToFillItsContens(currentlyEditingLabel, labelView: currentlyEditingLabel.labelTextView)
        self.labels.addObject(labelView)

        self.addGestureRecognizer(tapOutsideGestureRecognizer)
        
    }
    
    public func renderTextOnView(view: UIView) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
        
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return img
    }
    
    public func limitImageViewToSuperView() {
        if self.superview == nil {
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = true
        let imageSize = self.image?.size
        let aspectRatio = imageSize!.width / imageSize!.height
        
        if imageSize?.width > imageSize?.height {
            self.bounds.size.width = self.superview!.bounds.size.width
            self.bounds.size.height = self.superview!.bounds.size.width / aspectRatio
        }else {
            self.bounds.size.height = self.superview!.bounds.size.height
            self.bounds.size.width = self.superview!.bounds.size.height * aspectRatio
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
    public func labelViewDidBeginEditing(label: JLStickerLabelView) {
        //labels.removeObject(label)
        
    }
    
    public func labelViewDidClose(label: JLStickerLabelView) {
        
    }
    
    public func labelViewDidShowEditingHandles(label: JLStickerLabelView) {
        currentlyEditingLabel = label
        
    }
    
    public func labelViewDidHideEditingHandles(label: JLStickerLabelView) {
        currentlyEditingLabel = nil
        
    }
    
    public func labelViewDidStartEditing(label: JLStickerLabelView) {
        currentlyEditingLabel = label
        
    }
    
    public func labelViewDidChangeEditing(label: JLStickerLabelView) {
        
    }
    
    public func labelViewDidEndEditing(label: JLStickerLabelView) {

        
    }
    
    public func labelViewDidSelected(label: JLStickerLabelView) {
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
    
    public var fontName: String! {
        set {
            self.currentlyEditingLabel.labelTextView.fontName = newValue
            adjustsWidthToFillItsContens(currentlyEditingLabel, labelView: currentlyEditingLabel.labelTextView)
        }
        get {
            return self.currentlyEditingLabel.labelTextView.fontName
        }
    }
    
    public var textColor: UIColor! {
        set {
            self.currentlyEditingLabel.labelTextView.foregroundColor = newValue
        }
        get {
            return self.currentlyEditingLabel.labelTextView.foregroundColor
        }
    }
    
    public var textAlpha: CGFloat! {
        set {
            self.currentlyEditingLabel.labelTextView.textAlpha = newValue
        }
        get {
            return self.currentlyEditingLabel.labelTextView.textAlpha
        }
    }
    
    public var textAlignment: NSTextAlignment! {
        set {
            self.currentlyEditingLabel.labelTextView.alignment = newValue
        }
        get {
            return self.currentlyEditingLabel.labelTextView.alignment
        }
    }
    
    public var lineSpacing: CGFloat! {
        set {
            self.currentlyEditingLabel.labelTextView.lineSpacing = newValue
            adjustsWidthToFillItsContens(currentlyEditingLabel, labelView: currentlyEditingLabel.labelTextView)
            
        }
        get {
            return self.currentlyEditingLabel.labelTextView.lineSpacing
            
        }
    }
    
    public var textBackgroundColor: UIColor! {
        set {
            self.currentlyEditingLabel.labelTextView.textBackgroundColor = newValue
        }
        
        get {
            return self.currentlyEditingLabel.labelTextView.textBackgroundColor
        }
    }
    
    public var textBackgroundAlpha: CGFloat! {
        set {
            self.currentlyEditingLabel.labelTextView.textBackgroundAlpha = newValue
        }
        get {
            return self.currentlyEditingLabel.labelTextView.textBackgroundAlpha
        }
    }
    
}
