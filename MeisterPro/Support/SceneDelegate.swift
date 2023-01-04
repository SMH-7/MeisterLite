//
//  SceneDelegate.swift
//  MeisterPro
//
//  Created by Apple Macbook on 15/02/2021.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
 
        guard let windowscene = (scene as? UIWindowScene) else { return }
        window =  UIWindow(frame: windowscene.coordinateSpace.bounds)
        window?.windowScene = windowscene
        window?.rootViewController = UINavigationController(rootViewController: SignInLaunch())
        window?.makeKeyAndVisible()
        configAppearance()

    }
    func configAppearance(){
        UINavigationBar.appearance().tintColor = .cyan
        UITextField.appearance().keyboardAppearance = UIKeyboardAppearance.dark
    }

}

