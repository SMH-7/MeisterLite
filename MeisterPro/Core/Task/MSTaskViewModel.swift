//
//  taskViewModel.swift
//  MeisterPro
//
//  Created by Apple Macbook on 17/12/2022.
//

import UIKit
import Firebase
import RealmSwift


class MSTaskViewModel : BaseViewModel , UserAccountDataManagementProtocol {
    
    typealias T = Task
    
    let localService : RealmManager = RealmManager<Task>()
    let cloudService : FirebaseManager = FirebaseManager<Task>()
    
    var email = Binder<String>("")
    var error = Binder<String>("")
    
    lazy var tasks = Binder< Results<Task> >(realm.objects(Task.self))
    
    
    override init() {
        super.init()
        localService.error.bind {[weak self] comingErr in
            guard let self else { return }
            self.error.value = comingErr
        }
        localService.fetchedObjects.bind { [weak self]  localList in
            guard let self else {return}
            self.tasks.value = localList
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
    //MARK: - cloud section

    // fetching mail
    func fetchEmail() {
        cloudService.fetchEmailForCurrentSession()
    }
    
    // upload
    func uploadDataToFirebase(forEmail email: String,
                            Obj comingObj: Task){
        cloudService.uploadFirebaseData(forEmail: email, object: comingObj, category: .taskList)
    }
    
    
    // load
    func fetchDataFromFirebase(forEmail email: String ){
        cloudService.fetchFirebaseData(forEmail: email, category: .taskList) {[weak self] in
            guard let self else { return }
            self.localService.dataExistsInRealm(forEmail: email, queryFilter: "TaskSender")
        }
    }
    
    // modifier
    func ModifyFireBaseData(forEmail email:String,
                            forTitle comingTitle : String,
                            newTitle: String? = nil,
                            newCheck: Bool? = nil,
                            toDel: Bool = false) {
        cloudService.modifyFirebaseData(forEmail: email, currentTitle: comingTitle, newTitle: newTitle, newCheckValue: newCheck, delete: toDel, category: .taskList)
    }
    
    
    //MARK: - local functions
    
    // write
    func writeObjectLocally(_ comingtask : Task) {
        localService.writeObjectToRealm(comingtask)
        self.fetchObjectsLocally(forEmail: comingtask.TaskSender)
    }
    
    // load
    func fetchObjectsLocally(forEmail email: String) {
        localService.dataExistsInRealm(forEmail: email, queryFilter: "TaskSender")
    }
    
    // update
    func updateObjectLocally(atIndex index: Int, title: String) {
        localService.updateCategoryTitleInRealm(title: title, at: index, category: .taskList)
    }
    
    // delete
    func deleteObjectLocally(atIndex index: Int){
        localService.deleteObjectFromRealm(atIndex: index)
    }
    
}



