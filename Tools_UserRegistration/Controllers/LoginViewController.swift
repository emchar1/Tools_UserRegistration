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
    
    let userTextField = LoginTextView()
    let passwordTextField = LoginTextView(type: .password)
    let fbLoginButton = FBLoginButton()

    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 8
        button.backgroundColor = .blue
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didPressSignIn(_:)), for: .touchDown)
        return button
    }()

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalCentering
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    // MARK: - Functions
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTextField.delegate = self
        passwordTextField.delegate = self
        userTextField.textField.becomeFirstResponder()

        view.backgroundColor = UIColor(named: "colorBackgroundView")
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView(_:))))
        view.addSubview(stackView)
        
        //stackView stuff
        NSLayoutConstraint.activate([stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                                     view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 30),
                                     stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
        
        stackView.addArrangedSubview(userTextField)
        userTextField.setConstraints(in: stackView.arrangedSubviews[0])
        stackView.addArrangedSubview(passwordTextField)
        passwordTextField.setConstraints(in: stackView.arrangedSubviews[1])
        stackView.addArrangedSubview(signInButton)
        stackView.addArrangedSubview(fbLoginButton)
        stackView.addArrangedSubview(FBLoginButton())
        stackView.addArrangedSubview(FBLoginButton())
        
//        //Observe access token changes. this will trigger after successfully login/logout
//        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: OperationQueue.main) { notification in
//            print("*******FB Access Token: \(String(describing: AccessToken.current?.tokenString))")
//        }
    }
    
    
    
    @objc private func didTapView(_ recognizer: UITapGestureRecognizer) {
        let tappedLocation = recognizer.location(in: view)
        
        if (tappedLocation.y < stackView.frame.origin.y) || (tappedLocation.y > stackView.arrangedSubviews[1].frame.origin.y + stackView.arrangedSubviews[1].frame.height) {
            view.endEditing(true)
        }
    }
    
    @objc private func didPressSignIn(_ sender: UIButton) {
        view.endEditing(true)
        didCheckSignIn()
    }
    
    private func didCheckSignIn() {
        guard userTextField.textField.text!.count > 0 else {
            print("Email cannot be blank!")
            return
        }
        
        guard passwordTextField.textField.text!.count > 0 else {
            print("Password cannot be blank!")
            return
        }

        guard isValidEmailAddress(userTextField.textField.text!) else {
            print("Invalid email!")
            return
        }
        
        
        print("Signed in successfully!")
    }
}

extension LoginViewController: LoginTextViewDelegate {
    func didPressReturn(_ view: LoginTextView) {
        if view === userTextField {
            view.textField.resignFirstResponder()
            passwordTextField.textField.becomeFirstResponder()
        } else if view === passwordTextField {
            view.textField.resignFirstResponder()
            
            if userTextField.textField.text!.count <= 0 || passwordTextField.textField.text!.count <= 0 {
                userTextField.textField.becomeFirstResponder()
            }
            else {
                print("Done!")
                didCheckSignIn()
            }
        }
    }
    
    
}
