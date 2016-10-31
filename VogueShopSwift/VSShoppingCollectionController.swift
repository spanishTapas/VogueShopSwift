//
//  VSShoppingCollectionController.swift
//  VogueShopSwift
//
//  Created by wanming zhang on 10/23/16.
//  Copyright © 2016 Wanming Zhang. All rights reserved.
//

import UIKit

private let reuseIdentifier = "VSShoppingCollectionCell"

class VSShoppingCollectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var itemsInCart : NSInteger = 0
    
    private enum SectionType : String {
        case FEATURED_SECTION = "Featured"
        case COMMON_SECTION = "Common"
    }

    private enum Item : String {
        case MAGiCIAN_HAT = "Magician Hat"
        case SNEAKERS_A = "Red Sneaker"
        case SHOES_B = "Black_Heels"
        case DRESS_A  = "Polka Dot Dress"
        case DRESSS_B = "Floral Dress"
        
    }
    
    private struct Section {
        var type : SectionType
        var items : [Item]
    }
    
    private var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        let cellNib = UINib(nibName: "VSShoppingCollectionCell", bundle: nil)
        self.collectionView?.register(cellNib, forCellWithReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
        self.setupNavigationBar()
        self.setupCollectionViewDataSource()
    }
    
    // MARK: Navigation bar & bar button item
    func setupNavigationBar() {
        
        let rightIcon = UIImage(named:"Shopping_Cart")
        
        let resizedRightIcon = rightIcon?.resizedImageWithContentMode(contentMode: UIViewContentMode.scaleAspectFit, bounds: CGSize(width: 30, height: 30), interpolationQuality: CGInterpolationQuality.high)
        
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: (resizedRightIcon?.size.width)!, height: (resizedRightIcon?.size.height)!))
        button.setBackgroundImage(resizedRightIcon, for: UIControlState())
        
        // Use barButtonItem extension
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
        /**
         Subclass barButtonItem
        //let newBarButton = VSBadgeBarButtonItem(customView: button, value: "\(itemsInCart)")

        //self.navigationItem.rightBarButtonItem = newBarButton
        **/
    }
    
    @IBAction func addToCartButtonPressed(_ sender: UIButton) {
        itemsInCart += 1
//        if let badgeButton = self.navigationItem.rightBarButtonItem as? VSBadgeBarButtonItem {
//            badgeButton.badgeValue = "\(self.itemsInCart)"
//        }
        
        self.navigationItem.rightBarButtonItem?.value = "\(self.itemsInCart)"
            
        print("\(itemsInCart)")
    }
   
    // MARK: UICollectionViewDataSource
    func setupCollectionViewDataSource() {
        sections = [
            Section(type: .FEATURED_SECTION, items: [.MAGiCIAN_HAT]),
            Section(type: .COMMON_SECTION, items: [.SNEAKERS_A, .SHOES_B, .DRESS_A, .DRESSS_B])
        ]
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return sections[section].items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : VSShoppingCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VSShoppingCollectionCell
    
        // Configure the cell
        var nibLoaded : Bool = false
        if (!nibLoaded) {
            let nib : UINib = UINib(nibName: "VSShoppingCollectionCell", bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
            nibLoaded = true
        }
        // Configure the cell
        self.configureProductCollectionCell(cell: cell , atIndexPath: indexPath)
        
        // To detect and handle button clicks
        cell.addToCartButton.addTarget(self, action: #selector(addToCartButtonPressed(_:)), for: UIControlEvents.touchUpInside)
       
        return cell
    }

    func configureProductCollectionCell(cell: VSShoppingCollectionCell, atIndexPath  indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let item = section.items[indexPath.row]
        
        if section.type == .FEATURED_SECTION {
        
            let featured = VSProduct.init(description:item.rawValue, imageID: item.rawValue, price: 39.0)!
            if let descText = featured.productDescription {
                cell.descriptionLabel.text = "Featured Item: " + descText
            }
           
            if let featuredImage = featured.imageID {
                cell.productImage.image = UIImage(named: featuredImage)
            }
    
            cell.saleTagImage.image = UIImage(named: "SaleTag")
            
            if let featuredPrice = featured.price {
                cell.priceLabel.text = "$\(featuredPrice)"
            }
        }
        else { // Common_Section
                var product : VSProduct?
                switch item {
                case .SNEAKERS_A:
                        product = VSProduct.init(description:"Sneaker A", imageID: item.rawValue, price: 49.95)!
                case .SHOES_B:
                    product = VSProduct.init(description:"Shoes B", imageID: item.rawValue, price: 79.95)!
                case .DRESS_A:
                    product = VSProduct.init(description:"dress A", imageID: item.rawValue, price: 99)!
                case .DRESSS_B:
                    product = VSProduct.init(description:"dress A", imageID: item.rawValue, price: 99)!
                default:
                    product = nil
                }
                
                if let descText = product?.productDescription {
                    cell.descriptionLabel.text = descText
                }
                if let image = product?.imageID {
                    cell.productImage.image = UIImage(named:image)
                }
                if let price = product?.price {
                    cell.priceLabel.text = "$\(price)"
                }
                
        }
            
    }

    // MARK: UICollectionViewDelegateFlowLayout
    
    // Asks the delegate for the size of the specified item’s cell.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let margin : CGFloat = 20
        let height : CGFloat = 180
        var width : CGFloat = collectionView.frame.size.width - 2 * margin
        
        let section = sections[indexPath.section]
        
        if section.type == .COMMON_SECTION {
            width = (width - margin) / 2
        }
        return CGSize(width: width, height: height)
    }
    
    // Asks the delegate for the margins to apply to content in the specified section.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let margin : CGFloat = 20
        return UIEdgeInsetsMake(margin, margin, margin, margin)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
}

