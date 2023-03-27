//
//  checklistViewModel.swift
//  MeisterPro
//
//  Created by Apple Macbook on 17/12/2022.
//

import UIKit
import Firebase
import RealmSwift

protocol localCheckListCRUD {
    func updateLocally(atIndex index: Int)
}

class ChecklistViewModel : BaseViewModel, UserAccountDataManagementProtocol, localCheckListCRUD {
        
    typealias T = Checklist

    lazy var checklists = Binder<Results<Checklist>>(realm.objects(Checklist.self))
    
    let localService = RealmManager<Checklist>()
    let cloudService = FirebaseManager<Checklist>()

    var email = Binder<String>("")
    var error = Binder<String>("")

    
    override init() {
        super.init()
        localService.error.bind {[weak self] comingErr in
            guard let self else { return }
            self.error.value = comingErr
        }
        localService.fetchedObjects.bind { [weak self]  localList in
            guard let self else {return}
            self.checklists.value = localList
        }
        cloudService.error.bind { [weak self] comingErr in
            guard let self else { return }
            self.error.value = comingErr
        }
        cloudService.email.bind { [weak self] comingMail in
            guard let self else {return }
            self.email.value = comingMail
        }
    }
    //MARK: - cloud functions
    
    // fetching email
    func fetchEmail() {
        cloudService.fetchEmailForCurrentSession()
    }
    
    // upload
    func uploadDataToFirebase(forEmail email: String,
                        Obj comingObj: Checklist){
        cloudService.uploadFirebaseData(forEmail: email, object: comingObj, category: .checkList)
    }
    
    // load
    func fetchDataFromFirebase(forEmail email: String ){
        cloudService.fetchFirebaseData(forEmail: email, category: .checkList) {[weak self] in
            guard let self else { return }
            self.localService.dataExistsInRealm(forEmail: email, queryFilter: "CheckListSender")
        }
    }
    
    
    // updating and deleting
    func ModifyFireBaseData(forEmail email:String,
                            forTitle comingTitle : String,
                            newTitle: String? = nil,
                            newCheck: Bool? = nil,
                            toDel: Bool = false) {
        cloudService.modifyFirebaseData(forEmail: email, currentTitle: comingTitle, newTitle: newTitle, newCheckValue: newCheck, delete: toDel, category: .checkList)
    }


    //MARK: - local functions
    
    //write
    func writeObjectLocally(_ comingObj : Checklist) {
        localService.writeObjectToRealm(comingObj)
        self.fetchObjectsLocally(forEmail: comingObj.CheckListSender)
    }
    
    //load
    func fetchObjectsLocally(forEmail email: String){
        localService.dataExistsInRealm(forEmail: email, queryFilter: "CheckListSender")
    }
    
    // update
    func updateObjectLocally(atIndex index: Int, title: String){
        localService.updateCategoryTitleInRealm(title: title, at: index, category: .checkList)
    }
    
    func updateLocally(atIndex index: Int) {
        localService.updateCheckInRealmAtIndex(index, category: .checkList)
    }
    
    // delete
    func deleteObjectLocally(atIndex index: Int){
        localService.deleteObjectFromRealm(atIndex: index)
    }
}



