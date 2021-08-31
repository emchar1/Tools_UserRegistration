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
        layer.shadowOpacity = 0.0
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowRadius = 5.0
        
        let padding: CGFloat = 8.0
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = padding
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
                                     stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
                                     bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: padding),
                                     trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: padding)])
        
        let iconImageView = UIImageView()
        iconImageView.tintColor = .tertiaryLabel
        iconImageView.contentMode = .scaleAspectFit

        textField = UITextField()
        textField.delegate = self
        textField.returnKeyType = .next
        textField.enablesReturnKeyAutomatically = true

        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(textField)
        stackView.arrangedSubviews[0].setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stackView.arrangedSubviews[1].setContentHuggingPriority(.defaultLow, for: .horizontal)

        
        switch type {
        case .email:
            iconImageView.image = UIImage(systemName: "person.crop.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12))
            textField.placeholder = "Email"
            textField.textContentType = .emailAddress
            textField.autocapitalizationType = .none
        case .password:
            iconImageView.image = UIImage(systemName: "lock.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12))
            textField.placeholder = "Password"
            textField.textContentType = .password
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            textField.isSecureTextEntry = true
            
            let peekButton = UIButton()
            peekButton.tintColor = .label
            peekButton.addTarget(self, action: #selector(peekPasswordTapped(_:)), for: .touchDown)
            peekButton.setImage(UIImage(systemName: "eye.slash.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12)),
                                for: .normal)

            stackView.addArrangedSubview(peekButton)
            stackView.arrangedSubviews[2].setContentHuggingPriority(.defaultHigh, for: .horizontal)
            stackView.arrangedSubviews[1].setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            stackView.arrangedSubviews[2].setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        case .default:
            textField.placeholder = "Text Field"
        }
    }


    // MARK: - Functions
    
    func setConstraints(in view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([topAnchor.constraint(equalTo: view.topAnchor),
                                     leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     view.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     view.trailingAnchor.constraint(equalTo: trailingAnchor)])
    }
    
    @objc private func peekPasswordTapped(_ sender: UIButton) {
        textField.isSecureTextEntry = !textField.isSecureTextEntry
        
        if textField.isSecureTextEntry {
            sender.setImage(UIImage(systemName: "eye.slash.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12)), for: .normal)
        }
        else {
            sender.setImage(UIImage(systemName: "eye.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12)), for: .normal)
        }
    }
}


// MARK: - UITextFieldDelegate
    
extension LoginTextView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        layer.shadowOpacity = 0.3
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveLinear, .allowUserInteraction], animations: {
            self.layer.shadowOpacity = 0.0
        }, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.didPressReturn(self)
        return false
    }
}
