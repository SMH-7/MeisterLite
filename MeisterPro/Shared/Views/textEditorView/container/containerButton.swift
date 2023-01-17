//
//  containerTFButton.swift
//  MeisterPro
//
//  Created by Apple Macbook on 16/12/2022.
//

import UIKit

class containerTFButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingButton()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func settingButton(){
        backgroundColor = .cyan
        layer.cornerRadius = 10
        setTitle("👌", for: .normal)
    }
}
