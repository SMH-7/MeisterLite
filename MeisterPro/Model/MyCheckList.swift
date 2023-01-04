//
//  MyCheckList.swift
//  MeisterPro
//
//  Created by Apple Macbook on 17/02/2021.
//

import Foundation
import RealmSwift

class MyCheckList : Object , Codable {
    @objc dynamic var  CheckListTitle : String = ""
    @objc dynamic var CheckListSender : String = ""
    @objc dynamic var Check : Bool = false
}
