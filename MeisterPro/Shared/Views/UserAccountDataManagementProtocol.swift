//
//  UserAccountDataManagementProtocol.swift
//  MeisterPro
//
//  Created by Apple Macbook on 27/03/2023.
//

import Foundation

protocol UserAccountDataManagementProtocol {
    associatedtype T
    
    func writeObjectLocally(_ object : T)
    func deleteObjectLocally(atIndex index: Int)
    func fetchObjectsLocally(forEmail email: String)
    func updateObjectLocally(atIndex index: Int, title: String)

    func fetchEmail()
    func uploadDataToFirebase(forEmail email: String, Obj comingObj: T)
    func fetchDataFromFirebase(forEmail email: String )
    func ModifyFireBaseData(forEmail email:String, forTitle comingTitle : String, newTitle: String?, newCheck: Bool?, toDel: Bool)
}

extension UserAccountDataManagementProtocol {
    func updateLocally(atIndex index: Int) {}
}
