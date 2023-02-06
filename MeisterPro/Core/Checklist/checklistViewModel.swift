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
    func updateLocally(atIndex index: Int, arr: Results<MyCheckList>)
    func deletelocally(fromArr : Results<MyCheckList>?, atIndex index: Int)
    func updateLocally(title: String, atIndex index: Int, arr: Results<MyCheckList>?)
}

class checklistViewModel : basicViewModel, CommonCRUD, localCheckListCRUD {
        
    typealias T = MyCheckList

    let localSV : localServices<MyCheckList> = localServices()
    let cloudSV : firebaseService<MyCheckList> = firebaseService()

    var email : Binder<String> = Binder("")
    var error : Binder<String> = Binder("")
    lazy var checkList : Binder<Results<MyCheckList>> = Binder(realm.objects(MyCheckList.self))

    
    override init() {
        super.init()
        
        localSV.error.bind {[weak self] comingErr in
            guard let self else { return }
            self.error.value = comingErr
        }
        localSV.fetchObjects.bind { [weak self]  localList in
            guard let self else {return}
            self.checkList.value = localList
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
    //MARK: - cloud functions
    
    // fetching email
    func fetchEmail() {
        cloudSV.fetchEmailForCurrentSession()
    }
    
    // upload
    func UploadDataFirebase(forEmail email: String,
                        Obj comingObj: MyCheckList){
        cloudSV.upload(forEmail: email, obj: comingObj, objType: .checklist)
    }
    
    // load
    
    func LoadDataFirebase(forEmail email: String ){
        cloudSV.loadData(byEmail: email, type: .checklist) {[weak self] in
            guard let self else { return }
            self.localSV.checkForData(forEmail: email, withFilter: "CheckListSender")
        }
    }
    
    
    // updating and deleting
    
    func ModifyDataFireBase(forEmail email:String,
                       forTitle comingTitle : String,
                       newTitle: String? = nil,
                       newCheck: Bool? = nil,
                       toDel: Bool = false) {
        cloudSV.modifyData(forEmail: email, forTitle: comingTitle, newTitle: newTitle, newCheck: newCheck, toDel: toDel, type: .checklist)
    }


    //MARK: - local functions
    
    //write
    
    func writeDatalocally(_ comingObj : MyCheckList) {
        localSV.writeData(comingObj)
        self.loadDatalocally(forEmail: comingObj.CheckListSender)
    }
    
    //load
    
    func loadDatalocally(forEmail email: String){
        localSV.checkForData(forEmail: email, withFilter: "CheckListSender")
    }
    
    // update
    
    func updateLocally(title: String, atIndex index: Int,
                       arr: Results<MyCheckList>?) {
        localSV.updateTitle(title: title, atIndex: index, arr: arr, type: .checklist)
    }
    
    func updateLocally(atIndex index: Int,
                       arr: Results<MyCheckList>){
        localSV.updateCheck(atIndex: index, arr: arr, type: .checklist)
    }
    
    // delete
    
    func deletelocally(fromArr : Results<MyCheckList>?, atIndex index: Int){
        localSV.deleteData(fromArr: fromArr, atIndex: index)

    }
}



