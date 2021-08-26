//
//  LoginTextField.swift
//  Tools_UserRegistration
//
//  Created by Eddie Char on 8/22/21.
//

import UIKit

enum TextFieldType {
    case email, password, `default`
}

class LoginTextField: UITextField, UITextFieldDelegate {
    
    // MARK: - Properties
    
    let type: TextFieldType
    
    
    // MARK: - Initialization
    
    init(type: TextFieldType = .email) {
        self.type = type
        super.init(frame: .zero)
        delegate = self
        setup()
    }
        
    required init?(coder: NSCoder) {
        self.type = .default
        super.init(coder: coder)
        delegate = self
        setup()
    }
        
    private func setup() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 8.0

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        layer.shadowRadius = 5.0
        
        switch type {
        case .email:
            placeholder = "Email"
            textContentType = .emailAddress
            autocapitalizationType = .none
        case .password:
            placeholder = "Password"
            textContentType = .password
            autocapitalizationType = .none
            autocorrectionType = .no
            isSecureTextEntry = true
        case .default:
            placeholder = "Text Field"
        }
        
        animate()
    }


    // MARK: - Methods
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0))
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
