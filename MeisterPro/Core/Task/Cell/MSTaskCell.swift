//
//  MSTaskCell.swift
//  MeisterPro
//
//  Created by Apple Macbook on 17/12/2022.
//

import UIKit

class MSTaskCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCell(){
        backgroundColor = .clear
        selectionStyle = .none
        textLabel?.textColor = .white
        textLabel?.font = .systemFont(ofSize: 27, weight: .ultraLight)
    }
}
