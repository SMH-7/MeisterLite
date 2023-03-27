//
//  Login.swift
//  MeisterPro
//
//  Created by Apple Macbook on 22/02/2021.
//

import UIKit
import SnapKit

class UserLoginVC: UserRegisterVC {

    private let defaultEmail = "1234@h.com"
    private let defaultPassword = "1234567"
    fileprivate let networkManager = UserLoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleViewChanges()
    }
    
    
    private func handleViewChanges(){
        emailInputTextField.text = defaultEmail
        passwordInputTextField.text = defaultPassword
        
        authButton.setTitle("Login", for: .normal)
        authButton.removeTarget(self, action: nil, for: .touchUpInside)
        authButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }
}

extension UserLoginVC {
    @objc private func loginTapped(){
        if let email =  emailInputTextField.text ,
           let password = passwordInputTextField.text,
           let navbar = self.navigationController {
            networkManager.validateLogin(forEmail: email, password: password, navigationController: navbar)
        }
    }
}
