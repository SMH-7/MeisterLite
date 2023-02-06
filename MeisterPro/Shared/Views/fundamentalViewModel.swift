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

}
protocol CommonCRUD {
    associatedtype T
    
    func writeDatalocally(_ comingObj : T)
    func loadDatalocally(forEmail email: String)
    
    func fetchEmail()
    func UploadDataFirebase(forEmail email: String, Obj comingObj: T)
    func LoadDataFirebase(forEmail email: String )
    func ModifyDataFireBase(forEmail email:String, forTitle comingTitle : String, newTitle: String?, newCheck: Bool?, toDel: Bool)
}
