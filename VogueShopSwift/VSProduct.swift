//
//  VSProduct.swift
//  VogueShopSwift
//
//  Created by wanming zhang on 10/22/16.
//  Copyright © 2016 Wanming Zhang. All rights reserved.
//

import UIKit

class VSProduct: NSObject, NSCoding {
    var productDescription : String?
    var imageID : String?
    var price : NSNumber?
    /**
    init(jsonObject : NSDictionary) {
        super.init()
        // assign values to properties from parsed Json data
        // hypothetical implementation
        
        self.productDescription = jsonObject.object(forKey: "Desc") as! String?
        self.imageID = jsonObject.object(forKey: "ImageID") as! String?
        self.price = jsonObject.object(forKey: "Price") as! NSNumber?
    }
    **/

    required init?(coder aDecoder: NSCoder) {
        self.productDescription = aDecoder.decodeObject(forKey: "productDescription") as! String?
        self.imageID = aDecoder.decodeObject(forKey: "imageID") as! String?
        self.price = aDecoder.decodeObject(forKey: "price") as! NSNumber?
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.productDescription, forKey: "productDescription")
        aCoder.encode(self.imageID, forKey: "imageID")
        aCoder.encode(self.price, forKey: "price")
    }
    
    
    /**
    - (id)copyWithZone:(NSZone *)zone {
    VSProduct * copy = [[VSProduct alloc] init];
    copy.productDescription = [self.productDescription copy];
    copy.imageID = [self.imageID copy];
    copy.price = [self.price copy];
    
    return copy;
    }
    **/

}
