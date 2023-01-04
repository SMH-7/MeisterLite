//
//  Register.swift
//  MeisterPro
//
//  Created by Apple Macbook on 22/02/2021.
//

import UIKit
import SnapKit

class Register: UIViewController {
    
    lazy fileprivate var cornerConst = view.frame.width/26
    lazy var emailInputTF =  registerTF(setplaceHolder: "Enter Email...", setCorner: cornerConst)
    lazy var passwordInputTF = registerTF(setplaceHolder: "Enter Password ***", setCorner: cornerConst)
    lazy var registerButton =  commonAuthButton(setTitle: "Register")
    
    private var networkManager = registerViewModel()

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        settingEmailTextField()
        settingPasswordTextField()
        settingButton()
        
    }
    
    
    //MARK: - setting UI
    
    private func settingEmailTextField(){
        view.addSubview(emailInputTF)
        
        emailInputTF.snp.makeConstraints { (para) in
            para.leading.equalTo(view).offset(20)
            para.trailing.equalTo(view).offset(-20)
            para.top.equalTo(view).offset(100)
            para.height.equalTo(60)
        }
        
    }
    private func settingPasswordTextField(){
        view.addSubview(passwordInputTF)

        passwordInputTF.snp.makeConstraints { (para) in
            para.leading.equalTo(view).offset(20)
            para.trailing.equalTo(view).offset(-20)
            para.top.equalTo(emailInputTF.snp.bottom).offset(10)
            para.height.equalTo(60)
        }
        
    }
    
    private func settingButton(){
        view.addSubview(registerButton)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        
        registerButton.snp.makeConstraints { (para) in
            para.leading.trailing.equalTo(view)
            para.height.equalTo(30)
            para.top.equalTo(passwordInputTF.snp.bottom).offset(10)
        }
    }
}

//MARK: - action

extension Register {
    @objc private func registerTapped(){
        if let email = emailInputTF.text ,
           let password = passwordInputTF.text,
            let navBar = self.navigationController {
            networkManager.createUser(withEmail: email, withPassword: password, onBar: navBar)
        }
    }
}
