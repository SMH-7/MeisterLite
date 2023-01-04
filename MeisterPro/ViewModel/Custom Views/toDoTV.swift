//
//  toDoTV.swift
//  MeisterPro
//
//  Created by Apple Macbook on 17/12/2022.
//

import UIKit

class toDoTV: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        settingBasicAttr()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func settingBasicAttr(){
        backgroundColor = .clear
        separatorStyle = .none
        rowHeight = 44
    }
}
