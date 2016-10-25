//
//  VSShoppingCollectionController.swift
//  VogueShopSwift
//
//  Created by wanming zhang on 10/23/16.
//  Copyright © 2016 Wanming Zhang. All rights reserved.
//

import UIKit

private let reuseIdentifier = "VSShoppingCollectionCell"

class VSShoppingCollectionController: UICollectionViewController {
    
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
    
    func setupCollectionViewDataSource() {
        sections = [
            Section(type: .FEATURED_SECTION, items: [.MAGiCIAN_HAT]),
            Section(type: .COMMON_SECTION, items: [.SNEAKERS_A, .SHOES_B, .DRESS_A, .DRESSS_B])
        ]
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        let cellNib = UINib(nibName: "VSShoppingCollectionCell", bundle: nil)
        self.collectionView?.register(cellNib, forCellWithReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
        
        self.setupCollectionViewDataSource()
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return sections[section].items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
        var nibLoaded : Bool = false
        if (!nibLoaded) {
            let nib : UINib = UINib(nibName: "VSShoppingCollectionCell", bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
            nibLoaded = true
        }
        // Configure the cell
        self.configureProductCollectionCell(cell: cell as! VSShoppingCollectionCell, atIndexPath: indexPath)
        
        // To detect and handle button clicks
       // [cell.addToCartButton addTarget:self action:@selector(addToCartButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
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
    
    
//    - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    CGFloat height = 180;
//    CGFloat width = collectionView.frame.size.width - 2 * MARGIN;
//    NSArray * sections = [self.sectionData allKeys];
//    if ([[sections objectAtIndex:indexPath.section] isEqualToString:COMMON_SECTION]) {
//    width = (width - MARGIN) / 2;
//    }
//    return CGSizeMake(width, height);
//    }
//    
//    - (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(MARGIN, MARGIN, MARGIN, MARGIN);
//    }

    
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

