//
//  RegisterViewController.swift
//  Tools_UserRegistration
//
//  Created by Eddie Char on 9/3/21.
//

import UIKit

class RegisterViewController: UIViewController {
    let loginButton = CustomButton(color: .systemYellow, title: "L")
    
    override func viewDidLoad() {
        view.backgroundColor = .systemPurple
        loginButton.delegate = self
        
        view.addSubview(loginButton)
        loginButton.setConstraints(in: view, width: 60, height: 60, bottom: 20, trailing: 20)
        
        let label = UILabel()
        label.text = "Register Page"
        label.textAlignment = .center
        label.font = UIFont(name: "Avenir", size: 24.0)
        label.textColor = .white
        view.addSubview(label)
        
        NSLayoutConstraint.activate([label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     label.widthAnchor.constraint(equalToConstant: 300),
                                     label.heightAnchor.constraint(equalToConstant: 100)])
    }
}


extension RegisterViewController: CustomButtonDelegate {
    func buttonPressed(_ button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
