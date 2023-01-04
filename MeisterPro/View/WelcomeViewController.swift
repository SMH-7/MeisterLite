//
//  WelcomeViewController.swift
//  MeisterPro
//
//  Created by Apple Macbook on 15/02/2021.
//

import UIKit
import SnapKit

class WelcomeViewController: basicVC {

    lazy private var quotesLabel = quoteLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SettingQuoteLabel()
    }


    private func SettingQuoteLabel() {
        view.addSubview(quotesLabel)
        
        quotesLabel.snp.makeConstraints { (para) in
            para.leading.equalTo(view.snp.leading).offset(20)
            para.trailing.equalTo(view.snp.trailing).offset(-20)
            para.height.equalTo(view.frame.size.height/4)
            para.top.equalTo(view.snp.top).offset(120)
        }
        
    }
}

