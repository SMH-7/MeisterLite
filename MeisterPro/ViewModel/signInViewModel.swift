//
//  signInViewModel.swift
//  MeisterPro
//
//  Created by Apple Macbook on 16/12/2022.
//

import UIKit
import Firebase


class signInViewModel {
        func sessionValidator(comingNav : UINavigationController?) {
        if Auth.auth().currentUser != nil {
            comingNav?.pushViewController(MSTabBar(), animated: true)
        }
    }
}
