//
//  loginViewModel.swift
//  MeisterPro
//
//  Created by Apple Macbook on 16/12/2022.
//

import UIKit
import Firebase


class UserLoginViewModel {
    func validateLogin(forEmail comingEmail: String,
                       password: String,
                       navigationController : UINavigationController){
        Auth.auth().signIn(withEmail: comingEmail, password: password) { (result, error) in
            if let err = error {
                print("cannot signUp due to \(err.localizedDescription)")
            }else {
                navigationController.popViewController(animated: false)
                navigationController.pushViewController(AppTabViewController(), animated: true)
            }
        }
    }
}
