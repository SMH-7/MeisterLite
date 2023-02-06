//
//  firebaseService.swift
//  MeisterPro
//
//  Created by Apple Macbook on 02/02/2023.
//

import Foundation
import RealmSwift
import Firebase

class firebaseService<T: Object> {
    
    let db = Firestore.firestore()
    var realm: Realm {
        get {
            do {
                let realm = try Realm()
                return realm
            }
            catch let err {
                self.error.value = err.localizedDescription
            }
            return self.realm
        }
    }
    
    var error : Binder<String> = Binder("")
    var email : Binder<String> = Binder("")
    
    
    // fetch email
    
    func fetchEmailForCurrentSession() {
        if let PresentSender = Auth.auth().currentUser?.email {
            self.email.value = PresentSender
        }
    }
    
    
    // delete
    func deleteFromFireBase(withid id: String, type : ObjectType) {
        var const = ""
        switch type {
        case .checklist:
            const = FireBaseConstant.CheckListCollectionName
        case.tasklist:
            const = FireBaseConstant.TaskCollectionName
        case .projectlist:
            const = FireBaseConstant.ProjectCollectioName
        }
        db.collection(const).document(id).delete { [weak self](error) in
            guard let self else { return }
            if let err = error {
                self.error.value = err.localizedDescription
            }else {
                print("Document Successfully removed")
            }
        }
    }
    
    // modifier
    func modifyData(forEmail email:String,
                       forTitle currTitle : String,
                       newTitle: String? = nil,
                       newCheck: Bool? = nil,
                       toDel: Bool = false,
                       type: ObjectType) {
        
        var table = ""
        var Key_senderMail = ""
        var key_name = ""
        
        switch type {
        case .checklist:
            table = FireBaseConstant.CheckListCollectionName
            Key_senderMail = FireBaseConstant.CheckListVC.SenderName
            key_name  = FireBaseConstant.CheckListVC.CheckListName
        case .tasklist:
            table = FireBaseConstant.TaskCollectionName
            Key_senderMail = FireBaseConstant.TaskVC.SenderName
            key_name  = FireBaseConstant.TaskVC.TaskName
        case .projectlist:
            table = FireBaseConstant.ProjectCollectioName
            Key_senderMail = FireBaseConstant.ProjectVC.SenderName
            key_name  = FireBaseConstant.ProjectVC.ProjectName
        }
        
        db.collection(table)
            .whereField(Key_senderMail, isEqualTo: email)
            .whereField(key_name, isEqualTo: currTitle).getDocuments() { [weak self] (querySnapshot, err) in
                guard let self else { return }
            if let err = err {
                self.error.value = err.localizedDescription
            } else {
                if let returnString = querySnapshot?.documents.first?.documentID {
                    if returnString.count > 0 {
                        if let title = newTitle {self.updateToCloud(withID: returnString, value_name: title, type: type)}
                        if let check = newCheck {self.updateToCloud(withID: returnString, value_check: !check)}
                        if toDel {self.deleteFromFireBase(withid: returnString, type: type)}
                    }
                }
            }
        }
    }
    
    // update
    func updateToCloud(withID id: String, value_name: String, type: ObjectType){
        var table = ""
        var key_name = ""
        
        switch type {
        case .checklist:
            table = FireBaseConstant.CheckListCollectionName
            key_name = FireBaseConstant.CheckListVC.CheckListName
        case .projectlist:
            table = FireBaseConstant.ProjectCollectioName
            key_name = FireBaseConstant.ProjectVC.ProjectName
        case .tasklist:
            table = FireBaseConstant.TaskCollectionName
            key_name = FireBaseConstant.TaskVC.TaskName
        }
        
        db.collection(table).document(id).updateData([
            key_name : value_name
        ])
    }
    
    // update only valid for checklist
    func updateToCloud(withID id: String, value_check: Bool){
        let table = FireBaseConstant.CheckListCollectionName
        let key_check = FireBaseConstant.CheckListVC.Condition
        
        db.collection(table).document(id).updateData([
            key_check : value_check
        ])
    }
    
    // load from cloud
    
    
    func loadData(byEmail email: String , type: ObjectType, completionHandler:@escaping () -> ()){
        var table = ""
        var Key_senderMail = ""
        var key_dataField  = ""
        
        switch type {
        case .checklist:
            table = FireBaseConstant.CheckListCollectionName
            Key_senderMail = FireBaseConstant.CheckListVC.SenderName
            key_dataField = FireBaseConstant.CheckListVC.DateField
        case .tasklist:
            table = FireBaseConstant.TaskCollectionName
            Key_senderMail = FireBaseConstant.TaskVC.SenderName
            key_dataField = FireBaseConstant.TaskVC.DateField
        case .projectlist:
            table = FireBaseConstant.ProjectCollectioName
            Key_senderMail = FireBaseConstant.ProjectVC.SenderName
            key_dataField = FireBaseConstant.ProjectVC.DateField
        }
        
        
        db.collection(table)
            .whereField(Key_senderMail, isEqualTo: email)
            .order(by: key_dataField).getDocuments() { [weak self] (query, error) in
                guard let self else { return }
                if let e = error {
                    self.error.value = e.localizedDescription
                }else {
                    if let ReturnData = query?.documents {
                        for EachData in ReturnData {
                            let currData = EachData.data()
                            let newObj = T()
                            
                            switch type {
                            case .checklist:
                                if let currCheckListName =  currData[FireBaseConstant.CheckListVC.CheckListName] as? String ,
                                   let currEmail = currData[FireBaseConstant.CheckListVC.SenderName] as? String,
                                   let CurrentCondition = currData[FireBaseConstant.CheckListVC.Condition] as? Bool,
                                   let currDate = currData[FireBaseConstant.CheckListVC.DateField] as? Int {
                                    
                                    (newObj as! MyCheckList).CheckListTitle = currCheckListName
                                    (newObj as! MyCheckList).CheckListSender = currEmail
                                    (newObj as! MyCheckList).Check = CurrentCondition
                                    (newObj as! MyCheckList).CheckListDate = currDate
                                    print(currDate)
                                }
                            case .tasklist:
                                if let currTaskName =  currData[FireBaseConstant.TaskVC.TaskName] as? String ,
                                   let currEmail = currData[FireBaseConstant.TaskVC.SenderName] as? String {
                                    (newObj as! MyTask).TaskTitle = currTaskName
                                    (newObj as! MyTask).TaskSender = currEmail
                                }
                            case .projectlist:
                                if let currProjectName =  currData[FireBaseConstant.ProjectVC.ProjectName] as? String ,
                                   let currEmail = currData[FireBaseConstant.ProjectVC.SenderName] as? String{
                                    (newObj as! MyProject).ProjectTitle = currProjectName
                                    (newObj as! MyProject).ProjectSender = currEmail
                                }
                            }
                            self.writeData(newObj)
                        }
                    }
                }
                completionHandler()
            }
    }
    // upload to the cloud
    
    func upload(forEmail email: String,
                obj comingObj: T,
                objType: ObjectType) {
        var table = ""
        var data : [String:Any] = [:]
        
        switch objType {
        case .checklist:
            table = FireBaseConstant.CheckListCollectionName
            data = [
                FireBaseConstant.CheckListVC.SenderName : email,
                FireBaseConstant.CheckListVC.CheckListName : (comingObj as! MyCheckList).CheckListTitle,
                FireBaseConstant.CheckListVC.Condition : (comingObj as! MyCheckList).Check,
                FireBaseConstant.CheckListVC.DateField : Date().timeIntervalSince1970
            ]
        case .tasklist:
            table = FireBaseConstant.TaskCollectionName
            data = [
                FireBaseConstant.TaskVC.SenderName : email,
                FireBaseConstant.TaskVC.TaskName :  (comingObj as! MyTask).TaskTitle,
                FireBaseConstant.TaskVC.DateField : Date().timeIntervalSince1970
            ]
        case .projectlist:
            table = FireBaseConstant.ProjectCollectioName
            data = [
                FireBaseConstant.ProjectVC.SenderName :  email,
                FireBaseConstant.ProjectVC.ProjectName :  (comingObj as! MyProject).ProjectTitle,
                FireBaseConstant.ProjectVC.DateField : Date().timeIntervalSince1970
            ]
        }
        
        db.collection(table).addDocument(data: data) { (error) in
            if let err = error  {
                self.error.value = err.localizedDescription
            }else {
                print("Successfully saved your data to cloud ")
            }
        }
    }
    
    // have to de couple this later
    
    func writeData(_ comingObj : T){
        do {
            try realm.write{
                realm.add(comingObj)
            }
        }catch {
            self.error.value = error.localizedDescription
        }
    }
    
    
}
