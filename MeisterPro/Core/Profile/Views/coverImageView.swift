//
//  coverImageView.swift
//  MeisterPro
//
//  Created by Apple Macbook on 16/12/2022.
//

import UIKit

class coverImageView: UIImageView {

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        settingAttr()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func settingAttr(){
        contentMode = .scaleAspectFill
        clipsToBounds = true
        isUserInteractionEnabled = false
    }
}
