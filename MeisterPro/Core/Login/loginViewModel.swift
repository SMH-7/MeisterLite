//
//  loginViewModel.swift
//  MeisterPro
//
//  Created by Apple Macbook on 16/12/2022.
//

import UIKit
import Firebase


class loginViewModel {
    func validatingLogin(withEmail comingEmail: String,
                         withPassword comingPassword: String,
                         onNavBar comingBar : UINavigationController){
        Auth.auth().signIn(withEmail: comingEmail, password: comingPassword) { (result, error) in
            if let err = error {
                print("cannot signUp due to \(err.localizedDescription)")
            }else {
                comingBar.popViewController(animated: false)
                comingBar.pushViewController(MSTabBar(), animated: true)
            }
        }
    }
}
