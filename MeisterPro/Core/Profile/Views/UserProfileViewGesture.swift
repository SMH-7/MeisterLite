//
//  userProfileViewGesture.swift
//  MeisterPro
//
//  Created by Apple Macbook on 16/12/2022.
//

import UIKit

class UserProfileViewGesture: UITapGestureRecognizer {

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        setAttr()
    }
    
    private func setAttr(){
        numberOfTapsRequired = 1
        numberOfTouchesRequired = 1
    }
}
