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
    
    let emailField = LoginTextView()
    let passwordField = LoginTextView(type: .password)
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
        
        emailField.delegate = self
        passwordField.delegate = self
        emailField.textField.becomeFirstResponder()

        view.backgroundColor = UIColor(named: "colorBackgroundView")
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView(_:))))
        view.addSubview(stackView)
        
        //stackView stuff
        NSLayoutConstraint.activate([stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                                     view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 30),
                                     stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
        
        stackView.addArrangedSubview(emailField)
        emailField.setConstraints(in: stackView.arrangedSubviews[0])
        stackView.addArrangedSubview(passwordField)
        passwordField.setConstraints(in: stackView.arrangedSubviews[1])
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
        guard emailField.textField.text!.count > 0 else {
            didCheckSignInAlertAction(title: "Error", message: "Email cannot be blank!") { _ in
                self.emailField.textField.becomeFirstResponder()
            }

            return
        }
        
        guard passwordField.textField.text!.count > 0 else {
            didCheckSignInAlertAction(title: "Error", message: "Password cannot be blank!") { _ in
                self.passwordField.textField.becomeFirstResponder()
            }

            return
        }

        guard isValidEmailAddress(emailField.textField.text!) else {
            didCheckSignInAlertAction(title: "Error", message: "Email address is invalid! Double-check your email and resubmit.") { _ in
                self.emailField.textField.becomeFirstResponder()
            }
            
            return
        }
        
        
        didCheckSignInAlertAction(title: "Success", message: "Signed in successfully!")
    }
    
    private func didCheckSignInAlertAction(title: String, message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default, handler: completion)

        alert.addAction(actionOK)
        present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController: LoginTextViewDelegate {
    func didPressReturn(_ view: LoginTextView) {
        if view === emailField {
            view.textField.resignFirstResponder()
            passwordField.textField.becomeFirstResponder()
        } else if view === passwordField {
            view.textField.resignFirstResponder()
            
            if emailField.textField.text!.count <= 0 || passwordField.textField.text!.count <= 0 {
                emailField.textField.becomeFirstResponder()
            }
            else {
                print("Done!")
                didCheckSignIn()
            }
        }
    }
    
    
}
