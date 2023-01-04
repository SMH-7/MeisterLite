//
//  AppImageData.swift
//  MeisterPro
//
//  Created by Apple Macbook on 04/03/2021.
//

import Foundation
import RealmSwift

class AppimageData : Object {
    @objc dynamic var background : NSData = NSData()
    @objc dynamic var profile : NSData =  NSData()
    @objc dynamic var Sender = ""    
}
