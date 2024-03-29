//
//  socialsButton.swift
//  MeisterPro
//
//  Created by Apple Macbook on 16/12/2022.
//

import UIKit

class SocialsButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLabel(){
        backgroundColor = .white.withAlphaComponent(0.3)
        titleLabel?.textAlignment = .center
        setTitle("Socials", for: .normal)
        setTitleColor(.cyan, for: .normal)
    }
}
