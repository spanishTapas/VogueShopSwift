//
//  UIBarButtonItem + Badge.swift
//  VogueShopSwift
//
//  Created by wanming zhang on 10/28/16.
//  Copyright © 2016 Wanming Zhang. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

extension UIBarButtonItem {
    private struct associatedKeys {
        static var UIBarButtonItem_badgeKey = "UIBarButtonItem_badgeKey";
        
        static var UIBarButtonItem_badgeBGColorKey = "UIBarButtonItem_badgeBGColorKey";
        static var UIBarButtonItem_badgeTextColorKey = "UIBarButtonItem_badgeTextColorKey";
        static var UIBarButtonItem_badgeFontKey = "UIBarButtonItem_badgeFontKey";
        static var UIBarButtonItem_badgePaddingKey = "UIBarButtonItem_badgePaddingKey";
        static var UIBarButtonItem_badgeMinSizeKey = "UIBarButtonItem_badgeMinSizeKey";
        static var UIBarButtonItem_badgeOriginXKey = "UIBarButtonItem_badgeOriginXKey";
        static var UIBarButtonItem_badgeOriginYKey = "UIBarButtonItem_badgeOriginYKey";
        static var UIBarButtonItem_shouldHideBadgeAtZeroKey = "UIBarButtonItem_shouldHideBadgeAtZeroKey";
        static var UIBarButtonItem_shouldAnimateBadgeKey = "UIBarButtonItem_shouldAnimateBadgeKey";
        static var UIBarButtonItem_badgeValueKey = "UIBarButtonItem_badgeValueKey";
    }
    
    // Setup badge on the upper left corner of associated barButtonItem
    func InitiateBadge()
    {
        var defaultOriginX : CGFloat  = 0
        
        if let superView = self.customView {
            defaultOriginX = superView.frame.size.width - (self.badge.frame.size.width) / 2;
            // Avoiding badge to be clipped when animating its scale
            superView.clipsToBounds = false
            //superView.addSubview(self.badge)
            self.badge.layer.cornerRadius = self.badge.frame.size.width/2
            self.badge.clipsToBounds = true
            
        }
        
//        else if ([self respondsToSelector:@selector(view)] && [(id)self view]) {
//        superview = [(id)self view];
//        defaultOriginX = superview.frame.size.width - self.badge.frame.size.width;
//        }
//        [superview addSubview:self.badge];
    
    self.badgeBGColor   = UIColor.red
    self.badgeTextColor = UIColor.white
    self.badgeFont      = UIFont.systemFont(ofSize: 12)
    self.badgePadding   = 6;
    self.badgeMinSize   = 8;
    self.badgeOriginX   = defaultOriginX;
    self.badgeOriginY   = -4;
    self.shouldHideBadgeAtZero = true
    self.shouldAnimateBadge = true
    
    
    }

    
    // MARK: getters/setters
    var badge : UILabel {
        get {
            var badgeLabel : UILabel? = objc_getAssociatedObject(self, &associatedKeys.UIBarButtonItem_badgeKey) as! UILabel?
            if badgeLabel == nil {
                let frame = CGRect(x: badgeOriginX, y: badgeOriginY, width: 20, height: 20)
               badgeLabel = UILabel(frame: frame)
                self.badge = badgeLabel!
                self.InitiateBadge()
                self.customView?.addSubview(badgeLabel!)
                badgeLabel!.textAlignment = NSTextAlignment.center
               
            }
            return badgeLabel!
        }
        set (newLabel) {
            objc_setAssociatedObject(self, &associatedKeys.UIBarButtonItem_badgeKey, newLabel, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // Badge value to be displayed
    var value : String? {
        get {
            return objc_getAssociatedObject(self, &associatedKeys.UIBarButtonItem_badgeValueKey) as! String?
            
        }
        set (newValue) {
            objc_setAssociatedObject(self, &associatedKeys.UIBarButtonItem_badgeValueKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            // When changing the badge value check if we need to remove the badge
            self.updateBadgeValueAnimated(true)
            self.refreshBadge()
        }
    }
    
    // Badge background color
    var badgeBGColor : UIColor {
        get {
            return objc_getAssociatedObject(self, &associatedKeys.UIBarButtonItem_badgeBGColorKey) as! UIColor
            
        }
        set (newValue) {
            objc_setAssociatedObject(self, &associatedKeys.UIBarButtonItem_badgeBGColorKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.refreshBadge()
        }
    }
    // Badge text color
    var badgeTextColor : UIColor {
        get {
            if let color = objc_getAssociatedObject(self, &associatedKeys.UIBarButtonItem_badgeTextColorKey) as? UIColor {
                return color
            }
            return UIColor.white
            
        }
        set (newValue) {
            objc_setAssociatedObject(self, &associatedKeys.UIBarButtonItem_badgeTextColorKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.refreshBadge()
        }
    }

    // Badge font
    var badgeFont : UIFont {
        get {
            if let font = objc_getAssociatedObject(self, &associatedKeys.UIBarButtonItem_badgeFontKey) as? UIFont {
                return font
            }
            return UIFont.systemFont(ofSize: 12)
        }
        
        set (newFont) {
            objc_setAssociatedObject(self, &associatedKeys.UIBarButtonItem_badgeFontKey, newFont, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.refreshBadge()
        }
    }
    
    
    // Padding value for the badge
    var badgePadding : CGFloat  {
        get {
            let kDefaultPadding: CGFloat = 3.0
            
            if let number : NSNumber  = objc_getAssociatedObject(self, &associatedKeys.UIBarButtonItem_badgePaddingKey) as? NSNumber {
                return CGFloat(number.floatValue)
            }
            return kDefaultPadding
        }
        
        set (newValue) {
            let number : NSNumber = NSNumber(value: Double(newValue))
            
            objc_setAssociatedObject(self, &associatedKeys.UIBarButtonItem_badgePaddingKey, number, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            self.updateBadgeFrame()
            
        }
    }
    
    // Minimum size badge to small
    var badgeMinSize : CGFloat  {
        get {
            let kDefaultMinSize: CGFloat = 8.0
            if let number : NSNumber  = objc_getAssociatedObject(self, &associatedKeys.UIBarButtonItem_badgeMinSizeKey) as?NSNumber {
                return CGFloat(number.floatValue)
            }
            return kDefaultMinSize
        }
    
        set (newValue) {
            let number : NSNumber = NSNumber(value: Double(newValue))
            
            objc_setAssociatedObject(self, &associatedKeys.UIBarButtonItem_badgeMinSizeKey, number, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            self.updateBadgeFrame()
            
        }
    }
    
    // Values for offseting the badge over the associated BarButtonItem
    var badgeOriginX: CGFloat {
        
        get {
            let kDefaultOriginX: CGFloat = 0.0
            
            if let number : NSNumber  = objc_getAssociatedObject(self, &associatedKeys.UIBarButtonItem_badgeOriginXKey) as?NSNumber {
                return CGFloat(number.floatValue)
            }
            return kDefaultOriginX
        }
        
        set (newValue) {
            let number : NSNumber = NSNumber(value: Double(newValue))
            
            objc_setAssociatedObject(self, &associatedKeys.UIBarButtonItem_badgeOriginXKey, number, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            self.updateBadgeFrame()

        }
    }
    var badgeOriginY: CGFloat {
        get {
            let kDefaultOriginY: CGFloat = -4.0
            
            if let number : NSNumber  = objc_getAssociatedObject(self, &associatedKeys.UIBarButtonItem_badgeOriginYKey) as?NSNumber {
                return CGFloat(number.floatValue)
            }
            return kDefaultOriginY
        }
        set (newValue) {
            let number : NSNumber = NSNumber(value: Double(newValue))
            
            objc_setAssociatedObject(self, &associatedKeys.UIBarButtonItem_badgeOriginYKey, number, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            self.updateBadgeFrame()
        }
    }
    
    
    // Remove the badge when value reaches zero
    var shouldHideBadgeAtZero : Bool {
        get {
            if let number : NSNumber = objc_getAssociatedObject(self, &associatedKeys.UIBarButtonItem_shouldHideBadgeAtZeroKey) as? NSNumber {
                return number.boolValue
            }
            return false
        }
        
        set (newValue) {
            let number : NSNumber = NSNumber(value: newValue)
            objc_setAssociatedObject(self, &associatedKeys.UIBarButtonItem_shouldHideBadgeAtZeroKey, number, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.refreshBadge()
        }
    }
    
    // Badge has a bounce animation when value changes
    var shouldAnimateBadge: Bool {
        get {
            let number : NSNumber = objc_getAssociatedObject(self, &associatedKeys.UIBarButtonItem_shouldAnimateBadgeKey) as! NSNumber
            return number.boolValue
        }
        
        set (newValue) {
            let number : NSNumber = NSNumber(value: newValue)
            objc_setAssociatedObject(self, &associatedKeys.UIBarButtonItem_shouldAnimateBadgeKey, number, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.refreshBadge()
        }
    }
    
    // MRAK: - Utility methods
    func refreshBadge() {
        badge.textColor = self.badgeTextColor
        badge.backgroundColor = self.badgeBGColor
        badge.font = self.badgeFont
        
        if let value = self.value {
            if self.shouldBadgeHide(value) {
                self.badge.isHidden = true
            } else {
                self.badge.isHidden = false
                self.updateBadgeValueAnimated(true)
            }
        }
    }
    
    
    func shouldBadgeHide(_ value: String) -> Bool {
        let b2: Bool = value.isEqual("")
        let b3: Bool = value.isEqual("0")
        let b4: Bool = shouldHideBadgeAtZero
        if ((b2 || b3) && b4) {
            return true
        }
        return false
    }
    
    // Handle the badge changing value
    func updateBadgeValueAnimated(_ animated: Bool) {
        
        if (animated /*&& shouldAnimateBadge*/ && (badge.text != value)) {
            let animation: CABasicAnimation = CABasicAnimation()
            animation.keyPath = "transform.scale"
            animation.fromValue = 1.5
            animation.toValue = 1
            animation.duration = 0.2
            animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 1.3, 1.0, 1.0)
            badge.layer.add(animation, forKey: "bounceAnimation")
        }
        
        badge.text = self.value;
        
        let duration: Double = animated ? 0.2 : 0.0
        UIView.animate(withDuration: duration) {
            self.updateBadgeFrame()
        }
    }

    func updateBadgeFrame() {
        let expectedLabelSize: CGSize = badgeExpectedSize()
        var minHeight = expectedLabelSize.height
        
        minHeight = (minHeight < badgeMinSize) ? badgeMinSize : expectedLabelSize.height
        var minWidth = expectedLabelSize.width
        let padding = badgePadding
        
        minWidth = (minWidth < minHeight) ? minHeight : expectedLabelSize.width
        
        self.badge.frame = CGRect(
            x: self.badgeOriginX,
            y: self.badgeOriginY,
            width: minWidth + padding,
            height: minHeight + padding
        )
        self.badge.clipsToBounds = true
        self.badge.layer.cornerRadius = (minHeight + padding) / 2
    }

    func badgeExpectedSize() -> CGSize {
        let frameLabel: UILabel = self.duplicateLabel(badge)
        frameLabel.sizeToFit()
        let expectedLabelSize: CGSize = frameLabel.frame.size;

        return expectedLabelSize
    }
    
    func duplicateLabel(_ labelToCopy: UILabel) -> UILabel {
        let dupLabel = UILabel(frame: labelToCopy.frame)
        dupLabel.text = labelToCopy.text
        dupLabel.font = labelToCopy.font

        return dupLabel
    }

//    func updateBadgeProperties() {
//        if let customView = self.customView {
//            badgeOriginX = customView.frame.size.width - badge.frame.size.width/2
//        }
//    }

}










