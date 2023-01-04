//
//  MSChecklistCell.swift
//  MeisterPro
//
//  Created by Apple Macbook on 17/12/2022.
//

import UIKit

class MSChecklistCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        settingCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func settingCell(){
        backgroundColor =  .clear
        selectionStyle = .none
        textLabel?.textColor = .white
        textLabel?.font = .systemFont(ofSize: 27, weight: .ultraLight)
    }

}
