//
//  basicViewModel.swift
//  MeisterPro
//
//  Created by Apple Macbook on 19/12/2022.
//

import Foundation
import Firebase
import RealmSwift

class BaseViewModel {    
    
    var realm: Realm {
        get {
            do {
                let realm = try Realm()
                return realm
            }
            catch let err {
                print("problem with database", err.localizedDescription)
                return try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MyInMemoryRealm"))
            }
        }
    }
    
}
