//
//  LoginViewController.swift
//  Tools_UserRegistration
//
//  Created by Eddie Char on 8/21/21.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    let fbLoginButton: FBLoginButton = {
        let button = FBLoginButton()
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add FBLoginButton at the center of the view controller
        fbLoginButton.center = view.center
        view.addSubview(fbLoginButton)
        
        //Observe access token changes. this will trigger after successfully login/logout
        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: OperationQueue.main) { notification in
            print("*******FB Access Token: \(String(describing: AccessToken.current?.tokenString))")
        }
    }
    
    
    
}

