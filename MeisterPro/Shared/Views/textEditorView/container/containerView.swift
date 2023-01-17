//
//  TFeditorContainer.swift
//  MeisterPro
//
//  Created by Apple Macbook on 02/03/2021.
//

import UIKit

class TFeditorContainer: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        SettingViewWithBorders()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func SettingViewWithBorders(){
        layer.cornerRadius = 16
        layer.borderWidth = 2
        layer.borderColor = UIColor.cyan.cgColor
        backgroundColor = .systemBackground
    }
}
