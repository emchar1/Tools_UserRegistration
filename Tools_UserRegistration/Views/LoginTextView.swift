//
//  LoginTextView.swift
//  Tools_UserRegistration
//
//  Created by Eddie Char on 8/23/21.
//

import UIKit

enum LoginTextType {
    case email, password, `default`
}

class LoginTextView: UIView, UITextFieldDelegate {
    
    // MARK: - Properties
    
    let textField = UITextField()
    let type: LoginTextType
    
    
    // MARK: - Initialization
    
    init(type: LoginTextType = .email) {
        self.type = type
        super.init(frame: .zero)
        textField.delegate = self
        setup()
    }
    
    required init?(coder: NSCoder) {
        self.type = .default
        super.init(coder: coder)
        textField.delegate = self
        setup()
    }

    private func setup() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 8.0

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        layer.shadowRadius = 5.0
        
        let padding: CGFloat = 8.0
        textField.delegate = self
        textField.backgroundColor = .systemBackground
        textField.translatesAutoresizingMaskIntoConstraints = false

        addSubview(textField)
        NSLayoutConstraint.activate([textField.topAnchor.constraint(equalTo: topAnchor, constant: padding),
                                     textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
                                     bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: padding),
                                     trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: padding)])
        
        switch type {
        case .email:
            textField.placeholder = "Email"
            textField.textContentType = .emailAddress
            textField.autocapitalizationType = .none
        case .password:
            textField.placeholder = "Password"
            textField.textContentType = .password
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            textField.isSecureTextEntry = true
        case .default:
            textField.placeholder = "Text Field"
        }
                
        animate()
    }


    // MARK: - Methods
    
//    override func textRect(forBounds bounds: CGRect) -> CGRect {
//        let rect = super.textRect(forBounds: bounds)
//        return rect.inset(by: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0))
//    }
//
//    override func editingRect(forBounds bounds: CGRect) -> CGRect {
//        let rect = super.editingRect(forBounds: bounds)
//        return rect.inset(by: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0))
//    }
    func setConstraints(in view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([topAnchor.constraint(equalTo: view.topAnchor),
                                     leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     view.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     view.trailingAnchor.constraint(equalTo: trailingAnchor)])
    }
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animate()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        animate()
    }
    
    private func animate() {
        alpha = 1.0

        UIView.animate(withDuration: 0.25, delay: 3.0, options: .curveLinear, animations: {
            self.alpha = 0.75
        }, completion: nil)
    }
}
