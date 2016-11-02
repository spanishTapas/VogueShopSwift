//
//  VSContainerController.swift
//  VogueShopSwift
//
//  Created by wanming zhang on 10/19/16.
//  Copyright © 2016 Wanming Zhang. All rights reserved.
//

import UIKit

class VSContainerController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    @IBOutlet weak var shopButton: UIButton!
    @IBOutlet weak var eventButton: UIButton!
    @IBOutlet weak var shopperButton: UIButton!
    @IBOutlet weak var tagImageView: UIImageView!
    @IBOutlet weak var loyaltyImageView: UIImageView!
    @IBOutlet weak var loyaltyPointsLabel: UILabel!
    
    var pageViewController : UIPageViewController?
    var pages : Array<UIViewController> = []
    
    // MARK: - Designated Initializer
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: Update title font to custom font.
        self.navigationItem.title = "Vogue Store"
        
        // Setup page view controller
        self.pageViewController?.delegate = self
        self.pageViewController?.dataSource = self
        
        // setup pageViewController data source
        self.updatePageViewControllerDataSource()
        self .setupNavigationBar()
        self.setupButtons()
        
        // Fetch loyalty points and display in UI
        self.fetchLoyaltyPoints()
        
        let loyalty = UIImage(named: "Loyalty")
        self.loyaltyImageView.image = loyalty
        
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

    func productImageViewControllerWithImage(imageID : String, type : VSProductImageController.ImageType) -> VSProductImageController? {
        // Create a product image view controller showing product image
        // Image is hard coded for this prototype
        // TODO: Fetch image from server
        //var productImageVC : VSProductImageController?
        
        let productImageVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductImageScene") as! VSProductImageController?
        productImageVC?.imageID = imageID
        productImageVC?.imageType = type
        
        return productImageVC
    }
    
    // MARK: - Network connection
    
    func fetchLoyaltyPoints() {
        // http://54.191.35.66:8181/pfchang/api/buy username=Michael&grandTotal=0
        
        let customerName = "Michael"
        let total = "0"
        
        let urlString = "http://54.191.35.66:8181/pfchang/api/buy"
        let bodyString = "username=" + customerName + "&grandTotal=" + total
        
        let url = URL(string: urlString)
        
        // Create and configure the request
        var request = URLRequest(url: url!)
        
        // Set method
        request.httpMethod = "POST"
            
        // Set headers
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Set boday
        request.httpBody = bodyString.data(using: String.Encoding.utf8)
        
        // Create session & task
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        
        var dataTask: URLSessionDataTask?
        
        dataTask = defaultSession.dataTask(with: request, completionHandler: { (data, response, error) in
            
            guard let _ = data, let _:URLResponse = response , error == nil else {
                print(error?.localizedDescription ?? "There is no error")
                return
            }
            
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        print("response status is \(httpResponse.statusCode)")
                    }
                    
                    if let responseData = data {
                        self.updateLoyaltyPointsFrom(data: responseData)
                    }
    
                }
            }
        })
        
        dataTask?.resume()
        
    }
    
    func updateLoyaltyPointsFrom(data: Data) {
        var content : [String : Any]
        do {
            //["status": SUCCESS, "username": Michael, "rewardPoints": 11083]
            content = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : Any]
            
            if let points = content["rewardPoints"] {
                print("\(points)")
                
                self.loyaltyPointsLabel.text = "\(points)  pts"
            }
            print(content)
           
        } catch {
            print("error serializing JSON: \(error)")
        }
        
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var previousController : UIViewController?
        if let currentIndex = self.pages.index(of: viewController) {
            let previousIndex = abs((currentIndex - 1) % self.pages.count)
            previousController = self.pages[previousIndex]
        }
        
        return previousController
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var nextController : UIViewController?
        if let currentIndex = self.pages.index(of: viewController) {
            let nextIndex = abs((currentIndex + 1) % self.pages.count)
            nextController = self.pages[nextIndex]
        }
        return nextController
    }
    
    
    func updatePageViewControllerDataSource() {
    
    // Hard code an array of product images for the prototype
    // TODO: Determine the logic to display product images
        if let viewController1 = self.productImageViewControllerWithImage(imageID: "Red Sneaker", type: .kVSImageTypeProduct) {
            self.pages.append(viewController1)
        }
        
        if let viewController2 = self.productImageViewControllerWithImage(imageID: "Black_Heels", type: .kVSImageTypeProduct) {
            self.pages.append(viewController2)
        }
        
        if let viewController3 = self.productImageViewControllerWithImage(imageID: "Fashion_Show", type: .kVSImageTypeEvent) {
            self.pages.append(viewController3)
        }
        
        if let viewController4 = self.productImageViewControllerWithImage(imageID: "Personal_Shopper", type: .kVSImageTypeShopper) {
            self.pages.append(viewController4)
        }

        if let viewController1 = self.pages.first {
            self.pageViewController?.setViewControllers([viewController1], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        }
    
    }
    
    // The number of items reflected in the page indicator.
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }
    
    // The selected item reflected in the page indicator.
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        if segue.identifier == "ContainerEmbedSegue" {
            if segue.destination.isKind(of: UIPageViewController.classForCoder()) {
                let pageVC : UIPageViewController = segue.destination as! UIPageViewController
                self.pageViewController = pageVC
            }
        }
    }
    
}
