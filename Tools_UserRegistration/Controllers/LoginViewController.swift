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
    
    let userTextField = LoginTextField()
    let passwordTextField = LoginTextField(type: .password)
    
    let signInButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 50))
        button.layer.cornerRadius = 8
        button.backgroundColor = .blue
        button.setTitle("Sign In", for: .normal)
        button.setTitle("Pushed", for: .highlighted)
        return button
    }()

    let fbLoginButton: FBLoginButton = {
        let button = FBLoginButton()
        return button
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalCentering
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.backgroundColor = .yellow
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemTeal
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                                     view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 30),
                                     stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)])

        stackView.addArrangedSubview(userTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(signInButton)
        stackView.addArrangedSubview(fbLoginButton)
        
        //Observe access token changes. this will trigger after successfully login/logout
        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: OperationQueue.main) { notification in
            print("*******FB Access Token: \(String(describing: AccessToken.current?.tokenString))")
        }
    }
}

