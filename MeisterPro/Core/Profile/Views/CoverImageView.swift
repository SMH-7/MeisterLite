//
//  coverImageView.swift
//  MeisterPro
//
//  Created by Apple Macbook on 16/12/2022.
//

import UIKit

class CoverImageView: UIImageView {

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setAttr()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttr(){
        contentMode = .scaleAspectFill
        clipsToBounds = true
        isUserInteractionEnabled = false
    }
}
