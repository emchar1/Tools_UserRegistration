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

protocol LoginTextViewDelegate {
    func didPressReturn(_ view: LoginTextView)
}


class LoginTextView: UIView {
    
    // MARK: - Properties
    
    let type: LoginTextType
    var textField: UITextField!
    var peekButton: UIButton?
    var delegate: LoginTextViewDelegate?
    
    
    // MARK: - Initialization
    
    init(type: LoginTextType = .email) {
        self.type = type
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        self.type = .default
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 4.0

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        layer.shadowRadius = 5.0
        
        let padding: CGFloat = 8.0
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
                                     stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
                                     bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: padding),
                                     trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: padding)])
        
        textField = UITextField()
        textField.delegate = self
        textField.returnKeyType = .next
        textField.enablesReturnKeyAutomatically = true
        stackView.addArrangedSubview(textField)
        
        
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
            
            peekButton = UIButton()
            peekButton!.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            peekButton!.tintColor = .label
            peekButton!.addTarget(self, action: #selector(peekPasswordTapped(_:)), for: .touchDown)

            stackView.addArrangedSubview(peekButton!)
            stackView.arrangedSubviews[0].setContentHuggingPriority(.defaultLow, for: .horizontal)
            stackView.arrangedSubviews[1].setContentHuggingPriority(.defaultHigh, for: .horizontal)
        case .default:
            textField.placeholder = "Text Field"
        }
                
        animateTextField()
    }


    // MARK: - Methods
    
    func setConstraints(in view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([topAnchor.constraint(equalTo: view.topAnchor),
                                     leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     view.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     view.trailingAnchor.constraint(equalTo: trailingAnchor)])
    }
    
    @objc private func peekPasswordTapped(_ recognizer: UITapGestureRecognizer) {
        guard let peekButton = peekButton else { return }

        textField.isSecureTextEntry = !textField.isSecureTextEntry
        peekButton.setImage(!textField.isSecureTextEntry ? UIImage(systemName: "eye.fill") : UIImage(systemName: "eye.slash.fill"), for: .normal)

        //Only fade textField is not in edit mode
        if !textField.isEditing {
            animateTextField()
        }
    }
    
    private func animateTextField() {
        alpha = 1.0

        UIView.animate(withDuration: 0.25, delay: 3.0, options: [.curveLinear, .allowUserInteraction], animations: {
            self.alpha = 0.75
        }, completion: nil)
    }
}


// MARK: - UITextFieldDelegate
    
extension LoginTextView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        alpha = 1.0
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        animateTextField()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.didPressReturn(self)
        return false
    }
}
