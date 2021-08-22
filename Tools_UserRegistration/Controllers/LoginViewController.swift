//
//  LoginViewController.swift
//  Tools_UserRegistration
//
//  Created by Eddie Char on 8/21/21.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    let userTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 80, y: 300, width: 200, height: 50))
        textField.backgroundColor = .yellow
        textField.layer.cornerRadius = 10
        textField.placeholder = "User Name"
        return textField
    }()
    
    let fbLoginButton: FBLoginButton = {
        let button = FBLoginButton()
        return button
    }()
    
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(userTextField)
        
        //Add FBLoginButton at the center of the view controller
        fbLoginButton.center = view.center
        view.addSubview(fbLoginButton)
        
        //Observe access token changes. this will trigger after successfully login/logout
        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: OperationQueue.main) { notification in
            print("*******FB Access Token: \(String(describing: AccessToken.current?.tokenString))")
        }
    }
    
    
    
}

