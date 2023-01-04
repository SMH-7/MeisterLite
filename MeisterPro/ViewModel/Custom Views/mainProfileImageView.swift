//
//  mainProfileImageView.swift
//  MeisterPro
//
//  Created by Apple Macbook on 16/12/2022.
//

import UIKit

class mainProfileImageView: UIImageView {


    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        settingAttr()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func settingAttr(){
        clipsToBounds =  true
        isUserInteractionEnabled =  true
        contentMode = .scaleAspectFill
        
        layer.cornerRadius = 53
        layer.borderWidth = 2
        layer.borderColor = .init(red: 1, green: 1, blue: 1, alpha: 1)
    }
}
