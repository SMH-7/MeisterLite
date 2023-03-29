//
//  signInButton.swift
//  MeisterPro
//
//  Created by Apple Macbook on 16/12/2022.
//

import UIKit

class AuthActionButton : UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(setTitle comingString: String, togglePattern : Bool){
        self.init(frame: .zero)
        setAttr(togglePattern, comingString)
    }
        
    private func setAttr(_ comingBool : Bool,_ comingString: String){
        setTitle(comingString, for: .normal)
        
        if !comingBool {
            backgroundColor = .white.withAlphaComponent(0.07)
            setTitleColor(.cyan, for: .normal)
        } else {
            backgroundColor = .cyan
            setTitleColor(.black, for: .normal)
        }
    }
}
