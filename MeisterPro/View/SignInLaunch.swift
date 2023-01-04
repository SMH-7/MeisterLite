//
//  SignInLaunch.swift
//  MeisterPro
//
//  Created by Apple Macbook on 22/02/2021.
//

import UIKit
import SnapKit

class SignInLaunch: UIViewController {
    
    private var networkManager = signInViewModel()

    lazy private var titleLabel : UILabel = {
        let x = UILabel()
        x.textColor = .cyan
        x.text = "MeisterPro🙈"
        x.font = .systemFont(ofSize: 55, weight: .black)
        x.alpha = 0.70
        return x
    }()
    
    lazy private var registerButton = signInButton(setTitle: "Register", togglePattern: false)
    lazy private var loginButton = signInButton(setTitle: "Login", togglePattern: true)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        navigationController?.isNavigationBarHidden = false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        previousSession()
        settingNavBarAppearance()
        settingTitle()
        settingLogin()
        settingRegister()
    }
    
    
    //MARK: - Setting Nav bar
    private func settingNavBarAppearance(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
    private func previousSession(){
        networkManager.sessionValidator(comingNav: self.navigationController)
    }
    
    
    //MARK: - Setting UI

    private func settingTitle(){
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (para) in
            para.centerX.centerY.equalTo(view)
            para.height.equalTo(60)
            
        }
    }
    
    private func settingLogin(){
        view.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        loginButton.snp.makeConstraints { (para) in
            para.leading.trailing.equalTo(view)
            para.bottom.equalTo(view.safeAreaLayoutGuide)
            para.height.equalTo(60)
        }
    }
    
    
    private func settingRegister(){
        view.addSubview(registerButton)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        
        registerButton.snp.makeConstraints { (para) in
            para.leading.trailing.equalTo(view)
            para.bottom.equalTo(loginButton.snp.top)
            para.height.equalTo(60)
        }
    }


}

extension SignInLaunch {
    @objc private func registerTapped(){
        navigationController?.pushViewController(Register(), animated: true)
        
    }
    @objc private func loginTapped(){
        navigationController?.pushViewController(Login(), animated: true)
    }
}




