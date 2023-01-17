//
//  MSProjectCell.swift
//  MeisterPro
//
//  Created by Apple Macbook on 17/02/2021.
//

import UIKit
import Foundation

class MSProjectCell: UITableViewCell {

    @IBOutlet weak var ProjectTitle: UILabel!
    @IBOutlet weak var ProjectIcon: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        SettingCell()

    }
    
    func SetCell(withimage image : UIImage , withtext text: String){
            ProjectIcon.image = image
            ProjectTitle.text = text
    }
    
    private func SettingCell(){
        backgroundColor = .clear
        selectionStyle = .none

        ProjectTitle.textColor = .white
        ProjectTitle.font = .boldSystemFont(ofSize: 27)

    }
    
}





