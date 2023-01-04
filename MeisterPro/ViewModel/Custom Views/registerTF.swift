//
//  registerTF.swift
//  MeisterPro
//
//  Created by Apple Macbook on 16/12/2022.
//

import UIKit


class registerTF : UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingTextField()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(setplaceHolder comingString: String, setCorner : CGFloat){
        self.init(frame: .zero)
        placeholder = comingString
        layer.cornerRadius = setCorner
    }
    
    private func settingTextField(){
        backgroundColor = .white.withAlphaComponent(0.07)
        textColor = .cyan
    }
}
