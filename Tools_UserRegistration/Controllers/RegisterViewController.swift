//
//  RegisterViewController.swift
//  Tools_UserRegistration
//
//  Created by Eddie Char on 9/3/21.
//

import UIKit
//import FBSDKLoginKit
import FirebaseAuth


class RegisterViewController: UIViewController {
    
    // MARK: - Properties
    
    enum ButtonTag: Int {
        case createUser = 0, goBack = 1
    }

    let nameField = LoginTextView(type: .name)
    let emailField = LoginTextView(type: .email)
    let passwordField = LoginTextView(type: .password)
    let passwordConfirmField = LoginTextView(type: .passwordConfirm)
    let createUserButton = CustomButton(color: .systemBlue, title: "Create User", tag: ButtonTag.createUser.rawValue)
    let goBackButton = CustomButton(color: .systemGray, title: "Cancel", tag: ButtonTag.goBack.rawValue)
        
    let alertLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 15)
        label.text = "Label text here"
        label.textColor = .systemRed
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
               
        nameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        passwordConfirmField.delegate = self
        createUserButton.delegate = self
        goBackButton.delegate = self
        

        view.backgroundColor = UIColor(named: "colorRegistrationView")
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView(_:))))
        view.addSubview(stackView)
        
        //stackView stuff
        NSLayoutConstraint.activate([stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                                     view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 30),
                                     stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
        
        stackView.addArrangedSubview(nameField)
        nameField.setConstraints(in: stackView.arrangedSubviews[0])
        
        stackView.addArrangedSubview(emailField)
        emailField.setConstraints(in: stackView.arrangedSubviews[1])

        stackView.addArrangedSubview(passwordField)
        passwordField.setConstraints(in: stackView.arrangedSubviews[2])

        stackView.addArrangedSubview(passwordConfirmField)
        passwordConfirmField.setConstraints(in: stackView.arrangedSubviews[3])

        subStackView.addArrangedSubview(createUserButton)
        subStackView.addArrangedSubview(goBackButton)
        stackView.addArrangedSubview(subStackView)
        createUserButton.setConstraints(in: stackView.arrangedSubviews[4], height: 60)
        goBackButton.setConstraints(in: stackView.arrangedSubviews[4], height: 60)

        stackView.addArrangedSubview(alertLabel)
                
        registerForKeyboardNotifications()
    }
    
    @objc private func didTapView(_ recognizer: UITapGestureRecognizer) {
        let tappedLocation = recognizer.location(in: view)
        
        if (tappedLocation.y < stackView.frame.origin.y) || (tappedLocation.y > stackView.arrangedSubviews[1].frame.origin.y + stackView.arrangedSubviews[1].frame.height) {
            view.endEditing(true)
        }
    }
    
    private func attemptRegistration() {
        guard nameField.textField.text!.count > 0 else {
            loginAlert(message: "Name cannot be blank!")
            nameField.textField.becomeFirstResponder()
            return
        }
        
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
        
        guard passwordField.textField.text! == passwordConfirmField.textField.text! else {
            loginAlert(message: "Passwords do not match!")
            passwordConfirmField.textField.becomeFirstResponder()
            return
        }

        guard isValidEmailAddress(emailField.textField.text!) else {
            loginAlert(message: "Email address is invalid! Double-check your email and resubmit.")
            emailField.textField.becomeFirstResponder()
            return
        }
        

        //USER REGISTRATION
        Auth.auth().createUser(withEmail: emailField.textField.text!, password: passwordField.textField.text!) { (authResult, error) in
            self.view.endEditing(true)
            
            guard error == nil else {
                print("Error creating user: \(error!.localizedDescription)")
                self.loginAlert(message: error!.localizedDescription)
                return
            }
            
            print("User with email \(self.emailField.textField.text!) created!")
            
          
            //Set the displayName here???
            if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                changeRequest.displayName = self.nameField.textField.text
                changeRequest.commitChanges { error in
                    guard error == nil else {
                        print(error!)
                        return
                    }
                    
                    print("Name: \(changeRequest.displayName ?? "none") added to user.")
                }
            }
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

extension RegisterViewController: LoginTextViewDelegate {
    func didPressReturn(_ view: LoginTextView) {
        if view === nameField {
            emailField.textField.becomeFirstResponder()
        }
        else if view === emailField {
            passwordField.textField.becomeFirstResponder()
        }
        else if view === passwordField {
            passwordConfirmField.textField.becomeFirstResponder()
        }
        else if view === passwordConfirmField {
            if nameField.textField.text!.count <= 0 {
                nameField.textField.becomeFirstResponder()
            }
            else if emailField.textField.text!.count <= 0 {
                emailField.textField.becomeFirstResponder()
            }
            else if passwordField.textField.text!.count <= 0 {
                passwordField.textField.becomeFirstResponder()
            }
            else {
                attemptRegistration()
            }
        }
    }
    
    func didPressPeekPassword(_ view: LoginTextView) {
        passwordConfirmField.textField.isSecureTextEntry = passwordField.textField.isSecureTextEntry
    }
}


// MARK: - Custom Button Delegate

extension RegisterViewController: CustomButtonDelegate {
    func buttonPressed(_ button: UIButton) {
        switch button.tag {
        case ButtonTag.createUser.rawValue:
            attemptRegistration()
        case ButtonTag.goBack.rawValue:
            dismiss(animated: true, completion: nil)
        default:
            print("Unknown button")
        }
    }
}


// MARK: - Keyboard/View Size Handling

extension RegisterViewController {
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

            if view.frame.origin.y > -keyboardHeight / 3 {
                view.frame.origin.y = -keyboardHeight / 3
            }
        }
    }
    
    @objc private func keyboardIsDismissing(_ notification: Notification) {
        view.frame.origin.y = 0
    }
}

