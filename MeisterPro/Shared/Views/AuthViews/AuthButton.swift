//
//  commonAuthButton.swift
//  MeisterPro
//
//  Created by Apple Macbook on 16/12/2022.
//

import UIKit

class AuthButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.font = UIFont.systemFont(ofSize: self.frame.height, weight: .black)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttr()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(setTitle comingString: String){
        self.init(frame: .zero)
        setTitle(comingString, for: .normal)
    }
    
    private func setAttr(){
        backgroundColor = .clear
        setTitleColor(.cyan, for: .normal)
    }

}
