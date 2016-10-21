//
//  VSContainerController.swift
//  VogueShopSwift
//
//  Created by wanming zhang on 10/19/16.
//  Copyright © 2016 Wanming Zhang. All rights reserved.
//

import UIKit

class VSContainerController: UIViewController/*, UIPageViewControllerDelegate, UIPageViewControllerDataSource*/{

    @IBOutlet weak var shopButton: UIButton!
    @IBOutlet weak var eventButton: UIButton!
    @IBOutlet weak var shopperButton: UIButton!
    @IBOutlet weak var tagImageView: UIImageView!
    @IBOutlet weak var loyaltyImageView: UIImageView!
    @IBOutlet weak var loyaltyPointsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self .setupNavigationBar()
        self.setupButtons()
    }
    func setupNavigationBar() {
        //TODO: Implement left and right bar button items.
        let leftIcon = UIImage(named: "ListIcon")
        let resizedLeftIcon = leftIcon?.resizedImageWithContentMode(contentMode: UIViewContentMode.scaleAspectFit, bounds: CGSize(width: 30, height: 30), interpolationQuality: CGInterpolationQuality.high)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: resizedLeftIcon, style: UIBarButtonItemStyle.plain, target: self, action: nil)
        
        let rightIcon = UIImage(named: "UserIcon")
        let resizedRightIcon = rightIcon?.resizedImageWithContentMode(contentMode: UIViewContentMode.scaleAspectFit, bounds: CGSize(width: 30, height: 30), interpolationQuality: CGInterpolationQuality.high)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: resizedRightIcon, style: UIBarButtonItemStyle.plain, target: self, action: nil)
    }

    
    func setupButtons() {
    // TODO: TO subclass UIButton to get the appropriate UI
    let leftInset : CGFloat = 20;
    let rightInset : CGFloat = self.view.bounds.size.width / 4;
    
    let shopIcon = UIImage(named: "Shopping_Cart")
    let resizedShopIcon = shopIcon?.resizedImageWithContentMode(contentMode: UIViewContentMode.scaleAspectFit, bounds:CGSize(width: 30, height: 30), interpolationQuality:CGInterpolationQuality.high)
    
    shopButton.setTitle(NSLocalizedString("Shop", comment: "title for Shop button"), for: UIControlState.normal)
    shopButton.setImage(resizedShopIcon, for: UIControlState.normal)
    self.shopButton.imageEdgeInsets = UIEdgeInsetsMake(0, leftInset, 0, rightInset)
    
    let calendar = UIImage(named: "Calendar")
    let resizedCalendar = calendar?.resizedImageWithContentMode(contentMode: UIViewContentMode.scaleAspectFit, bounds:CGSize(width: 30, height: 30), interpolationQuality:CGInterpolationQuality.high)
    self.eventButton.setTitle("Events", for: UIControlState.normal)
    self.eventButton.setImage(resizedCalendar, for: UIControlState.normal)
    self.eventButton.imageEdgeInsets = UIEdgeInsetsMake(0, leftInset, 0, rightInset)
    
    let shopBag = UIImage(named: "ShopBag")
    let resizedBag = shopBag?.resizedImageWithContentMode(contentMode: UIViewContentMode.scaleAspectFit, bounds:CGSize(width: 30, height: 30), interpolationQuality:CGInterpolationQuality.high)
    self.shopperButton .setTitle("Book Personal Shopper", for: UIControlState.normal)
    self.shopperButton.setImage(resizedBag, for: UIControlState.normal)
    self.shopperButton.imageEdgeInsets = UIEdgeInsetsMake(0, leftInset, 0, rightInset)
    }

}
