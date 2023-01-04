//
//  userProfileViewGesture.swift
//  MeisterPro
//
//  Created by Apple Macbook on 16/12/2022.
//

import UIKit

class userProfileViewGesture: UITapGestureRecognizer {

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        settingBasic()
    }
    
    private func settingBasic(){
        numberOfTapsRequired = 1
        numberOfTouchesRequired = 1
    }
}
