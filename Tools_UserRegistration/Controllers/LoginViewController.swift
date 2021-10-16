//
//  LoginViewController.swift
//  Tools_UserRegistration
//
//  Created by Eddie Char on 8/21/21.
//

import UIKit
//import FBSDKLoginKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    enum ButtonTag: Int {
        case signIn = 0, register = 1
    }

    let emailField = LoginTextView()
    let passwordField = LoginTextView(type: .password)
//    let fbLoginButton = FBLoginButton()
    let signInButton = CustomButton(color: .systemGreen, title: "Sign In", tag: ButtonTag.signIn.rawValue)
    let registerButton = CustomButton(color: .systemPink, title: "Register", tag: ButtonTag.register.rawValue)
        
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
    
    let subStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.axis = .horizontal
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
        signInButton.delegate = self
        registerButton.delegate = self
        
//        emailField.textField.becomeFirstResponder()

        view.backgroundColor = UIColor(named: "colorLoginView")
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

        subStackView.addArrangedSubview(signInButton)
        subStackView.addArrangedSubview(registerButton)
        stackView.addArrangedSubview(subStackView)
        signInButton.setConstraints(in: stackView.arrangedSubviews[2], height: 60)
        registerButton.setConstraints(in: stackView.arrangedSubviews[2], height: 60)

        stackView.addArrangedSubview(alertLabel)
                
//        view.addSubview(registerButton)
//        registerButton.setConstraints(in: view, width: 60, height: 60, bottom: 20, trailing: 20)

        
//        stackView.addArrangedSubview(fbLoginButton)
//        stackView.addArrangedSubview(FBLoginButton())
//        stackView.addArrangedSubview(FBLoginButton())
        
//        //Observe access token changes. this will trigger after successfully login/logout
//        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: OperationQueue.main) { notification in
//            print("*******FB Access Token: \(String(describing: AccessToken.current?.tokenString))")
//        }
        
        registerForKeyboardNotifications()
    }
    
    @objc private func didTapView(_ recognizer: UITapGestureRecognizer) {
        let tappedLocation = recognizer.location(in: view)
        
        if (tappedLocation.y < stackView.frame.origin.y) || (tappedLocation.y > stackView.arrangedSubviews[1].frame.origin.y + stackView.arrangedSubviews[1].frame.height) {
            view.endEditing(true)
        }
    }
    
    private func attemptLogin() {
        guard emailField.textField.text!.count > 0 else {
            loginAlert(message: "Email cannot be blank!")
            emailField.textField.becomeFirstResponder()
            return
        }
        
        guard passwordField.textField.text!.count > 0 else {
            loginAlert(message: "Password cannot be blank!")
            passwordField.textField.becomeFirstResponder()
            return
        }

        guard isValidEmailAddress(emailField.textField.text!) else {
            loginAlert(message: "Email address is invalid! Double-check your email and resubmit.")
            emailField.textField.becomeFirstResponder()
            return
        }
        
        //...and finally login via Firebase/Auth
        Auth.auth().signIn(withEmail: emailField.textField.text!, password: passwordField.textField.text!) { (authResult, error) in
            self.view.endEditing(true)

            guard error == nil else {
                self.performSegue(withIdentifier: "segueFail", sender: nil)
                print(error!.localizedDescription)
                return
            }
            
            self.performSegue(withIdentifier: "segueSuccess", sender: nil)
            print("Login successful!")
        }
    }
        
    private func loginAlert(message: String) {
        alertLabel.text = message
        alertLabel.alpha = 1.0
        
        UIView.animate(withDuration: 0.25, delay: TimeInterval(message.count / 10), options: .curveLinear, animations: {
            self.alertLabel.alpha = 0.0
        }, completion: nil)
    }
}


// MARK: - LoginTextViewDelegate

extension LoginViewController: LoginTextViewDelegate {
    func didPressReturn(_ view: LoginTextView) {
        if view === emailField {
//            view.textField.resignFirstResponder()
            passwordField.textField.becomeFirstResponder()
        }
        else if view === passwordField {
//            view.textField.resignFirstResponder()
            
            if emailField.textField.text!.count <= 0 || passwordField.textField.text!.count <= 0 {
                emailField.textField.becomeFirstResponder()
            }
            else {
                attemptLogin()
            }
        }
    }    
}


// MARK: - Custom Button Delegate

extension LoginViewController: CustomButtonDelegate {
    func buttonPressed(_ button: UIButton) {
        switch button.tag {
        case ButtonTag.signIn.rawValue:
//            view.endEditing(true)
            attemptLogin()
        case ButtonTag.register.rawValue:
            guard let destinationVC = storyboard?.instantiateViewController(withIdentifier: "registerVC") as? RegisterViewController else {
                return
            }
            
            destinationVC.transitioningDelegate = self
            destinationVC.modalPresentationStyle = .fullScreen
            present(destinationVC, animated: true, completion: nil)
        default:
            print("Unknown button")
        }
    }
}



// MARK: - Animation Transition Delegate

extension LoginViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(animationDuration: 0.5, animationType: .present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(animationDuration: 0.5, animationType: .dismiss)
    }
}


// MARK: - Keyboard/View Size Handling

extension LoginViewController {
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardIsPresenting(_ :)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardIsDismissing(_ :)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardIsPresenting(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height

            if view.frame.origin.y > -keyboardHeight / 4 {
                view.frame.origin.y = -keyboardHeight / 4
            }
        }
    }
    
    @objc private func keyboardIsDismissing(_ notification: Notification) {
        view.frame.origin.y = 0
    }
}
