//
//  VSProductImageController.swift
//  VogueShopSwift
//
//  Created by wanming zhang on 10/20/16.
//  Copyright © 2016 Wanming Zhang. All rights reserved.
//

import UIKit

class VSProductImageController: UIViewController {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var actionButton: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    enum ImageType : UInt {
        case kVSImageTypeNone = 0
        case kVSImageTypeProduct = 1
        case kVSImageTypeEvent = 2
        case kVSImageTypeShopper = 3
    }
    
    var imageID : String = ""
    var imageType : ImageType = .kVSImageTypeNone
    
    // MARK: - Designated Initializer
    init?(imageID : String, imageType : ImageType) {
        self.imageID = imageID
        self.imageType = imageType
        
        guard imageID.isEmpty else {
            return nil
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Remove hard coded logic later
        switch self.imageType {
        case .kVSImageTypeProduct:
            self.productImageView.image = UIImage(named:self.imageID)
            self.typeLabel.isHidden = true
            self.actionButton.isHidden = true
        case .kVSImageTypeEvent:
            self.eventImageView.image = UIImage(named:self.imageID)
            self.typeLabel.text = "Fashion Show"
            self.actionButton.text = "Get Tickets"
        case .kVSImageTypeShopper:
            self.eventImageView.image = UIImage(named:self.imageID)
            self.typeLabel.text = "Personal Shopper"
            self.actionButton.text = "Book Now"
        default:
            self.productImageView.image = nil
        }
    }

}

