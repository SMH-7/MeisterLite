//
//  Login.swift
//  MeisterPro
//
//  Created by Apple Macbook on 22/02/2021.
//

import UIKit
import SnapKit

class Login: Register {

    private let defaultEmail = "1234@h.com"
    private let defaultPassword = "1234567"
    private let networkManager = loginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topOnChanges()
    }
    
    
    private func topOnChanges(){
        emailInputTF.text = defaultEmail
        passwordInputTF.text = defaultPassword
        
        registerButton.setTitle("Login", for: .normal)
        registerButton.removeTarget(self, action: nil, for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }
}

extension Login {
    @objc private func loginTapped(){
        if let email =  emailInputTF.text ,
           let password = passwordInputTF.text,
           let navbar = self.navigationController {
            networkManager.validatingLogin(withEmail: email, withPassword: password, onNavBar: navbar)
        }
    }
}
