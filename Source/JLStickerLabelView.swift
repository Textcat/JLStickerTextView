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
    
    fileprivate lazy var singleTapShowHide: UITapGestureRecognizer! = {
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
    
    fileprivate var lastTouchedView: JLStickerLabelView?
    
    var delegate: JLStickerLabelViewDelegate?
    
    fileprivate var globalInset: CGFloat?
    
    fileprivate var initialBounds: CGRect?
    fileprivate var initialDistance: CGFloat?
    
    fileprivate var beginningPoint: CGPoint?
    fileprivate var beginningCenter: CGPoint?
    
    fileprivate var touchLocation: CGPoint?
    
    fileprivate var deltaAngle: CGFloat?
    fileprivate var beginBounds: CGRect?
    
    public var border: CAShapeLayer?
    public var labelTextView: JLAttributedTextView!
    public var rotateView: UIImageView?
    public var closeView: UIImageView?
    fileprivate var backgroundImageView : UIImageView?
    
    fileprivate var isShowingEditingHandles = true
    
    public var borderColor: UIColor? {
        didSet {
            border?.strokeColor = borderColor?.cgColor
        }
    }
    
    public var backgroundImage: UIImage? {
        didSet {
            backgroundImageView = UIImageView(frame: bounds)
            backgroundImageView?.bounds = bounds
            backgroundImageView?.image = backgroundImage
            backgroundImageView?.contentMode = .scaleAspectFit
            backgroundImageView?.clipsToBounds = true
            backgroundColor = UIColor.clear
            if let view = backgroundImageView {
                addSubview(view)
                sendSubview(toBack: view)
            }
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
                layer.shadowColor = UIColor.black.cgColor
                layer.shadowOffset = CGSize(width: 0, height: 5)
                layer.shadowOpacity = 1.0
                layer.shadowRadius = 4.0
            }else {
                layer.shadowColor = UIColor.clear.cgColor
                layer.shadowOffset = CGSize.zero
                layer.shadowOpacity = 0.0
                layer.shadowRadius = 0.0
            }
        }
    }
    
    //MARK: -
    //MARK: didMoveToSuperView
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.superview != nil {
            showEditingHandles()
            refresh()
        }
        
    }
    
    //MARK: -
    //MARK: init
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
        adjustsWidthToFillItsContens(self, labelView: labelTextView)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if frame.size.width < 25 {
            bounds.size.width = 25
        }
        
        if frame.size.height < 25 {
            bounds.size.height = 25
        }
        
        setup()
        adjustsWidthToFillItsContens(self, labelView: labelTextView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        adjustsWidthToFillItsContens(self, labelView: labelTextView)
        
    }
    
    public override func layoutSubviews() {
        if ((labelTextView) != nil) {
            border?.path = UIBezierPath(rect: labelTextView.bounds).cgPath
            border?.frame = labelTextView.bounds
        }
    }
    
    func setup() {
        globalInset = 19
        
        backgroundColor = UIColor.clear
        autoresizingMask = [.flexibleHeight, .flexibleWidth]
        border?.strokeColor = UIColor(red: 33, green: 45, blue: 59, alpha: 1).cgColor
        
        setupLabelTextView()
        setupBorder()
        
        insertSubview(labelTextView!, at: 0)
        
        setupCloseAndRotateView()
        
        addGestureRecognizer(moveGestureRecognizer)
        addGestureRecognizer(singleTapShowHide)
        moveGestureRecognizer.require(toFail: closeTap)
        
        closeView!.addGestureRecognizer(closeTap)
        rotateView!.addGestureRecognizer(panRotateGesture)
        
        enableMoveRestriction = false
        enableClose = true
        enableRotate = true
        showsContentShadow = true
        
        showEditingHandles()
        labelTextView?.becomeFirstResponder()
        
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
            showEditingHandles()
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
    
    
    func contentTapped(_ recognizer: UITapGestureRecognizer) {
        if !isShowingEditingHandles {
            self.showEditingHandles()
            
            if let delegate: JLStickerLabelViewDelegate = delegate {
                delegate.labelViewDidSelected!(self)
            }
        }
        
    }
    
    func closeTap(_ recognizer: UITapGestureRecognizer) {
        self.removeFromSuperview()
        
        if let delegate: JLStickerLabelViewDelegate = delegate {
            if delegate.responds(to: #selector(JLStickerLabelViewDelegate.labelViewDidClose(_:))) {
                delegate.labelViewDidClose!(self)
            }
        }
    }
    
    func moveGesture(_ recognizer: UIPanGestureRecognizer) {
        if !isShowingEditingHandles {
            self.showEditingHandles()
            
            if let delegate: JLStickerLabelViewDelegate = delegate {
                delegate.labelViewDidSelected!(self)
            }
        }
        
        touchLocation = recognizer.location(in: superview)
        
        switch recognizer.state {
        case .began:
            beginningPoint = touchLocation
            beginningCenter = center
            
            center = estimatedCenter()
            beginBounds = bounds
            
            if let delegate: JLStickerLabelViewDelegate = delegate {
                delegate.labelViewDidBeginEditing!(self)
            }
            
        case .changed:
            center = estimatedCenter()
            
            
            if let delegate: JLStickerLabelViewDelegate = delegate {
                delegate.labelViewDidChangeEditing!(self)
            }
            
        case .ended:
            center = estimatedCenter()
            
            
            if let delegate: JLStickerLabelViewDelegate = delegate {
                delegate.labelViewDidEndEditing!(self)
            }
            
        default:break
            
        }
    }
    
    func rotateViewPanGesture(_ recognizer: UIPanGestureRecognizer) {
        touchLocation = recognizer.location(in: superview)
        
        let center = CalculateFunctions.CGRectGetCenter(frame)
        
        switch recognizer.state {
        case .began:
            deltaAngle = atan2(touchLocation!.y - center.y, touchLocation!.x - center.x) - CalculateFunctions.CGAffineTrasformGetAngle(transform)
            initialBounds = bounds
            initialDistance = CalculateFunctions.CGpointGetDistance(center, point2: touchLocation!)
            
            if let delegate: JLStickerLabelViewDelegate = delegate {
                if delegate.responds(to: #selector(JLStickerLabelViewDelegate.labelViewDidBeginEditing(_:))) {
                    delegate.labelViewDidBeginEditing!(self)
                }
            }
            
        case .changed:
            let ang = atan2(touchLocation!.y - center.y, touchLocation!.x - center.x)
            
            let angleDiff = deltaAngle! - ang
            transform = CGAffineTransform(rotationAngle: -angleDiff)
            layoutIfNeeded()
            
            //Finding scale between current touchPoint and previous touchPoint
            let scale = sqrtf(Float(CalculateFunctions.CGpointGetDistance(center, point2: touchLocation!)) / Float(initialDistance!))
            let scaleRect = CalculateFunctions.CGRectScale(initialBounds!, wScale: CGFloat(scale), hScale: CGFloat(scale))
            
            if scaleRect.size.width >= (1 + globalInset! * 2) && scaleRect.size.height >= (1 + globalInset! * 2) && self.labelTextView.text != "" {
                //  if fontSize < 100 || CGRectGetWidth(scaleRect) < CGRectGetWidth(self.bounds) {
                if scale < 1 && labelTextView.fontSize <= 9 {
                    
                }else {
                    adjustFontSizeToFillRect(scaleRect, view: self, labelView: labelTextView)
                    bounds = scaleRect
                    adjustsWidthToFillItsContens(self, labelView: labelTextView)
                    refresh()
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
    func setupLabelTextView() {
        labelTextView = JLAttributedTextView(frame: self.bounds.insetBy(dx: globalInset!, dy: globalInset!))
        labelTextView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        labelTextView?.clipsToBounds = true
        labelTextView?.delegate = self
        labelTextView?.backgroundColor = UIColor.clear
        labelTextView?.tintColor = UIColor(red: 33, green: 45, blue: 59, alpha: 1)
        labelTextView?.isScrollEnabled = false
        labelTextView.isSelectable = true
        labelTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        labelTextView?.text = "Tap to Edit"
        
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
        addSubview(closeView!)
        
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
        addSubview(rotateView!)
    }
    
}


//MARK: -
//MARK: Help funcitons
extension JLStickerLabelView {
    
    fileprivate func refresh() {
        if let superView: UIView = superview {
            if let transform: CGAffineTransform = superView.transform {
                let scale = CalculateFunctions.CGAffineTransformGetScale(transform)
                let t = CGAffineTransform(scaleX: scale.width, y: scale.height)
                closeView?.transform = t.inverted()
                rotateView?.transform = t.inverted()
                
                if (isShowingEditingHandles) {
                    if let border: CALayer = border {
                        labelTextView?.layer.addSublayer(border)
                    }
                }else {
                    border?.removeFromSuperlayer()
                }
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
        
        refresh()
        
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
    
    fileprivate func estimatedCenter() -> CGPoint{
        let newCenter: CGPoint!
        var newCenterX = beginningCenter!.x + (touchLocation!.x - beginningPoint!.x)
        var newCenterY = beginningCenter!.y + (touchLocation!.y - beginningPoint!.y)
        
        if (enableMoveRestriction) {
            if (!(newCenterX - 0.5 * frame.width > 0 &&
                newCenterX + 0.5 * frame.width < superview!.bounds.width)) {
                newCenterX = center.x;
            }
            if (!(newCenterY - 0.5 * frame.height > 0 &&
                newCenterY + 0.5 * frame.height < superview!.bounds.height)) {
                newCenterY = center.y;
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
































