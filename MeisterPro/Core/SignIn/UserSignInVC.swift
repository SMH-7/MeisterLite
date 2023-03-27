//
//  SignInLaunch.swift
//  MeisterPro
//
//  Created by Apple Macbook on 22/02/2021.
//

import UIKit
import SnapKit

class UserSignInVC: UIViewController {
    
    private var networkManager = UserSignInViewModel()

    lazy private var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .cyan
        label.text = "MeisterPro🙈"
        label.font = .systemFont(ofSize: 55, weight: .black)
        label.alpha = 0.70
        return label
    }()
    
    private var registerButton = AuthActionButton(setTitle: "Register", togglePattern: false)
    private var loginButton = AuthActionButton(setTitle: "Login", togglePattern: true)

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
        setNavBarAppearance()
        setTitle()
        setLogin()
        setRegister()
    }
    
    
    //MARK: - Setting Nav bar
    private func setNavBarAppearance(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
    private func previousSession(){
        networkManager.sessionValidator(navigationController: self.navigationController)
    }
    
    
    //MARK: - Setting UI

    private func setTitle(){
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (para) in
            para.centerX.centerY.equalTo(view)
            para.height.equalTo(60)
            
        }
    }
    
    private func setLogin(){
        view.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        loginButton.snp.makeConstraints { (para) in
            para.leading.trailing.equalTo(view)
            para.bottom.equalTo(view.safeAreaLayoutGuide)
            para.height.equalTo(60)
        }
    }
    
    
    private func setRegister(){
        view.addSubview(registerButton)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        
        registerButton.snp.makeConstraints { (para) in
            para.leading.trailing.equalTo(view)
            para.bottom.equalTo(loginButton.snp.top)
            para.height.equalTo(60)
        }
    }


}

extension UserSignInVC {
    @objc private func registerTapped(){
        navigationController?.pushViewController(UserRegisterVC(), animated: true)
        
    }
    @objc private func loginTapped(){
        navigationController?.pushViewController(UserLoginVC(), animated: true)
    }
}




