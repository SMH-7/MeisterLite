//
//  MSProjectCell.swift
//  MeisterPro
//
//  Created by Apple Macbook on 17/02/2021.
//

import UIKit
import Foundation

class MSProjectCell: UITableViewCell {

    @IBOutlet weak private var projectTitle: UILabel!
    @IBOutlet weak private var projectIcon: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        SetCell()

    }
    
    func SetCell(withimage image : UIImage , withtext text: String){
            projectIcon.image = image
            projectTitle.text = text
    }
    
    private func SetCell(){
        backgroundColor = .clear
        selectionStyle = .none

        projectTitle.textColor = .white
        projectTitle.font = .boldSystemFont(ofSize: 27)

    }
    
}





