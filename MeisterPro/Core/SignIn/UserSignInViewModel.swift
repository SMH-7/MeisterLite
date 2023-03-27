//
//  signInViewModel.swift
//  MeisterPro
//
//  Created by Apple Macbook on 16/12/2022.
//

import UIKit
import Firebase


class UserSignInViewModel {
        func sessionValidator(navigationController : UINavigationController?) {
        if Auth.auth().currentUser != nil {
            navigationController?.pushViewController(AppTabViewController(), animated: true)
        }
    }
}
