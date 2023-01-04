//
//  basicViewModel.swift
//  MeisterPro
//
//  Created by Apple Macbook on 19/12/2022.
//

import Foundation
import Firebase
import RealmSwift

class basicViewModel {
    var realm: Realm {
        get {
            do {
                let realm = try Realm()
                return realm
            }
            catch let err {
                print("problem with database", err.localizedDescription)
            }
            return self.realm
        }
    }
    let db = Firestore.firestore()
    
    func fetchEmailForCurrentSession() -> String {
        if let PresentSender = Auth.auth().currentUser?.email {
            return PresentSender
        }
        return " "
    }
    
    func deleteObjectlocally<T : Object>(fromArr : Results<T>?, atIndex index: Int){
        guard let fromArr else { return }
        do {
            try realm.write{
                realm.delete(fromArr[index])
            }
        }catch let err {
            fatalError("cannot delete due to \(err.localizedDescription)")
        }
    }
}
