//
//  MyTask.swift
//  MeisterPro
//
//  Created by Apple Macbook on 17/02/2021.
//

import Foundation
import RealmSwift

class  MyTask : Object , Codable{
   @objc dynamic var TaskTitle : String = ""
    @objc dynamic var TaskSender : String = ""
}
