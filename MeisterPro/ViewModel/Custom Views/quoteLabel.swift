//
//  quoteLabel.swift
//  MeisterPro
//
//  Created by Apple Macbook on 16/12/2022.
//

import UIKit

class quoteLabel: UILabel {
    private let randomIndex = Int.random(in: 0..<QuoteArray.Quotes.count)

    override init(frame: CGRect) {
        super.init(frame: .zero)
        settingAttr()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func settingAttr(){
        text = QuoteArray.Quotes[randomIndex]
        textColor = .black
        numberOfLines = 0
    }

}
