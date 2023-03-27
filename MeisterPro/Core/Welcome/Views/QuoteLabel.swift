//
//  quoteLabel.swift
//  MeisterPro
//
//  Created by Apple Macbook on 16/12/2022.
//

import UIKit

class QuoteLabel: UILabel {
    private let randomIndex = Int.random(in: 0..<Storage.Quotes.count)

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setAttr()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttr(){
        text = Storage.Quotes[randomIndex]
        textColor = .black
        numberOfLines = 0
    }

}
