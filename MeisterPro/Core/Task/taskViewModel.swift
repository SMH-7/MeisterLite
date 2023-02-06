//
//  taskViewModel.swift
//  MeisterPro
//
//  Created by Apple Macbook on 17/12/2022.
//

import UIKit
import Firebase
import RealmSwift

protocol localTaskCRUD {
    func updateLocally(title: String, atIndex index: Int, arr: Results<MyTask>?)
    func deletelocally(fromArr : Results<MyTask>?, atIndex index: Int)
}

class taskViewModel : basicViewModel , CommonCRUD, localTaskCRUD {
    
    typealias T = MyTask
    
    let localSV : localServices<MyTask> = localServices()
    let cloudSV : firebaseService<MyTask> = firebaseService()
    
    var email : Binder<String> = Binder("")
    var error : Binder<String> = Binder("")
    
    lazy var tasks : Binder<Results<MyTask>> = Binder(realm.objects(MyTask.self))
    
    
    override init() {
        super.init()
        localSV.error.bind {[weak self] comingErr in
            guard let self else { return }
            self.error.value = comingErr
        }
        localSV.fetchObjects.bind { [weak self]  localList in
            guard let self else {return}
            self.tasks.value = localList
        }
        cloudSV.error.bind { [weak self] comingErr in
            guard let self else { return }
            self.error.value = comingErr
        }
        cloudSV.email.bind { [weak self] comingMail in
            guard let self else {return }
            self.email.value = comingMail
        }
    }
    //MARK: - cloud section

    // fetching mail
    func fetchEmail() {
        cloudSV.fetchEmailForCurrentSession()
    }
    
    // upload
    func UploadDataFirebase(forEmail email: String,
                        Obj comingObj: MyTask){
        cloudSV.upload(forEmail: email, obj: comingObj, objType: .tasklist)
    }
    
    
    // load
    func LoadDataFirebase(forEmail email: String ){
        cloudSV.loadData(byEmail: email, type: .tasklist) {[weak self] in
            guard let self else { return }
            self.localSV.checkForData(forEmail: email, withFilter: "TaskSender")
        }
    }
    
    // modifier
    
    func ModifyDataFireBase(forEmail email:String,
                       forTitle comingTitle : String,
                       newTitle: String? = nil,
                       newCheck: Bool? = nil,
                       toDel: Bool = false) {
        cloudSV.modifyData(forEmail: email, forTitle: comingTitle, newTitle: newTitle, newCheck: newCheck, toDel: toDel, type: .tasklist)
    }
    
    
    //MARK: - local functions
    
    // write
    func writeDatalocally(_ comingtask : MyTask) {
        localSV.writeData(comingtask)
        self.loadDatalocally(forEmail: comingtask.TaskSender)
    }
    
    // load
    func loadDatalocally(forEmail email: String) {
        localSV.checkForData(forEmail: email, withFilter: "TaskSender")
    }
    
    // update
    func updateLocally(title: String, atIndex index: Int,
                       arr: Results<MyTask>?) {
        localSV.updateTitle(title: title, atIndex: index, arr: arr, type: .tasklist)
    }
    
    // delete
    func deletelocally(fromArr : Results<MyTask>?, atIndex index: Int){
        localSV.deleteData(fromArr: fromArr, atIndex: index)
    }
    
}



