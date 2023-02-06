//
//  projectViewModel.swift
//  MeisterPro
//
//  Created by Apple Macbook on 17/12/2022.
//

import UIKit
import Firebase
import RealmSwift

protocol localProjectCRUD {
    func updateLocally(title: String, atIndex index: Int, arr: Results<MyProject>?)
    func deletelocally(fromArr : Results<MyProject>?, atIndex index: Int)
}


class projectViewModel : basicViewModel , CommonCRUD, localProjectCRUD {

    typealias T = MyProject

    let db = Firestore.firestore()
    
    let localSV : localServices<MyProject> = localServices()
    let cloudSV : firebaseService<MyProject> = firebaseService()

    var email : Binder<String> = Binder("")
    var error : Binder<String> = Binder("")
    lazy var projectList : Binder<Results<MyProject>> = Binder(realm.objects(MyProject.self))
    
    
    override init() {
        super.init()
        
        localSV.error.bind {[weak self] comingErr in
            guard let self else { return }
            self.error.value = comingErr
        }
        localSV.fetchObjects.bind { [weak self]  localList in
            guard let self else {return}
            self.projectList.value = localList
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
    
    // load
    
    func LoadDataFirebase(forEmail email: String ){
        cloudSV.loadData(byEmail: email, type: .projectlist) {[weak self] in
            guard let self else { return }
            self.localSV.checkForData(forEmail: email, withFilter: "ProjectSender")
        }
    }
    
    
    // upload
    func UploadDataFirebase(forEmail email: String,
                        Obj comingObj: MyProject){
        cloudSV.upload(forEmail: email, obj: comingObj, objType: .projectlist)
    }
    
    // modify
    func ModifyDataFireBase(forEmail email:String,
                       forTitle comingTitle : String,
                       newTitle: String? = nil,
                       newCheck: Bool? = nil,
                       toDel: Bool = false) {
        cloudSV.modifyData(forEmail: email, forTitle: comingTitle, newTitle: newTitle, newCheck: newCheck, toDel: toDel, type: .projectlist)
    }
     
    //MARK: - local functions
    
    //write
    
    func writeDatalocally(_ comingObj : MyProject) {
        localSV.writeData(comingObj)
        self.loadDatalocally(forEmail: comingObj.ProjectSender)
    }
    
    //load
    
    func loadDatalocally(forEmail email: String){
        localSV.checkForData(forEmail: email, withFilter: "ProjectSender")
    }
    
    // update
    
    func updateLocally(title: String, atIndex index: Int,
                       arr: Results<MyProject>?) {
        localSV.updateTitle(title: title, atIndex: index, arr: arr, type: .projectlist)
    }
        
    // delete
    
    func deletelocally(fromArr : Results<MyProject>?, atIndex index: Int){
        localSV.deleteData(fromArr: fromArr, atIndex: index)
    }

}



extension projectViewModel {
    //MARK: - testing functions
    
    func updateFromFireBaseViaId(_ id: String,withData : String) async throws -> Bool {
        do {
            try await db.collection(FireBaseConstant.ProjectCollectioName).document(id).updateData([
                FireBaseConstant.ProjectVC.ProjectName : withData
            ])
            return true
        }catch {
            return false
        }
    }
}


