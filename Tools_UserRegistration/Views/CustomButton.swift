//
//  CustomButton.swift
//  Tools_UserRegistration
//
//  Created by Eddie Char on 9/4/21.
//

import UIKit

protocol CustomButtonDelegate {
    func buttonPressed(_ button: UIButton)
}


class CustomButton: UIButton {
    var delegate: CustomButtonDelegate?
    
    init(color: UIColor, title: String, tag: Int = 0) {
        super.init(frame: .zero)
        
        self.tag = tag
        layer.cornerRadius = 30
        backgroundColor = color
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        addTarget(self, action: #selector(didPressButton(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didPressButton(_ sender: UIButton) {
        delegate?.buttonPressed(self)
    }
    
    func setConstraints(in view: UIView,
                        width: CGFloat? = nil, height: CGFloat? = nil,
                        top: CGFloat? = nil, leading: CGFloat? = nil, bottom: CGFloat? = nil, trailing: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false

        if let constant = width { widthAnchor.constraint(equalToConstant: constant).isActive = true }
        if let constant = height { heightAnchor.constraint(equalToConstant: constant).isActive = true }
        if let constant = top { topAnchor.constraint(equalTo: view.topAnchor, constant: constant).isActive = true }
        if let constant = leading { leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant).isActive = true }
        if let constant = bottom { view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: constant).isActive = true }
        if let constant = trailing { view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: constant).isActive = true }
    }
}
