//
//  LoginViewController.swift
//  TouchID
//
//  Created by Simon Ng on 25/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {

    @IBOutlet weak var backgroundImageView:UIImageView!
    @IBOutlet weak var loginView:UIView!
    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    
    private var imageSet = ["cloud", "coffee", "food", "pmq", "temple"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Randomly pick an image
        let selectedImageIndex = Int(arc4random_uniform(5))
        
        // Apply blurring effect
        backgroundImageView.image = UIImage(named: imageSet[selectedImageIndex])
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        //showLoginDialog()
        loginView.isHidden = true
        authenticateWithBiometric()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper methods

    func showLoginDialog() {
        // Move the login view off screen
        loginView.isHidden = false
        loginView.transform = CGAffineTransform(translationX: 0, y: -700)
        
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            
            self.loginView.transform = CGAffineTransform.identity
            
        }, completion: nil)
        
    }

    // MARK: - get the authen
    func authenticateWithBiometric() {
        //取得本地授权类容
        let localAuthContext = LAContext()
        let reasonText = "Authentication is required to sign in AppCoda"
        var authError: NSError?
        //
        if !localAuthContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                error: &authError) {

            if let error = authError {
                print(error)
            }

            //当Touch id 和 FaceId 无法取得的情况下弹出登录框

            showLoginDialog()

            return

        }

        //执行验证
        localAuthContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reasonText,
                reply: { (success: Bool, error: Error?) -> Void in

                    //如果失败
                    if !success {

                        if let error = error {

                            switch error {
                            case LAError.authenticationFailed:
                                print("Authentication failed")
                            case LAError.passcodeNotSet:
                                print("Passcode not set")
                            case LAError.systemCancel:
                                print("Authentication was canceled by system")
                            case LAError.userCancel:
                                print("Authentication was canceled by the user")
                            case LAError.biometryNotEnrolled:
                                print("Authentication could not start because you haven't enrolled either Touch ID or Face ID on your device.")
                            case LAError.biometryNotAvailable:
                                print("Authentication could not start because Touch ID / Face ID is not available.")
                            case LAError.userFallback:
                                print("User tapped the fallback button (Enter Password).")
                            default:
                                print(error.localizedDescription)
                            }

                        }

                        // 返回至密碼驗證
                        OperationQueue.main.addOperation({
                            self.showLoginDialog()
                        })

                    } else {
                        //成功验证流程
                        print("sucess Authentication")

                        OperationQueue.main.addOperation({
                            self.performSegue(withIdentifier: "showHomeScreen", sender: nil)
                        })

                    }



                })

    }

}
