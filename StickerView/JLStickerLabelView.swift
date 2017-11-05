//
//  JLStickerLabelView.swift
//  stickerTextView
//
//  Created by 刘业臻 on 16/4/19.
//  Copyright © 2016年 luiyezheng. All rights reserved.
//

import UIKit

public class JLStickerLabelView: UIView {
    //MARK: -
    //MARK: Gestures
    
    private lazy var moveGestureRecognizer: UIPanGestureRecognizer! = {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(JLStickerLabelView.moveGesture(_:)))
        panRecognizer.delegate = self
        return panRecognizer
    }()
    
    internal lazy var singleTapShowHide: UITapGestureRecognizer! = {
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
    
    //MARK: -
    //MARK: properties
    
    internal var lastTouchedView: JLStickerLabelView?
    
    var delegate: JLStickerLabelViewDelegate?
    
    internal var globalInset: CGFloat?
    
    internal var initialBounds: CGRect?
    internal var initialDistance: CGFloat?
    
    internal var beginningPoint: CGPoint?
    internal var beginningCenter: CGPoint?
    
    internal var touchLocation: CGPoint?
    
    internal var deltaAngle: CGFloat?
    internal var beginBounds: CGRect?
    
    public var border: CAShapeLayer?
    public var labelTextView: JLAttributedTextView!
    public var rotateView: UIImageView?
    public var closeView: UIImageView?
    
    internal var isShowingEditingHandles = true
    
    public var borderColor: UIColor? {
        didSet {
            border?.strokeColor = borderColor?.cgColor
        }
    }
    
    
    //MARK: -
    //MARK: Set Control Buttons
    
    public var enableClose: Bool = true {
        didSet {
            closeView?.isHidden = enableClose
            closeView?.isUserInteractionEnabled = enableClose
        }
    }
    public var enableRotate: Bool = true {
        didSet {
            rotateView?.isHidden = enableRotate
            rotateView?.isUserInteractionEnabled = enableRotate
        }
    }
    public var enableMoveRestriction: Bool = true {
        didSet {
            
        }
    }
    public var showsContentShadow: Bool = false {
        didSet {
            if showsContentShadow {
                self.layer.shadowColor = UIColor.black.cgColor
                self.layer.shadowOffset = CGSize(width: 0, height: 5)
                self.layer.shadowOpacity = 1.0
                self.layer.shadowRadius = 4.0
            }else {
                self.layer.shadowColor = UIColor.clear.cgColor
                self.layer.shadowOffset = CGSize.zero
                self.layer.shadowOpacity = 0.0
                self.layer.shadowRadius = 0.0
            }
        }
    }
    
    //MARK: -
    //MARK: didMoveToSuperView
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.superview != nil {
            self.showEditingHandles()
            self.refresh()
        }
        
    }
    
    //MARK: -
    //MARK: init
    
    init() {
        super.init(frame: CGRect.zero)
        setup(defaultText: nil)
        adjustsWidthToFillItsContens(self, labelView: labelTextView)
        
    }
    
    init(frame: CGRect, defaultText: String?) {
        super.init(frame: frame)
        
        if frame.size.width < 25 {
            self.bounds.size.width = 25
        }
        
        if frame.size.height < 25 {
            self.bounds.size.height = 25
        }
        
        self.setup(defaultText: defaultText)
        adjustsWidthToFillItsContens(self, labelView: labelTextView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup(defaultText: nil)
        adjustsWidthToFillItsContens(self, labelView: labelTextView)
        
    }
    
    public override func layoutSubviews() {
        if ((labelTextView) != nil) {
            border?.path = UIBezierPath(rect: labelTextView.bounds).cgPath
            border?.frame = labelTextView.bounds
        }
    }
    
    func setup(defaultText: String?) {
        self.globalInset = 19
        
        self.backgroundColor = UIColor.clear
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.border?.strokeColor = UIColor(red: 33, green: 45, blue: 59, alpha: 1).cgColor
        
        if let defaultText = defaultText {
            self.setupLabelTextView(defaultText: defaultText)
        } else {
            self.setupLabelTextView()
        }
        self.setupBorder()
        
        self.insertSubview(labelTextView!, at: 0)
        
        self.setupCloseAndRotateView()
        
        self.addGestureRecognizer(moveGestureRecognizer)
        self.addGestureRecognizer(singleTapShowHide)
        self.moveGestureRecognizer.require(toFail: closeTap)
        
        self.closeView!.addGestureRecognizer(closeTap)
        self.rotateView!.addGestureRecognizer(panRotateGesture)
        
        self.enableMoveRestriction = false
        self.enableClose = true
        self.enableRotate = true
        self.showsContentShadow = true
        
        self.showEditingHandles()
        self.labelTextView?.becomeFirstResponder()
        
    }
    
}

//MARK: -
//MARK: labelTextViewDelegate

extension JLStickerLabelView: UITextViewDelegate {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if (isShowingEditingHandles) {
            return true
        }
        return false
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        
        if let delegate: JLStickerLabelViewDelegate = delegate {
            if delegate.responds(to: #selector(JLStickerLabelViewDelegate.labelViewDidStartEditing(_:))) {
                delegate.labelViewDidStartEditing!(self)
            }
        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (!isShowingEditingHandles) {
            self.showEditingHandles()
        }
        //if textView.text != "" {
        //adjustsWidthToFillItsContens(self, labelView: labelTextView)
        //}
        
        return true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if textView.text != "" {
            adjustsWidthToFillItsContens(self, labelView: labelTextView)
            labelTextView.attributedText = NSAttributedString(string: labelTextView.text, attributes: labelTextView.textAttributes)
            
        }
    }
}
//MARK: -
//MARK: GestureRecognizer

extension JLStickerLabelView: UIGestureRecognizerDelegate, adjustFontSizeToFillRectProtocol {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == singleTapShowHide {
            return true
        }
        return false
    }
    
    
    @objc func contentTapped(_ recognizer: UITapGestureRecognizer) {
        if !isShowingEditingHandles {
            self.showEditingHandles()
            
            if let delegate: JLStickerLabelViewDelegate = delegate {
                delegate.labelViewDidSelected!(self)
            }
        }
        
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        self.removeFromSuperview()
        
        if let delegate: JLStickerLabelViewDelegate = delegate {
            if delegate.responds(to: #selector(JLStickerLabelViewDelegate.labelViewDidClose(_:))) {
                delegate.labelViewDidClose!(self)
            }
        }
    }
    
    @objc func moveGesture(_ recognizer: UIPanGestureRecognizer) {
        if !isShowingEditingHandles {
            self.showEditingHandles()
            
            if let delegate: JLStickerLabelViewDelegate = delegate {
                delegate.labelViewDidSelected!(self)
            }
        }
        
        self.touchLocation = recognizer.location(in: self.superview)
        
        switch recognizer.state {
        case .began:
            beginningPoint = touchLocation
            beginningCenter = self.center
            
            self.center = self.estimatedCenter()
            beginBounds = self.bounds
            
            if let delegate: JLStickerLabelViewDelegate = delegate {
                delegate.labelViewDidBeginEditing!(self)
            }
            
        case .changed:
            self.center = self.estimatedCenter()
            
            
            if let delegate: JLStickerLabelViewDelegate = delegate {
                delegate.labelViewDidChangeEditing!(self)
            }
            
        case .ended:
            self.center = self.estimatedCenter()
            
            
            if let delegate: JLStickerLabelViewDelegate = delegate {
                delegate.labelViewDidEndEditing!(self)
            }
            
        default:break
            
        }
    }
    
    @objc func rotateViewPanGesture(_ recognizer: UIPanGestureRecognizer) {
        touchLocation = recognizer.location(in: self.superview)
        
        let center = CalculateFunctions.CGRectGetCenter(self.frame)
        
        switch recognizer.state {
        case .began:
            deltaAngle = atan2(touchLocation!.y - center.y, touchLocation!.x - center.x) - CalculateFunctions.CGAffineTrasformGetAngle(self.transform)
            initialBounds = self.bounds
            initialDistance = CalculateFunctions.CGpointGetDistance(center, point2: touchLocation!)
            
            if let delegate: JLStickerLabelViewDelegate = delegate {
                if delegate.responds(to: #selector(JLStickerLabelViewDelegate.labelViewDidBeginEditing(_:))) {
                    delegate.labelViewDidBeginEditing!(self)
                }
            }
            
        case .changed:
            let ang = atan2(touchLocation!.y - center.y, touchLocation!.x - center.x)
            
            let angleDiff = deltaAngle! - ang
            self.transform = CGAffineTransform(rotationAngle: -angleDiff)
            self.layoutIfNeeded()
            
            //Finding scale between current touchPoint and previous touchPoint
            let scale = sqrtf(Float(CalculateFunctions.CGpointGetDistance(center, point2: touchLocation!)) / Float(initialDistance!))
            let scaleRect = CalculateFunctions.CGRectScale(initialBounds!, wScale: CGFloat(scale), hScale: CGFloat(scale))
            
            if scaleRect.size.width >= (1 + globalInset! * 2) && scaleRect.size.height >= (1 + globalInset! * 2) && self.labelTextView.text != "" {
                //  if fontSize < 100 || CGRectGetWidth(scaleRect) < CGRectGetWidth(self.bounds) {
                if scale < 1 && labelTextView.fontSize <= 9 {
                    
                }else {
                    self.adjustFontSizeToFillRect(scaleRect, view: self, labelView: labelTextView)
                    self.bounds = scaleRect
                    self.adjustsWidthToFillItsContens(self, labelView: labelTextView)
                    self.refresh()
                }
            }
            
            if let delegate: JLStickerLabelViewDelegate = delegate {
                if delegate.responds(to: #selector(JLStickerLabelViewDelegate.labelViewDidChangeEditing(_:))) {
                    delegate.labelViewDidChangeEditing!(self)
                }
            }
        case .ended:
            if let delegate: JLStickerLabelViewDelegate = delegate {
                if delegate.responds(to: #selector(JLStickerLabelViewDelegate.labelViewDidEndEditing(_:))) {
                    delegate.labelViewDidEndEditing!(self)
                }
            }
            
            self.refresh()
            
        //self.adjustsWidthToFillItsContens(self, labelView: labelTextView)
        default:break
            
        }
    }
}

//MARK: -
//MARK: setup
extension JLStickerLabelView {
    func setupLabelTextView(defaultText: String = "Tap to edit") {
        labelTextView = JLAttributedTextView(frame: self.bounds.insetBy(dx: globalInset!, dy: globalInset!))
        labelTextView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        labelTextView?.clipsToBounds = true
        labelTextView?.delegate = self
        labelTextView?.backgroundColor = UIColor.clear
        labelTextView?.tintColor = UIColor(red: 33, green: 45, blue: 59, alpha: 1)
        labelTextView?.isScrollEnabled = false
        labelTextView.isSelectable = true
        labelTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        labelTextView?.text = defaultText
        
    }
    
    func setupBorder() {
        border = CAShapeLayer(layer: layer)
        border?.strokeColor = borderColor?.cgColor
        border?.fillColor = nil
        border?.lineDashPattern = [10, 2]
        border?.lineWidth = 8
        
    }
    
    func setupCloseAndRotateView() {
        closeView = UIImageView(frame: CGRect(x: 0, y: 0, width: globalInset! * 2 - 6, height: globalInset! * 2 - 6))
        closeView?.autoresizingMask = [.flexibleRightMargin, .flexibleBottomMargin]
        closeView!.layer.borderColor = UIColor(red: 33, green: 45, blue: 59, alpha: 1).cgColor
        closeView!.layer.borderWidth = 3
        closeView?.contentMode = .scaleAspectFill
        closeView?.clipsToBounds = true
        closeView?.backgroundColor = UIColor.clear
        closeView?.layer.cornerRadius = globalInset! - 10
        closeView?.image = UIImage(named: "cancel")
        closeView?.isUserInteractionEnabled = true
        self.addSubview(closeView!)
        
        rotateView = UIImageView(frame: CGRect(x: self.bounds.size.width - globalInset! * 2, y: self.bounds.size.height - globalInset! * 2, width: globalInset! * 2 - 6, height: globalInset! * 2 - 6))
        rotateView?.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]
        rotateView?.backgroundColor = UIColor.clear
        rotateView?.layer.cornerRadius =  globalInset! - 10
        rotateView?.layer.borderColor = UIColor.white.cgColor
        rotateView?.layer.borderWidth = 3
        rotateView?.clipsToBounds = true
        //self.rotateImage = UIImage(named: "rotate-option")
        rotateView?.contentMode = .scaleAspectFit
        rotateView?.isUserInteractionEnabled = true
        self.addSubview(rotateView!)
    }
}


//MARK: -
//MARK: Help funcitons
extension JLStickerLabelView {
    
    internal func refresh() {
        if let superView: UIView = self.superview {
            let transform: CGAffineTransform = superView.transform
            let scale = CalculateFunctions.CGAffineTransformGetScale(transform)
            let t = CGAffineTransform(scaleX: scale.width, y: scale.height)
            self.closeView?.transform = t.inverted()
            self.rotateView?.transform = t.inverted()

            if (isShowingEditingHandles) {
                if let border: CALayer = border {
                    self.labelTextView?.layer.addSublayer(border)
                }
            }else {
                border?.removeFromSuperlayer()
            }
        }
    }

    public func hideEditingHandlers() {
        lastTouchedView = nil
        
        isShowingEditingHandles = false
        
        if enableClose {
            closeView?.isHidden = true
        }
        if enableRotate {
            rotateView?.isHidden = true
        }
        
        labelTextView.resignFirstResponder()
        
        self.refresh()
        
        if let delegate : JLStickerLabelViewDelegate = delegate {
            if delegate.responds(to: #selector(JLStickerLabelViewDelegate.labelViewDidHideEditingHandles(_:))) {
                delegate.labelViewDidHideEditingHandles!(self)
            }
        }
    }
    
    public func showEditingHandles() {
        lastTouchedView?.hideEditingHandlers()
        
        isShowingEditingHandles = true
        
        lastTouchedView = self
        
        if enableClose {
            closeView?.isHidden = false
        }
        
        if enableRotate {
            rotateView?.isHidden = false
        }
        
        self.refresh()
        
        if let delegate: JLStickerLabelViewDelegate = delegate {
            if delegate.responds(to: #selector(JLStickerLabelViewDelegate.labelViewDidShowEditingHandles(_:))) {
                delegate.labelViewDidShowEditingHandles!(self)
            }
        }
    }
    
    internal func estimatedCenter() -> CGPoint{
        let newCenter: CGPoint!
        var newCenterX = beginningCenter!.x + (touchLocation!.x - beginningPoint!.x)
        var newCenterY = beginningCenter!.y + (touchLocation!.y - beginningPoint!.y)
        
        if (enableMoveRestriction) {
            if (!(newCenterX - 0.5 * self.frame.width > 0 &&
                newCenterX + 0.5 * self.frame.width < self.superview!.bounds.width)) {
                newCenterX = self.center.x;
            }
            if (!(newCenterY - 0.5 * self.frame.height > 0 &&
                newCenterY + 0.5 * self.frame.height < self.superview!.bounds.height)) {
                newCenterY = self.center.y;
            }
            newCenter = CGPoint(x: newCenterX, y: newCenterY)
        }else {
            newCenter = CGPoint(x: newCenterX, y: newCenterY)
        }
        return newCenter
    }
}

//MARK: -
//MARK: delegate


@objc public protocol JLStickerLabelViewDelegate: NSObjectProtocol {
    /**
     *  Occurs when a touch gesture event occurs on close button.
     *
     *  @param label    A label object informing the delegate about action.
     */
    @objc optional func labelViewDidClose(_ label: JLStickerLabelView) -> Void
    /**
     *  Occurs when border and control buttons was shown.
     *
     *  @param label    A label object informing the delegate about showing.
     */
    @objc optional func labelViewDidShowEditingHandles(_ label: JLStickerLabelView) -> Void
    /**
     *  Occurs when border and control buttons was hidden.
     *
     *  @param label    A label object informing the delegate about hiding.
     */
    @objc optional func labelViewDidHideEditingHandles(_ label: JLStickerLabelView) -> Void
    /**
     *  Occurs when label become first responder.
     *
     *  @param label    A label object informing the delegate about action.
     */
    @objc optional func labelViewDidStartEditing(_ label: JLStickerLabelView) -> Void
    /**
     *  Occurs when label starts move or rotate.
     *
     *  @param label    A label object informing the delegate about action.
     */
    @objc optional func labelViewDidBeginEditing(_ label: JLStickerLabelView) -> Void
    /**
     *  Occurs when label continues move or rotate.
     *
     *  @param label    A label object informing the delegate about action.
     */
    @objc optional func labelViewDidChangeEditing(_ label: JLStickerLabelView) -> Void
    /**
     *  Occurs when label ends move or rotate.
     *
     *  @param label    A label object informing the delegate about action.
     */
    @objc optional func labelViewDidEndEditing(_ label: JLStickerLabelView) -> Void
    
    @objc optional func labelViewDidSelected(_ label: JLStickerLabelView) -> Void
}
































