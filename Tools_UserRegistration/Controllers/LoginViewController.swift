//
//  LoginViewController.swift
//  Tools_UserRegistration
//
//  Created by Eddie Char on 8/21/21.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    let emailField = LoginTextView()
    let passwordField = LoginTextView(type: .password)
    let fbLoginButton = FBLoginButton()
    
    let alertLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 15)
        label.text = "Label text here"
        label.textColor = .systemYellow
        label.textAlignment = .center
        label.shadowColor = .black
        label.shadowOffset = CGSize(width: 1, height: 1)
        label.numberOfLines = 0
        label.alpha = 0
        return label
    }()

    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 15
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
        stackView.addArrangedSubview(alertLabel)
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
            didCheckSignInAlert(message: "Email cannot be blank!")
            emailField.textField.becomeFirstResponder()
            return
        }
        
        guard passwordField.textField.text!.count > 0 else {
            didCheckSignInAlert(message: "Password cannot be blank!")
            passwordField.textField.becomeFirstResponder()
            return
        }

        guard isValidEmailAddress(emailField.textField.text!) else {
            didCheckSignInAlert(message: "Email address is invalid! Double-check your email and resubmit.")
            emailField.textField.becomeFirstResponder()
            return
        }
        

        Auth.auth().signIn(withEmail: emailField.textField.text!, password: passwordField.textField.text!) { (authResult, error) in
            guard error == nil else {
                self.performSegue(withIdentifier: "segueFail", sender: nil)
                print(error!.localizedDescription)
                return
            }
            
            
            self.performSegue(withIdentifier: "segueSuccess", sender: nil)
            print("Login successful!")
        }
    }
        
    private func didCheckSignInAlert(message: String) {
        alertLabel.text = message
        alertLabel.alpha = 1.0
        
        UIView.animate(withDuration: 0.25, delay: TimeInterval(message.count / 10), options: .curveLinear, animations: {
            self.alertLabel.alpha = 0.0
        }, completion: nil)
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
                didCheckSignIn()
            }
        }
    }
    
    
}
