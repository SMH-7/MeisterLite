//
//  Register.swift
//  MeisterPro
//
//  Created by Apple Macbook on 22/02/2021.
//

import UIKit
import SnapKit

class UserRegisterVC: UIViewController {
    
    lazy private var cornerConst = view.frame.width/26
    lazy var emailInputTextField =  AuthTextField(setplaceHolder: "Enter Email...", setCorner: cornerConst)
    lazy var passwordInputTextField = AuthTextField(setplaceHolder: "Enter Password ***", setCorner: cornerConst)
    lazy var authButton =  AuthButton(setTitle: "Register")
    
    fileprivate var networkManager = UserRegistrationViewModel()

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEmailTextField()
        setPasswordTextField()
        setButtons()
    }
    
    
    //MARK: - setting UI
    
    private func setEmailTextField(){
        view.addSubview(emailInputTextField)
        
        emailInputTextField.snp.makeConstraints { (para) in
            para.leading.equalTo(view).offset(20)
            para.trailing.equalTo(view).offset(-20)
            para.top.equalTo(view).offset(100)
            para.height.equalTo(60)
        }
        
    }
    private func setPasswordTextField(){
        view.addSubview(passwordInputTextField)

        passwordInputTextField.snp.makeConstraints { (para) in
            para.leading.equalTo(view).offset(20)
            para.trailing.equalTo(view).offset(-20)
            para.top.equalTo(emailInputTextField.snp.bottom).offset(10)
            para.height.equalTo(60)
        }
        
    }
    
    private func setButtons(){
        view.backgroundColor = .black
        view.addSubview(authButton)
        authButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        
        authButton.snp.makeConstraints { (para) in
            para.leading.trailing.equalTo(view)
            para.height.equalTo(30)
            para.top.equalTo(passwordInputTextField.snp.bottom).offset(10)
        }
    }
}

//MARK: - action

extension UserRegisterVC {
    @objc private func registerTapped(){
        if let email = emailInputTextField.text ,
           let password = passwordInputTextField.text,
            let navBar = self.navigationController {
            networkManager.createUser(email: email, password: password, navigationController: navBar)
        }
    }
}
