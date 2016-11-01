//
//  VSLoginViewController.swift
//  VogueShopSwift
//
//  Created by wanming zhang on 10/18/16.
//  Copyright © 2016 Wanming Zhang. All rights reserved.
//

import UIKit
import LocalAuthentication

let LOGIN_BUTTON_BGCOLOR = UIColor(red: 89/255.0, green: 116/255.0, blue: 179/255.0, alpha: 1.0)
let LOGIN_BUTTON_TITLE = NSLocalizedString("Login", comment: "Login button title")

class VSLoginViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var vogueStoreImage: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLoginPageAppearance()
    }

    func setupLoginPageAppearance() {
        
        self.backgroundImage.image = UIImage(named: "Bubble_Background")
        self.vogueStoreImage.image = UIImage(named: "Vogue_Store")
        
        self.loginButton.setTitle(LOGIN_BUTTON_TITLE, for: .normal)
        
        self.loginButton.layer.borderWidth = 1.0
        self.loginButton.layer.cornerRadius = 0.0
        
        self.loginButton.setTitleColor(UIColor.white, for: .normal)
        self.loginButton.backgroundColor = LOGIN_BUTTON_BGCOLOR
        self.loginButton.layer.borderColor = UIColor.white.cgColor
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: To determine whether we need custom prompt popover as iOS provides native prompt.
    

    @IBAction func promptAuthentication(_ sender: UIButton) {
        //Customized popover to prompt user for touchID authentication
        let promptVC : VSPromptAuthenticationController  = VSPromptAuthenticationController(nibName:"VSPromptAuthenticationController", bundle: nil)
        let destNav : UINavigationController = UINavigationController(rootViewController: promptVC)
    
        // Configure the popoverPresentationController
        let POPOVER_CONTENT_WIDTH = self.view.bounds.size.width * 0.67
        let POPOVER_CONTENT_HEIGHT = self.view.bounds.size.height * 0.40
        
        promptVC.preferredContentSize = CGSize(width: POPOVER_CONTENT_WIDTH, height: POPOVER_CONTENT_HEIGHT)
        destNav.modalPresentationStyle = UIModalPresentationStyle.popover
        
        var promptPopover : UIPopoverPresentationController
        promptPopover = destNav.popoverPresentationController!
        promptPopover.permittedArrowDirections = UIPopoverArrowDirection(rawValue: UInt(0)); // Remove popover arrow
        promptPopover.delegate = self;
        promptPopover.sourceView = self.view
        promptPopover.sourceRect = self.loginButton.frame
        
        destNav.navigationBar.isHidden = true

        self.present(destNav, animated: true) {
            self.performTouchIDAuthentication()
        }
//        let navigationController : UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: "VSNavigationViewController") as! UINavigationController
//        navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        self.present(navigationController, animated: true, completion: nil)
       
    }


    // MARK: - UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

    // MARK: - TouchID Authentication
    func performTouchIDAuthentication() {
    
    //LAContext * context = [[LAContext alloc] init];
    //NSError *error = nil;
    let context = LAContext()
    var error : NSError? = nil
    let reason = NSLocalizedString("Authentication is needed to access your account.", comment: "Authentication reasoning")
    if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (success, error) in
            // Device can use touch ID
            if error != nil {
                print("There was a problem verifying your identity")
                return
            }
            if success {
                print("Authentication succeeded")
                self.dismiss(animated: true, completion: nil)
                let navigationController : UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: "VSNavigationViewController") as! UINavigationController
                navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                self.present(navigationController, animated: true, completion: nil)
            }
        })
    } else { // Device cannot use touch ID
        print("Your device cannot authenticate using TouchID.")
        switch error!.code {
        case LAError.touchIDNotEnrolled.rawValue:
            notifyUserAuthenticationError(alertTitle:"Touch ID is not enrolled" , errorDesc: error?.localizedDescription)
        case LAError.passcodeNotSet.rawValue:
            notifyUserAuthenticationError(alertTitle: "A passcode hasnot been set", errorDesc: error?.localizedDescription)
        default:
            notifyUserAuthenticationError(alertTitle: "Your device cannot authenticate using TouchID", errorDesc: error?.localizedDescription)
        }
    }
}
    
func notifyUserAuthenticationError(alertTitle : String, errorDesc : String?) {
    let alert = UIAlertController(title: alertTitle, message: errorDesc, preferredStyle: UIAlertControllerStyle.alert)
    let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) in
        self.dismiss(animated: true, completion: nil)
    }
    alert.addAction(alertAction)
    self.present(alert, animated: true, completion: nil)
}
    
}
