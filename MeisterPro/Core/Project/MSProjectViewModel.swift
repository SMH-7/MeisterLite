//
//  projectViewModel.swift
//  MeisterPro
//
//  Created by Apple Macbook on 17/12/2022.
//

import UIKit
import Firebase
import RealmSwift

class MSProjectViewModel : BaseViewModel , UserAccountDataManagementProtocol {

    typealias T = Project

    private let db = Firestore.firestore()
    
    lazy var projectList : Binder = Binder< Results<Project> >(realm.objects(Project.self))

    private let realmService = RealmManager<Project>()
    private let firebaseService = FirebaseManager<Project>()

    var email = Binder<String>("")
    var error = Binder<String>("")
    
    
    override init() {
        super.init()
        
        realmService.error.bind {[weak self] comingErr in
            guard let self else { return }
            self.error.value = comingErr
        }
        realmService.fetchedObjects.bind { [weak self]  updatedObjects in
            guard let self else {return}
            self.projectList.value = updatedObjects
        }
        firebaseService.error.bind { [weak self] comingErr in
            guard let self else { return }
            self.error.value = comingErr
        }
        firebaseService.email.bind { [weak self] userEmail in
            guard let self else {return }
            self.email.value = userEmail
        }
    }
    
    //MARK: - cloud functions
    
    // fetching email
    func fetchEmail() {
        firebaseService.fetchEmailForCurrentSession()
    }
    
    // load
    func fetchDataFromFirebase(forEmail email: String ){
        firebaseService.fetchFirebaseData(forEmail: email, category: .projectList) {[weak self] in
            guard let self else { return }
            self.realmService.dataExistsInRealm(forEmail: email, queryFilter: "ProjectSender")
        }
    }
    
    // upload
    func uploadDataToFirebase(forEmail email: String,
                        Obj comingObj: Project){
        firebaseService.uploadFirebaseData(forEmail: email, object: comingObj, category: .projectList)
    }
    
    // modify
    func ModifyFireBaseData(forEmail email:String,
                            forTitle comingTitle : String,
                            newTitle: String? = nil,
                            newCheck: Bool? = nil,
                            toDel: Bool = false) {
        firebaseService.modifyFirebaseData(forEmail: email, currentTitle: comingTitle, newTitle: newTitle, newCheckValue: newCheck, delete: toDel, category: .projectList)
    }
     
    //MARK: - local functions
    
    //write
    
    func writeObjectLocally(_ comingObj : Project) {
        realmService.writeObjectToRealm(comingObj)
        self.fetchObjectsLocally(forEmail: comingObj.ProjectSender)
    }
    
    //load
    func fetchObjectsLocally(forEmail email: String){
        realmService.dataExistsInRealm(forEmail: email, queryFilter: "ProjectSender")
    }
    
    // update
    func updateObjectLocally(atIndex index: Int, title: String) {
        realmService.updateCategoryTitleInRealm(title: title, at: index, category: .projectList)
    }
        
    // delete
    func deleteObjectLocally(atIndex index: Int){
        realmService.deleteObjectFromRealm(atIndex: index)
    }
}



extension MSProjectViewModel {
    //MARK: - testing functions
    
    func updateFromFireBaseViaId(_ id: String,withData : String) async throws -> Bool {
        do {
            try await db.collection(FireBaseConstant.projectTable).document(id).updateData([
                FireBaseConstant.Project.title : withData
            ])
            return true
        }catch {
            return false
        }
    }
}


