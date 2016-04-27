//
//  JLStickerLabelView.swift
//  stickerTextView
//
//  Created by 刘业臻 on 16/4/19.
//  Copyright © 2016年 luiyezheng. All rights reserved.
//

import UIKit

public class JLStickerLabelView: UIView {
    private lazy var moveGestureRecognizer: UIPanGestureRecognizer! = {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(JLStickerLabelView.moveGesture(_:)))
        panRecognizer.delegate = self
        return panRecognizer
    }()
    
    private lazy var singleTapShowHide: UITapGestureRecognizer! = {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(JLStickerLabelView.contentTapped(_:)))
        tapRecognizer.delegate = self
        return tapRecognizer
    }()
    
    private lazy var closeTap: UITapGestureRecognizer! = {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: (#selector(JLStickerLabelView.closeTap(_:))))
        tapRecognizer.delegate = self
        return tapRecognizer
    }()
    
    private lazy var panRotateGesture: UIPanGestureRecognizer! = {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(JLStickerLabelView.rotateViewPanGesture(_:)))
        panRecognizer.delegate = self
        return panRecognizer
    }()
    
    private var lastTouchedView: JLStickerLabelView?
    
    var delegate: JLStickerLabelViewDelegate?
    
    private var globalInset: CGFloat?
    
    private var initialBounds: CGRect?
    private var initialDistance: CGFloat?
    
    private var beginningPoint: CGPoint?
    private var beginningCenter: CGPoint?
    
    private var touchLocation: CGPoint?
    
    private var deltaAngle: CGFloat?
    private var beginBounds: CGRect?
    
    private var boarder: CAShapeLayer?
    private var labelTextView: UITextView!
    private var rotateView: UIImageView?
    private var closeView: UIImageView?
    
    private var isShowingEditingHandles = true
    
    //MARK: -
    //MARK: Set Text Field
    
    public var textColor: UIColor? {
        didSet {
            labelTextView.textColor = textColor
        }
    }
    public var borderColor: UIColor? {
        didSet {
            boarder?.strokeColor = borderColor?.CGColor
        }
    }
    public var fontName: String = "Baskerville-BoldItalic" {
        didSet {
            labelTextView.font = UIFont(name: fontName, size: fontSize)
            adjustsWidthToFillItsContens()
        }
    }
    public var fontSize: CGFloat = 20 {
        didSet {
            labelTextView.font = UIFont(name: fontName, size: fontSize)
            
        }
    }
    
    public var textAlignment: NSTextAlignment = .Center {
        didSet {
            labelTextView.textAlignment = textAlignment
        }
    }
    
    public var textAlpha: CGFloat = 1 {
        didSet {
            labelTextView.textColor = labelTextView.textColor?.colorWithAlphaComponent(textAlpha)
        }
    }
    
    public var lineSpacing: CGFloat = 1 {
        didSet {
            
        }
    }
    
    //MARK: -
    //MARK: Set Control Buttons
    
    public var enableClose: Bool = true {
        didSet {
            closeView?.hidden = enableClose
            closeView?.userInteractionEnabled = enableClose
        }
    }
    public var enableRotate: Bool = true {
        didSet {
            rotateView?.hidden = enableRotate
            rotateView?.userInteractionEnabled = enableRotate
        }
    }
    public var enableMoveRestriction: Bool = true {
        didSet {
            
        }
    }
    public var showsContentShadow: Bool = false {
        didSet {
            if showsContentShadow {
                self.layer.shadowColor = UIColor.blackColor().CGColor
                self.layer.shadowOffset = CGSizeMake(0, 5)
                self.layer.shadowOpacity = 1.0
                self.layer.shadowRadius = 4.0
            }else {
                self.layer.shadowColor = UIColor.clearColor().CGColor
                self.layer.shadowOffset = CGSizeZero
                self.layer.shadowOpacity = 0.0
                self.layer.shadowRadius = 0.0
            }
        }
    }
    
    public var closeImage: UIImage? {
        didSet {
            closeView?.image = closeImage
        }
    }
    public var rotateImage: UIImage? {
        didSet {
            closeView?.image = rotateImage
        }
    }
    
    func setup() {
        globalInset = 12
        
        self.backgroundColor = UIColor.clearColor()
        self.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        borderColor = UIColor(red: 33, green: 45, blue: 59, alpha: 1)
        
        labelTextView = UITextView(frame: CGRectInset(self.bounds, globalInset!, globalInset!))
        labelTextView?.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        labelTextView?.clipsToBounds = true
        labelTextView?.delegate = self
        labelTextView?.backgroundColor = UIColor.clearColor()
        labelTextView?.tintColor = UIColor(red: 33, green: 45, blue: 59, alpha: 1)
        labelTextView?.textColor = UIColor.blackColor()
        labelTextView?.font = UIFont(name: "Baskerville-BoldItalic", size: 42)
        labelTextView?.scrollEnabled = false
        labelTextView.selectable = true
        labelTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        labelTextView?.text = "Tap to Edit"
        
        boarder = CAShapeLayer(layer: layer)
        boarder?.strokeColor = borderColor?.CGColor
        boarder?.fillColor = nil
        boarder?.lineDashPattern = [10, 2]
        boarder?.lineWidth = 8
        
        self.insertSubview(labelTextView!, atIndex: 0)
        
        closeView = UIImageView(frame: CGRectMake(0, 0, globalInset! * 2, globalInset! * 2))
        closeView?.autoresizingMask = [.FlexibleRightMargin, .FlexibleBottomMargin]
        closeView!.layer.borderColor = UIColor(red: 33, green: 45, blue: 59, alpha: 1).CGColor
        closeView!.layer.borderWidth = 2
        closeView?.contentMode = .ScaleAspectFill
        closeView?.clipsToBounds = true
        closeView?.backgroundColor = UIColor(red: 33, green: 45, blue: 59, alpha: 1)
        closeView?.layer.cornerRadius = globalInset! - 5
        self.closeImage = UIImage(named: "cross")
        closeView?.userInteractionEnabled = true
        self.addSubview(closeView!)
        
        rotateView = UIImageView(frame: CGRectMake(self.bounds.size.width - globalInset! * 2, self.bounds.size.height - globalInset! * 2, globalInset! * 2, globalInset! * 2))
        rotateView?.autoresizingMask = [.FlexibleLeftMargin, .FlexibleTopMargin]
        rotateView?.backgroundColor = UIColor.whiteColor()
        rotateView?.layer.cornerRadius =  globalInset! - 5
        rotateView?.layer.borderColor = UIColor(red: 33, green: 45, blue: 59, alpha: 1).CGColor
        rotateView?.layer.borderWidth = 2
        rotateView?.clipsToBounds = true
        rotateView?.contentMode = .Center
        rotateView?.userInteractionEnabled = true
        self.addSubview(rotateView!)
        
        self.addGestureRecognizer(moveGestureRecognizer)
        self.addGestureRecognizer(singleTapShowHide)
        closeView!.addGestureRecognizer(closeTap)
        rotateView!.addGestureRecognizer(panRotateGesture)
        moveGestureRecognizer.requireGestureRecognizerToFail(closeTap)
        
        self.enableMoveRestriction = false
        self.enableClose = true
        self.enableRotate = true
        self.showsContentShadow = true
        
        self.showEditingHandles()
        labelTextView?.becomeFirstResponder()
        
    }
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.superview != nil {
            self.showEditingHandles()
            self.refresh()
        }
        
    }
    
    init() {
        super.init(frame: CGRectZero)
        setup()
        adjustsWidthToFillItsContens()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if frame.size.width < 25 {
            self.bounds.size.width = 25
        }
        
        if frame.size.height < 25 {
            self.bounds.size.height = 25
        }
        
        setup()
        adjustsWidthToFillItsContens()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        adjustsWidthToFillItsContens()
        
    }
    
    public override func layoutSubviews() {
        if ((labelTextView) != nil) {
            boarder?.path = UIBezierPath(rect: labelTextView.bounds).CGPath
            boarder?.frame = labelTextView.bounds
        }
    }
    
}
//MARK: -
//MARK: labelTextViewDelegate
extension JLStickerLabelView: UITextViewDelegate {
    public func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if (isShowingEditingHandles) {
            return true
        }
        return false
    }
    
    public func textViewDidBeginEditing(textView: UITextView) {
        if let delegate: JLStickerLabelViewDelegate = delegate {
            if delegate.respondsToSelector(#selector(JLStickerLabelViewDelegate.labelViewDidStartEditing(_:))) {
                delegate.labelViewDidStartEditing!(self)
            }
        }
        if textView.text != "" {
            adjustsWidthToFillItsContens()
        }
        
        
    }
    
    public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (!isShowingEditingHandles) {
            self.showEditingHandles()
        }
        if textView.text != "" {
            adjustsWidthToFillItsContens()
        }
        
        return true
    }
    
    public func textViewDidChange(textView: UITextView) {
        if textView.text != "" {
            adjustsWidthToFillItsContens()
        }
        
    }
    
    public func textViewDidEndEditing(textView: UITextView) {
        if textView.text != "" {
            adjustsWidthToFillItsContens()
        }
        
    }
    
}
//MARK: -
//MARK: GestureRecognizer

extension JLStickerLabelView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == singleTapShowHide {
            return true
        }
        return false
    }
    
    
    func contentTapped(recognizer: UITapGestureRecognizer) {
        if !isShowingEditingHandles {
            self.showEditingHandles()
            
            if let delegate: JLStickerLabelViewDelegate = delegate {
                delegate.labelViewDidSelected!(self)
            }

        }
        
        
    }
    
    func closeTap(recognizer: UITapGestureRecognizer) {
        self.removeFromSuperview()
        
        if let delegate: JLStickerLabelViewDelegate = delegate {
            if delegate.respondsToSelector(#selector(JLStickerLabelViewDelegate.labelViewDidClose(_:))) {
                delegate.labelViewDidClose!(self)
            }
        }
    }
    
    func moveGesture(recognizer: UIPanGestureRecognizer) {
        if !isShowingEditingHandles {
            self.showEditingHandles()
            
            if let delegate: JLStickerLabelViewDelegate = delegate {
                delegate.labelViewDidSelected!(self)
            }
        }
        
        touchLocation = recognizer.locationInView(self.superview)
        
        switch recognizer.state {
        case .Began:
            beginningPoint = touchLocation
            beginningCenter = self.center
            
            self.center = self.estimatedCenter()
            beginBounds = self.bounds
            
            if let delegate: JLStickerLabelViewDelegate = delegate {
                delegate.labelViewDidBeginEditing!(self)
            }
            
            
            
        case .Changed:
            self.center = self.estimatedCenter()
            
            
            if let delegate: JLStickerLabelViewDelegate = delegate {
                delegate.labelViewDidChangeEditing!(self)
            }
            
            
        case .Ended:
            self.center = self.estimatedCenter()
            
            
            if let delegate: JLStickerLabelViewDelegate = delegate {
                delegate.labelViewDidEndEditing!(self)
            }
            
        default:break
            
        }
    }
    
    func rotateViewPanGesture(recognizer: UIPanGestureRecognizer) {
        touchLocation = recognizer.locationInView(self.superview)
        
        let center = CalculateFunctions.CGRectGetCenter(self.frame)
        
        switch recognizer.state {
        case .Began:
            deltaAngle = atan2(touchLocation!.y - center.y, touchLocation!.x - center.x) - CalculateFunctions.CGAffineTrasformGetAngle(self.transform)
            initialBounds = self.bounds
            initialDistance = CalculateFunctions.CGpointGetDistance(center, point2: touchLocation!)
            
            if let delegate: JLStickerLabelViewDelegate = delegate {
                if delegate.respondsToSelector(#selector(JLStickerLabelViewDelegate.labelViewDidBeginEditing(_:))) {
                    delegate.labelViewDidBeginEditing!(self)
                }
            }
            
        case .Changed:
            let ang = atan2(touchLocation!.y - center.y, touchLocation!.x - center.x)
            
            let angleDiff = deltaAngle! - ang
            self.transform = CGAffineTransformMakeRotation(-angleDiff)
            self.layoutIfNeeded()
            
            //Finding scale between current touchPoint and previous touchPoint
            let scale = sqrtf(Float(CalculateFunctions.CGpointGetDistance(center, point2: touchLocation!)) / Float(initialDistance!))
            let scaleRect = CalculateFunctions.CGRectScale(initialBounds!, wScale: CGFloat(scale), hScale: CGFloat(scale))
            
            if scaleRect.size.width >= (1 + globalInset! * 2) && scaleRect.size.height >= (1 + globalInset! * 2) && self.labelTextView.text != "" {
                //  if fontSize < 100 || CGRectGetWidth(scaleRect) < CGRectGetWidth(self.bounds) {
                if scale < 1 && fontSize <= 9 {
                    
                }else {
                    self.adjustFontSizeToFillRect(scaleRect)
                    self.bounds = scaleRect
                    self.adjustsWidthToFillItsContens()
                    self.refresh()
                    
                }
            }
            
            if let delegate: JLStickerLabelViewDelegate = delegate {
                if delegate.respondsToSelector(#selector(JLStickerLabelViewDelegate.labelViewDidChangeEditing(_:))) {
                    delegate.labelViewDidChangeEditing!(self)
                }
            }
        case .Ended:
            if let delegate: JLStickerLabelViewDelegate = delegate {
                if delegate.respondsToSelector(#selector(JLStickerLabelViewDelegate.labelViewDidEndEditing(_:))) {
                    delegate.labelViewDidEndEditing!(self)
                }
            }
            
            self.refresh()
            
            self.adjustsWidthToFillItsContens()
        default:break
            
        }
    }
    
}

//MARK: -
//MARK: Help funcitons
extension JLStickerLabelView {
    
    private func refresh() {
        if let superView: UIView = self.superview {
            if let transform: CGAffineTransform = superView.transform {
                let scale = CalculateFunctions.CGAffineTransformGetScale(transform)
                let t = CGAffineTransformMakeScale(scale.width, scale.height)
                self.closeView?.transform = CGAffineTransformInvert(t)
                self.rotateView?.transform = CGAffineTransformInvert(t)
                
                if (isShowingEditingHandles) {
                    if let border: CALayer = boarder {
                        self.labelTextView?.layer.addSublayer(border)
                    }
                }else {
                    boarder?.removeFromSuperlayer()
                }
            }
            
        }
        
    }
    
    public func hideEditingHandlers() {
        lastTouchedView = nil
        
        isShowingEditingHandles = false
        
        if enableClose {
            closeView?.hidden = true
        }
        if enableRotate {
            rotateView?.hidden = true
        }
        
        labelTextView.resignFirstResponder()
        
        self.refresh()
        
        if let delegate : JLStickerLabelViewDelegate = delegate {
            if delegate.respondsToSelector(#selector(JLStickerLabelViewDelegate.labelViewDidHideEditingHandles(_:))) {
                delegate.labelViewDidHideEditingHandles!(self)
            }
        }
        
    }
    
    public func showEditingHandles() {
        lastTouchedView?.hideEditingHandlers()
        
        isShowingEditingHandles = true
        
        lastTouchedView = self
        
        if enableClose {
            closeView?.hidden = false
        }
        
        if enableRotate {
            rotateView?.hidden = false
        }
        
        self.refresh()
        
        if let delegate: JLStickerLabelViewDelegate = delegate {
            if delegate.respondsToSelector(#selector(JLStickerLabelViewDelegate.labelViewDidShowEditingHandles(_:))) {
                delegate.labelViewDidShowEditingHandles!(self)
            }
        }
    }
    
    private func estimatedCenter() -> CGPoint{
        let newCenter: CGPoint!
        var newCenterX = beginningCenter!.x + (touchLocation!.x - beginningPoint!.x)
        var newCenterY = beginningCenter!.y + (touchLocation!.y - beginningPoint!.y)
        
        if (enableMoveRestriction) {
            if (!(newCenterX - 0.5 * CGRectGetWidth(self.frame) > 0 &&
                newCenterX + 0.5 * CGRectGetWidth(self.frame) < CGRectGetWidth(self.superview!.bounds))) {
                newCenterX = self.center.x;
            }
            if (!(newCenterY - 0.5 * CGRectGetHeight(self.frame) > 0 &&
                newCenterY + 0.5 * CGRectGetHeight(self.frame) < CGRectGetHeight(self.superview!.bounds))) {
                newCenterY = self.center.y;
            }
            newCenter = CGPointMake(newCenterX, newCenterY)
        }else {
            newCenter = CGPointMake(newCenterX, newCenterY)
        }
        return newCenter
        
    }
    
    private func adjustFontSizeToFillRect(newBounds: CGRect) {
        let stickerMaximumFontSize = 200
        let stickerMinimumFontSize = 9
        let text = self.labelTextView.text
        
        for (var i = stickerMaximumFontSize; i > stickerMinimumFontSize; i -= 1) {
            
            let font = UIFont(name: String(self.fontName), size: CGFloat(i))
            
            let attributedText = NSAttributedString(string: text, attributes: [NSFontAttributeName: font!])
            
            let rectSize = attributedText.boundingRectWithSize(CGSizeMake(CGRectGetWidth(newBounds) - 24, CGFloat.max), options: [.UsesLineFragmentOrigin, .UsesFontLeading], context: nil)
            
            if (CGRectGetHeight(rectSize) <= CGRectGetHeight(newBounds)) {
                self.fontSize = CGFloat(i) - 1
                break
            }
            
        }
    }
    
    private func adjustsWidthToFillItsContens() {
        let text = self.labelTextView.text
        
        let font = UIFont(name: String(self.fontName), size: self.fontSize)
        let attributedText = NSAttributedString( string: text, attributes: [NSFontAttributeName: font!])
        
        let recSize = attributedText.boundingRectWithSize(CGSizeMake(CGFloat.max, CGFloat.max), options: .UsesLineFragmentOrigin, context: nil)
        
        let w1 = (ceilf(Float(recSize.size.width)) + 24 < 50) ? self.labelTextView.bounds.size.width : CGFloat(ceilf(Float(recSize.size.width)) + 24)
        let h1 = (ceilf(Float(recSize.size.height)) + 24 < 50) ? 50 : CGFloat(ceilf(Float(recSize.size.height)) + 24)
        
        var viewFrame = self.bounds
        viewFrame.size.width = w1 + 24
        viewFrame.size.height = h1 + 18
        self.bounds = viewFrame
    }
    
}

@objc public protocol JLStickerLabelViewDelegate: NSObjectProtocol {
    /**
     *  Occurs when a touch gesture event occurs on close button.
     *
     *  @param label    A label object informing the delegate about action.
     */
    optional func labelViewDidClose(label: JLStickerLabelView) -> Void
    /**
     *  Occurs when border and control buttons was shown.
     *
     *  @param label    A label object informing the delegate about showing.
     */
    optional func labelViewDidShowEditingHandles(label: JLStickerLabelView) -> Void
    /**
     *  Occurs when border and control buttons was hidden.
     *
     *  @param label    A label object informing the delegate about hiding.
     */
    optional func labelViewDidHideEditingHandles(label: JLStickerLabelView) -> Void
    /**
     *  Occurs when label become first responder.
     *
     *  @param label    A label object informing the delegate about action.
     */
    optional func labelViewDidStartEditing(label: JLStickerLabelView) -> Void
    /**
     *  Occurs when label starts move or rotate.
     *
     *  @param label    A label object informing the delegate about action.
     */
    optional func labelViewDidBeginEditing(label: JLStickerLabelView) -> Void
    /**
     *  Occurs when label continues move or rotate.
     *
     *  @param label    A label object informing the delegate about action.
     */
    optional func labelViewDidChangeEditing(label: JLStickerLabelView) -> Void
    /**
     *  Occurs when label ends move or rotate.
     *
     *  @param label    A label object informing the delegate about action.
     */
    optional func labelViewDidEndEditing(label: JLStickerLabelView) -> Void
    
    
    
    
    optional func labelViewDidSelected(label: JLStickerLabelView) -> Void
    
}

































