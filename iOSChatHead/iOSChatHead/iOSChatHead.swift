//
//  iOSChatHead.swift
//  iOSChatHead
//
//  Created by iMac on 10/23/18.
//  Copyright © 2018 jriosdev. All rights reserved.
//
import UIKit

let autoDockingDuration: Double = 0.2
let doubleTapTimeInterval: Double = 0.36

public class iOSChatHead: UIButton {
    var draggable: Bool = true
    var dragging: Bool = false
    var autoDocking: Bool = true
    var singleTapBeenCanceled: Bool = false
    fileprivate var badgeLabel: UILabel?
    
    var beginLocation: CGPoint?
    var longPressGestureRecognizer: UILongPressGestureRecognizer?
    
    // actions call back
    var tapBlock:(()->Void)? { // computed
        set(tapBlock) {
            if let aTapBlock = tapBlock {
                self.tapBlockStored = aTapBlock
                self.addTarget(self, action: #selector(tapAction),
                               for: .touchUpInside)
            }
        }
        get {
            return self.tapBlockStored!
        }
    }
    private var tapBlockStored:(()->Void)?
    
    var doubleTapBlock:(()->Void)?
    var longPressBlock:(()->Void)?
    var draggingBlock:(()->Void)?
    var dragDoneBlock:(()->Void)?
    var autoDockingBlock:(()->Void)?
    var autoDockingDoneBlock:(()->Void)?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.translatesAutoresizingMaskIntoConstraints = true 
        self.configDefaultSettingWithType()
        badgeLabel = UILabel()
        setupBadgeViewWithString(badgeText: "")
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addButtonToKeyWindow()
        self.configDefaultSettingWithType()
        badgeLabel = UILabel()
        setupBadgeViewWithString(badgeText: "")
    }
    
    public init(view: AnyObject, frame: CGRect) {
        super.init(frame: frame)
        view.addSubview(self)
        self.configDefaultSettingWithType()
        badgeLabel = UILabel()
        setupBadgeViewWithString(badgeText: "")
    }
    
    public func addButtonToKeyWindow() {
        if let keyWindow = UIApplication.shared.keyWindow {
            keyWindow.addSubview(self)
        } else if (UIApplication.shared.windows.first != nil) {
            UIApplication.shared.windows.first?.addSubview(self)
        }
    }
    
    private func configDefaultSettingWithType() {
        
        // gestures
        self.longPressGestureRecognizer = UILongPressGestureRecognizer.init()
        if let longPressGestureRecognizer = self.longPressGestureRecognizer {
            longPressGestureRecognizer.addTarget(self, action:#selector(longPressHandler) )
            longPressGestureRecognizer.allowableMovement = 0
            self.addGestureRecognizer(longPressGestureRecognizer)
        }
    }
    
    // MARK: Gestures Handler
    @objc func longPressHandler(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            if let longPressBlock = self.longPressBlock {
                longPressBlock()
            }
            break
        default:
            break
        }
    }
    
    // MARK: Actions
    @objc func tapAction(sender: AnyObject) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            if let tapBlock = self.tapBlock {
                if (!self.singleTapBeenCanceled
                    && !self.dragging) {
                    tapBlock();
                }
            }
        }
    }
    
    // MARK: Touch
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.dragging = false
        super.touchesBegan(touches, with: event)
        let touch: UITouch? = (touches as NSSet).anyObject() as? UITouch
        if touch?.tapCount == 2 {
            self.doubleTapBlock?()
            self.singleTapBeenCanceled = true
        } else {
            self.singleTapBeenCanceled = false
        }
        self.beginLocation = ((touches as NSSet).anyObject() as AnyObject).location(in:self)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        if self.draggable  {
            self.dragging = true
            let touch: UITouch? = (touches as NSSet).anyObject() as? UITouch
            let currentLocation: CGPoint? = touch?.location(in: self)
            
            let offsetX: CGFloat? = (currentLocation?.x)! - (self.beginLocation?.x)!
            let offsetY: CGFloat? = (currentLocation?.y)! - (self.beginLocation?.y)!
            self.center = CGPoint(x: self.center.x + offsetX!, y: self.center.y + offsetY!)
            //self.center = CGPoint(self.center.x + offsetX!, self.center.y + offsetY!)
            
            let superviewFrame: CGRect? = self.superview?.frame
            let frame: CGRect = self.frame
            let leftLimitX: CGFloat = frame.size.width / 2.0
            let rightLimitX: CGFloat = (superviewFrame?.size.width)! - leftLimitX
            let topLimitY: CGFloat = frame.size.height / 2.0
            let bottomLimitY: CGFloat = (superviewFrame?.size.height)! - topLimitY
            
            if (self.center.x > rightLimitX) {
                self.center = CGPoint(x:rightLimitX, y:self.center.y)
            } else if (self.center.x <= leftLimitX) {
                self.center = CGPoint(x:leftLimitX, y:self.center.y)
            }
            
            if (self.center.y > bottomLimitY) {
                self.center = CGPoint(x:self.center.x, y:bottomLimitY)
            } else if (self.center.y <= topLimitY) {
                self.center = CGPoint(x:self.center.x, y:topLimitY)
            }
            
            self.draggingBlock?()
        }
    }
    
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if (self.dragging && self.dragDoneBlock != nil) {
            self.dragDoneBlock!()
            self.singleTapBeenCanceled = true;
        }
        if (self.dragging && self.autoDocking) {
            let superviewFrame: CGRect? = self.superview?.frame
            let frame: CGRect = self.frame
            let middleX: CGFloat? = (superviewFrame?.size.width)! / 2.0
            if (self.center.x >= middleX!) {
                UIView.animate(withDuration: autoDockingDuration,
                               animations: {
                                self.center = CGPoint(x:(superviewFrame?.size.width)! - frame.size.width / 2.0, y:self.center.y)
                                self.anchor = 0
                                self.autoDockingBlock?()
                },
                               completion: { (finished) in
                                self.autoDockingDoneBlock?()
                                self.singleTapBeenCanceled = true
                })
            } else {
                UIView.animate(withDuration: autoDockingDuration,
                               animations: {
                                self.center = CGPoint(x:frame.size.width / 2, y:self.center.y)
                                self.anchor = 1
                                self.autoDockingBlock?()
                },
                               completion: { (finished) in
                                self.autoDockingDoneBlock?()
                                self.singleTapBeenCanceled = true
                })
            }
        }
        self.dragging = false
        
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dragging = false
        super.touchesCancelled(touches, with:event)
    }
    
    // MARK: Remove
    class func removeAllFromKeyWindow() {
        if let subviews = UIApplication.shared.keyWindow?.subviews {
            for view: AnyObject in subviews {
                if view.isKind(of: iOSChatHead.self) {
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    class func removeAllFromView(superView : AnyObject) {
        if let subviews = superView.subviews {
            for view: AnyObject in subviews {
                if view.isKind(of: iOSChatHead.self) {
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    
    open var badgeString: String? {
        didSet {
            setupBadgeViewWithString(badgeText: badgeString)
        }
    }
    
    
    /**  Factor that can change corner radius of badge
     
     This value will be calculate like:
     (Badge Label Height) / (this value)
     **/
    open var cornerRadiusFactor : CGFloat = 2{
        
        didSet{
            setupBadgeViewWithString(badgeText: badgeString)
        }
    }
    
    /**
     Vertical margin in badge
     This is the space between text and badge's vertical edge
     **/
    fileprivate var innerVerticalMargin : CGFloat = 5.0{
        
        didSet{
            setupBadgeViewWithString(badgeText: badgeString)
        }
    }
    
    /**
     Horizontal margin in badge
     This is the space between text and badge's horizontal edge
     **/
    fileprivate var innerHorizontalMargin : CGFloat = 10.0{
        
        didSet{
            setupBadgeViewWithString(badgeText: badgeString)
        }
    }
    
    /**
     Vertical margin in badge
     This is the space between text and badge's vertical edge
     **/
    open var verticalMargin : CGFloat{
        
        set{
            
            self.innerVerticalMargin = max(0, newValue)
        }
        
        get{
            
            return innerVerticalMargin
        }
    }
    
    /**
     Horizontal margin in badge
     This is the space between text and badge's horizontal edge
     **/
    
    open var horizontalMargin : CGFloat{
        
        set{
            self.innerHorizontalMargin = max(0, newValue)
        }
        
        get{
            
            return innerHorizontalMargin
        }
    }
    
    open var badgeEdgeInsets: UIEdgeInsets? {
        didSet {
            setupBadgeViewWithString(badgeText: badgeString)
        }
    }
    
    open var badgeBackgroundColor : UIColor = UIColor.red {
        didSet {
            badgeLabel?.backgroundColor = badgeBackgroundColor
        }
    }
    
    @IBInspectable
    open var badgeTextColor : UIColor = UIColor.white {
        didSet {
            badgeLabel?.textColor = badgeTextColor
        }
    }
    
    /**
     Can be adjust from Interface Builder
     EdgeInsetLeft
     **/
    open var edgeInsetLeft : CGFloat{
        set{
            
            if let edgeInset = badgeEdgeInsets{
                
                self.badgeEdgeInsets = UIEdgeInsets(top: edgeInset.top, left: newValue, bottom: edgeInset.bottom, right: edgeInset.right)
            }
            else{
                
                self.badgeEdgeInsets = UIEdgeInsets(top: 0.0, left: newValue, bottom: 0.0, right: 0.0)
            }
        }
        get{
            
            if let edgeInset = badgeEdgeInsets{
                return edgeInset.left
            }
            
            return 0.0
        }
    }
    
    /**
     Can be adjust from Interface Builder
     EdgeInsetRight
     **/
    open var edgeInsetRight : CGFloat{
        set{
            
            if let edgeInset = badgeEdgeInsets{
                
                self.badgeEdgeInsets = UIEdgeInsets(top: edgeInset.top, left: edgeInset.left, bottom: edgeInset.bottom, right: newValue)
            }
            else{
                
                self.badgeEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: newValue)
            }
        }
        get{
            
            if let edgeInset = badgeEdgeInsets{
                return edgeInset.right
            }
            
            return 0.0
        }
    }
    
    /**
     Can be adjust from Interface Builder
     EdgeInsetTop
     **/
    open var edgeInsetTop : CGFloat{
        set{
            
            if let edgeInset = badgeEdgeInsets{
                
                self.badgeEdgeInsets = UIEdgeInsets(top: newValue, left: edgeInset.left, bottom: edgeInset.bottom, right: edgeInset.right)
            }
            else{
                
                self.badgeEdgeInsets = UIEdgeInsets(top: newValue, left: 0.0, bottom: 0.0, right: 0.0)
            }
        }
        get{
            
            if let edgeInset = badgeEdgeInsets{
                return edgeInset.top
            }
            
            return 0.0
        }
    }
    
    /**
     Can be adjust from Interface Builder
     EdgeInsetBottom
     **/
    open var edgeInsetBottom : CGFloat{
        set{
            
            if let edgeInset = badgeEdgeInsets{
                
                self.badgeEdgeInsets = UIEdgeInsets(top: edgeInset.top, left: edgeInset.left, bottom: newValue, right: edgeInset.right)
            }
            else{
                
                self.badgeEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: newValue, right: 0.0)
            }
        }
        get{
            
            if let edgeInset = badgeEdgeInsets{
                return edgeInset.bottom
            }
            
            return 0.0
        }
    }
    
    /**
     Badge's anchor. TopLeft, TopRight, BottomLeft, BottomRight and Center
     Offset is required depend on anchor. Assign 0.0 if don't need offset
     
     Note: badgeEdgeInsets are taking into count when calculate position
     **/
    open var badgeAnchor : Anchor = .TopRight(topOffset: 0.0, rightOffset: 0.0){
        didSet{
            setupBadgeViewWithString(badgeText: badgeString)
        }
    }
    
    /**
     AnchorIndex is an Integer value from 0 to 4 each value represent different anchor of badge
     
     0 = TopLeft
     
     1 = TopRight
     
     2 = BottomLeft
     
     3 = BottomRight
     
     4 = Center
     **/
    fileprivate var anchorIndex : Int = 0{
        didSet{
            
            switch anchorIndex {
            case 0:
                self.badgeAnchor = .TopLeft(topOffset: topOffset, leftOffset: leftOffset)
                break
            case 1:
                self.badgeAnchor = .TopRight(topOffset: topOffset, rightOffset: rightOffset)
                break
            case 2:
                self.badgeAnchor = .BottomLeft(bottomOffset: buttomOffset, leftOffset: leftOffset)
                break
            case 3:
                self.badgeAnchor = .BottomRight(bottomOffset: buttomOffset, rightOffset: rightOffset)
                break
            case 4:
                self.badgeAnchor = .center
                break
            default:
                print("Unknow anchor position. Fallback to default")
                self.anchorIndex  = 1
            }
        }
    }
    
    /**
     It represent different anchor on button
     Values are:0 = TopLeft,1 = TopRight,2 = BottomLeft,3 = BottomRight,4 = Center
     **/
    open var anchor : Int{
        set{
            
            self.anchorIndex = min(max(0, newValue), 4)
        }
        
        get{
            return self.anchorIndex
        }
    }
    
    /**
     Can be adjust from Interface Builder
     Left offset of anchor
     
     Value is effect when anchor are:
     
     TopLeft
     
     BottomLeft
     **/
    open var leftOffset : CGFloat = 0{
        didSet{
            
            //get anchor of index and assign to anchorIndex
            //to trigger view to update
            let ach = anchor
            self.anchorIndex = ach
        }
    }
    
    /**
     Can be adjust from Interface Builder
     Right offset of anchor
     
     Value is effect when anchor are:
     
     TopRight
     
     BottomRight
     **/
    open var rightOffset : CGFloat = 0{
        didSet{
            let ach = anchor
            self.anchorIndex = ach
        }
    }
    
    /**
     Can be adjust from Interface Builder
     Top offset of anchor
     
     Value is effect when anchor are:
     
     TopLeft
     
     TopRight
     **/
    open var topOffset : CGFloat = 0{
        didSet{
            let ach = anchor
            self.anchorIndex = ach
        }
    }
    
    /**
     Can be adjust from Interface Builder
     Bottom offset of anchor
     
     Value is effect when anchor are:
     
     BottomLeft
     
     BottomRight
     **/
    open var buttomOffset : CGFloat = 0{
        didSet{
            let ach = anchor
            self.anchorIndex = ach
        }
    }
    
    
    
    open func initWithFrame(frame: CGRect, withBadgeString badgeString: String, withBadgeInsets badgeInsets: UIEdgeInsets, badgeAnchor : Anchor = .TopRight(topOffset: 0.0, rightOffset: 0.0)) -> AnyObject {
        
        badgeLabel = UILabel()
        badgeEdgeInsets = badgeInsets
        self.badgeAnchor = badgeAnchor
        setupBadgeViewWithString(badgeText: badgeString)
        return self
    }
    
    
    fileprivate func setupBadgeViewWithString(badgeText: String?){
        badgeLabel?.clipsToBounds = true
        badgeLabel?.text = badgeText
        badgeLabel?.font = UIFont.systemFont(ofSize: 12)
        badgeLabel?.textAlignment = .center
        badgeLabel?.sizeToFit()
        let badgeSize = badgeLabel?.bounds.size
        
        let height = max(20, CGFloat(badgeSize?.height ?? 50) + innerVerticalMargin)
        let width = max(height, CGFloat(badgeSize?.width ?? 50) + innerHorizontalMargin)
        
        var vertical: CGFloat, horizontal: CGFloat
        var x : CGFloat = 0, y : CGFloat = 0
        
        if let badgeInset = self.badgeEdgeInsets{
            
            vertical = CGFloat(badgeInset.top) - CGFloat(badgeInset.bottom)
            horizontal = CGFloat(badgeInset.left) - CGFloat(badgeInset.right)
            
        }
        else{
            
            vertical = 0.0
            horizontal = 0.0
        }
        
        //calculate badge X Y position
        calculateXYForBadge(x: &x, y: &y, badgeSize: CGSize(width: width, height: height))
        
        //add badgeEdgeInset
        x = x + horizontal
        y = y + vertical
        
        badgeLabel?.frame = CGRect(x: x, y: y, width: width, height: height)
        
        setupBadgeStyle()
        addSubview(badgeLabel!)
        
        if let text = badgeText {
            badgeLabel?.isHidden = text != "" ? false : true
        } else {
            badgeLabel?.isHidden = true
        }
        
    }
    
    /**
     Calculate badge's X Y position.
     Offset are taking into count
     **/
    fileprivate func calculateXYForBadge(x : inout CGFloat, y : inout CGFloat, badgeSize : CGSize){
        
        switch self.badgeAnchor {
            
        case .TopLeft(let topOffset, let leftOffset):
            x = -badgeSize.width/2 + leftOffset
            y = -badgeSize.height/2 + topOffset
            break
            
        case .TopRight(let topOffset, let rightOffset):
            x = self.bounds.size.width - badgeSize.width/2 + rightOffset
            y = -badgeSize.height/2 + topOffset
            break
            
        case .BottomLeft(let bottomOffset, let leftOffset):
            x = -badgeSize.width/2 + leftOffset
            y = self.bounds.size.height - badgeSize.height/2 + bottomOffset
            break
        case .BottomRight(let bottomOffset, let rightOffset):
            x = self.bounds.size.width - badgeSize.width/2 + rightOffset
            y = self.bounds.size.height - badgeSize.height/2 + bottomOffset
            break
        case .center:
            x = self.bounds.size.width/2 - badgeSize.width/2
            y = self.bounds.size.height/2 - badgeSize.height/2
            break
        }
    }
    
    fileprivate func setupBadgeStyle() {
        badgeLabel?.textAlignment = .center
        badgeLabel?.backgroundColor = badgeBackgroundColor
        badgeLabel?.textColor = badgeTextColor
        badgeLabel?.layer.cornerRadius = (badgeLabel?.bounds.size.height)! / cornerRadiusFactor
    }
    
}

/**
 Define badge anchor
 **/
public enum Anchor{
    case TopLeft(topOffset : CGFloat, leftOffset : CGFloat)
    case TopRight(topOffset : CGFloat, rightOffset : CGFloat)
    case BottomLeft(bottomOffset : CGFloat, leftOffset : CGFloat)
    case BottomRight(bottomOffset : CGFloat, rightOffset : CGFloat)
    case center
}
