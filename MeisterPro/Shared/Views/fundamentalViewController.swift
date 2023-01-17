//
//  basicVC.swift
//  MeisterPro
//
//  Created by Apple Macbook on 18/12/2022.
//

import UIKit

class basicVC: UIViewController {

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        settingAttr()
    }
    
    private func settingAttr(){
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.cyan]

        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "PGWelcome")?.draw(in: self.view.bounds)

        if let image = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        }else{
            UIGraphicsEndImageContext()
            fatalError("Image not available")
         }
        
    }

}

extension UINavigationController {
    open override var prefersStatusBarHidden: Bool {
        return topViewController?.prefersStatusBarHidden ?? super.prefersStatusBarHidden
    }
}
