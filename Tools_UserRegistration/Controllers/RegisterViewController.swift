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
    }
}


extension RegisterViewController: CustomButtonDelegate {
    func buttonPressed(_ button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
