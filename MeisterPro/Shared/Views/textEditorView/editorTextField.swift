//
//  TFeditorTextField.swift
//  MeisterPro
//
//  Created by Apple Macbook on 02/03/2021.
//

import UIKit

class TFeditorTextField: UITextField {
    
    override init(frame: CGRect){
        super.init(frame: frame)
        SettingTFAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func SettingTFAttributes(){
        layer.cornerRadius = 10

        textColor = .label
        tintColor = .label
        textAlignment = .left
        font = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        
        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .no
        placeholder = "New Text..."
        keyboardType = .default
        returnKeyType = .continue
        clearButtonMode = .whileEditing
    }
}
