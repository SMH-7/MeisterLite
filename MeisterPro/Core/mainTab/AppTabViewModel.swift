//
//  tabViewModel.swift
//  MeisterPro
//
//  Created by Apple Macbook on 18/12/2022.
//

import UIKit
import Firebase

class AppTabViewModel {
    
    func convertEmailToName(_ email : String) -> String {
        return email.count > 1 ? email.components(separatedBy: "@")[0] : "Unknown"
    }
    
    func userSignOff(navigationController : UINavigationController?){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.dismiss(animated: false, completion: {
            navigationController?.popViewController(animated: true)
//                   nav?.pushViewController(UserSignInVC(), animated: true)
            })
        }catch let err as NSError {
            print("unable to signout because of \(err.localizedDescription)")
        }
    }
    
    func presentProfileVC() -> UINavigationController {
        let firebaseAuth = Auth.auth()
        if let email = firebaseAuth.currentUser?.email {
            let returnname : String = convertEmailToName(email)
            let DestoVC = ProfileVC()
            DestoVC.setUsernameEmail(username: returnname, email: email)
            return UINavigationController(rootViewController: DestoVC)
        }
        return UINavigationController()
    }
    
    func customizeNavBar(viewController: UIViewController,
                         title:String,
                         tabImage: SFSymbols,
                         tag : Int) -> UINavigationController {
        viewController.title = title
        viewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: tabImage.rawValue), tag: tag)
        return UINavigationController(rootViewController: viewController)
    }
}

