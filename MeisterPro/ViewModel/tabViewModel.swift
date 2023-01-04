//
//  tabViewModel.swift
//  MeisterPro
//
//  Created by Apple Macbook on 18/12/2022.
//

import UIKit
import Firebase

class tabViewModel {
    func convertToName(withEmail email : String) -> String {
        return email.count > 1 ? email.components(separatedBy: "@")[0] : "Unknown"
    }
    
    func signOff(nav : UINavigationController?){
        let firebaseAuth = Auth.auth()
           do {
               try firebaseAuth.signOut()
               nav?.dismiss(animated: false, completion: {
                   nav?.popViewController(animated: true)
//                   nav?.pushViewController(SignInLaunch(), animated: true)
               })
           }catch let err as NSError {
               print("unable to signout because of \(err.localizedDescription)")
           }
    }

    func presentProfileNav() -> UINavigationController {
        let firebaseAuth = Auth.auth()
        if let email = firebaseAuth.currentUser?.email {
            let returnname : String = convertToName(withEmail: email)
            let DestoVC = ProfileVC()
            DestoVC.SetEmailAndTitle(Title: returnname, Email: email)
            return UINavigationController(rootViewController: DestoVC)
        }
        return UINavigationController()
    }

    func customizeNavBar(withView viewController: UIViewController,
                         title:String,
                         image: SFSymbols,
                         tag : Int) -> UINavigationController {
        viewController.title = title
        viewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: image.rawValue), tag: tag)
        return UINavigationController(rootViewController: viewController)
    }
}
