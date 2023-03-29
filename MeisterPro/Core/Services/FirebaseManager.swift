//
//  firebaseService.swift
//  MeisterPro
//
//  Created by Apple Macbook on 02/02/2023.
//

import Foundation
import RealmSwift
import Firebase

final class FirebaseManager<T: Object> {
    
    private let db = Firestore.firestore()
    private var realm: Realm {
        get {
            do {
                let realm = try Realm()
                return realm
            }
            catch let err {
                self.error.value = err.localizedDescription
                return try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MyInMemoryRealm"))
            }
        }
    }
    
    lazy var error : Binder<String> = Binder("")
    lazy var email : Binder<String> = Binder("")
    
    
    // fetch email
    
    func fetchEmailForCurrentSession() {
        if let userEmail = Auth.auth().currentUser?.email {
            self.email.value = userEmail
        }
    }
    
    
    // delete
    func deleteFromFireBase(withID id: String, category : Category) {
        var const = ""
        switch category {
        case .checkList:
            const = FireBaseConstant.checklistTable
        case.taskList:
            const = FireBaseConstant.taskTable
        case .projectList:
            const = FireBaseConstant.projectTable
        default:
            break
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
    func modifyFirebaseData(forEmail email:String,
                            currentTitle : String? = nil,
                            newTitle: String? = nil,
                            newCheckValue: Bool? = nil,
                            delete: Bool = false,
                            isProfileImage : Bool = false,
                            newProfileData : NSData? = nil,
                            newProfileDataObject: T? = nil,
                            category: Category) {
        
        var table = ""
        var Key_senderMail = ""
        var key_name = ""
        
        switch category {
        case .checkList:
            table = FireBaseConstant.checklistTable
            Key_senderMail = FireBaseConstant.Checklist.sender
            key_name  = FireBaseConstant.Checklist.title
        case .taskList:
            table = FireBaseConstant.taskTable
            Key_senderMail = FireBaseConstant.Task.sender
            key_name  = FireBaseConstant.Task.title
        case .projectList:
            table = FireBaseConstant.projectTable
            Key_senderMail = FireBaseConstant.Project.sender
            key_name  = FireBaseConstant.Project.title
        case .profile:
            table = FireBaseConstant.InfoCollectionName
            Key_senderMail = FireBaseConstant.User.email
        }
        
        
        if category == .profile {
            db.collection(table)
                .whereField(Key_senderMail, isEqualTo: email).getDocuments {[weak self] (querySnapshot, err) in
                    guard let self else { return }
                    if let err {
                        self.error.value = err.localizedDescription
                    } else {
                        if let firebaseID = querySnapshot?.documents.first?.documentID {
                            self.updateFirebaseData(withID: firebaseID, category: .profile,
                                               isProfileImage: isProfileImage,image: newProfileData)
                        } else {
                            self.uploadFirebaseData(forEmail: email, object: newProfileDataObject!, category: .profile)
                        }
                    }
                    
                }
        } else {
            db.collection(table)
                .whereField(Key_senderMail, isEqualTo: email)
                .whereField(key_name, isEqualTo: currentTitle).getDocuments() { [weak self] (querySnapshot, err) in
                    guard let self else { return }
                    if let err = err {
                        self.error.value = err.localizedDescription
                    } else {
                        if let returnString = querySnapshot?.documents.first?.documentID {
                            if returnString.count > 0 {
                                if let title = newTitle {self.updateFirebaseData(withID: returnString, newTitle: title, category: category)}
                                if let check = newCheckValue {self.updateCheckValueInFirebase(withID: returnString, newValue: !check)}
                                if delete {self.deleteFromFireBase(withID: returnString, category: category)}
                            }
                        }
                    }
                }
        }
    }
    
    // update
    func updateFirebaseData(withID id: String, newTitle: String? = nil, category: Category,
                            isProfileImage: Bool = false, image: NSData? = nil) {
        
        var table = ""
        var key_name = ""
        let passingObj: Any = image != nil ? image! : newTitle

        switch category {
        case .checkList:
            table = FireBaseConstant.checklistTable
            key_name = FireBaseConstant.Checklist.title
        case .projectList:
            table = FireBaseConstant.projectTable
            key_name = FireBaseConstant.Project.title
        case .taskList:
            table = FireBaseConstant.taskTable
            key_name = FireBaseConstant.Task.title
        case .profile:
            table = FireBaseConstant.InfoCollectionName
            key_name = isProfileImage ? FireBaseConstant.User.profile : FireBaseConstant.User.cover
        }
        
        db.collection(table).document(id).updateData([
            key_name : passingObj
        ])
    }
    
    // update only valid for checklist
    func updateCheckValueInFirebase(withID id: String, newValue: Bool){
        let table = FireBaseConstant.checklistTable
        let key_check = FireBaseConstant.Checklist.check
        
        db.collection(table).document(id).updateData([
            key_check : newValue
        ])
    }
    
    // load from cloud
    
    
    func fetchFirebaseData(forEmail email: String , category: Category, completionHandler:@escaping () -> ()){
        var table = ""
        var Key_senderMail = ""
        var key_dataField  = ""
        
        switch category {
        case .checkList:
            table = FireBaseConstant.checklistTable
            Key_senderMail = FireBaseConstant.Checklist.sender
            key_dataField = FireBaseConstant.Checklist.time
        case .taskList:
            table = FireBaseConstant.taskTable
            Key_senderMail = FireBaseConstant.Task.sender
            key_dataField = FireBaseConstant.Task.time
        case .projectList:
            table = FireBaseConstant.projectTable
            Key_senderMail = FireBaseConstant.Project.sender
            key_dataField = FireBaseConstant.Project.time
        case .profile:
            table = FireBaseConstant.InfoCollectionName
            Key_senderMail = FireBaseConstant.User.email
        }
        
        if category == .profile {
            db.collection(table)
                .whereField(Key_senderMail, isEqualTo: email)
                .getDocuments() { [weak self] (query, error) in
                    guard let self else { return }
                    if let e = error {
                        self.error.value = e.localizedDescription
                    }else {
                        if let ReturnData = query?.documents {
                            for EachData in ReturnData {
                                let currData = EachData.data()
                                let newObj = Profile()
                                if let email = currData[FireBaseConstant.User.email] as? String ,
                                   let profile = currData[FireBaseConstant.User.profile] as? NSData ,
                                   let background = currData[FireBaseConstant.User.cover] as? NSData {
                                    newObj.Sender = email
                                    newObj.background = background
                                    newObj.profile = profile
                                }
                                self.writeObjectToRealm(newObj as! T)
                            }
                        }
                    }
                    completionHandler()
                }
        } else {
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
                                switch category {
                                case .checkList:
                                    if let currCheckListName =  currData[FireBaseConstant.Checklist.title] as? String ,
                                       let currEmail = currData[FireBaseConstant.Checklist.sender] as? String,
                                       let CurrentCondition = currData[FireBaseConstant.Checklist.check] as? Bool {
                                        (newObj as! Checklist).CheckListTitle = currCheckListName
                                        (newObj as! Checklist).CheckListSender = currEmail
                                        (newObj as! Checklist).Check = CurrentCondition
                                    }
                                case .taskList:
                                    if let currTaskName =  currData[FireBaseConstant.Task.title] as? String ,
                                       let currEmail = currData[FireBaseConstant.Task.sender] as? String {
                                        (newObj as! Task).TaskTitle = currTaskName
                                        (newObj as! Task).TaskSender = currEmail
                                    }
                                case .projectList:
                                    if let currProjectName =  currData[FireBaseConstant.Project.title] as? String ,
                                       let currEmail = currData[FireBaseConstant.Project.sender] as? String{
                                        (newObj as! Project).ProjectTitle = currProjectName
                                        (newObj as! Project).ProjectSender = currEmail
                                    }
                                default:
                                    self.error.value = "there is something wrong when fetching profile data"
                                }
                                self.writeObjectToRealm(newObj)
                            }
                        }
                    }
                    completionHandler()
                }
        }
    }
    
    // upload to the cloud
    
    func uploadFirebaseData(forEmail email: String, object: T, category: Category) {
        var table = ""
        var data : [String:Any] = [:]
        
        switch category {
        case .checkList:
            table = FireBaseConstant.checklistTable
            data = [
                FireBaseConstant.Checklist.sender : email,
                FireBaseConstant.Checklist.title : (object as! Checklist).CheckListTitle,
                FireBaseConstant.Checklist.check : (object as! Checklist).Check,
                FireBaseConstant.Checklist.time : Date().timeIntervalSince1970
            ]
        case .taskList:
            table = FireBaseConstant.taskTable
            data = [
                FireBaseConstant.Task.sender : email,
                FireBaseConstant.Task.title :  (object as! Task).TaskTitle,
                FireBaseConstant.Task.time : Date().timeIntervalSince1970
            ]
        case .projectList:
            table = FireBaseConstant.projectTable
            data = [
                FireBaseConstant.Project.sender :  email,
                FireBaseConstant.Project.title :  (object as! Project).ProjectTitle,
                FireBaseConstant.Project.time : Date().timeIntervalSince1970
            ]
            
        case .profile:
            table = FireBaseConstant.InfoCollectionName
            data = [
                FireBaseConstant.User.email : email,
                FireBaseConstant.User.cover : (object as! Profile).background,
                FireBaseConstant.User.profile :  (object as! Profile).profile
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
    
    func writeObjectToRealm(_ object : T){
        do {
            try realm.write{
                realm.add(object)
            }
        }catch {
            self.error.value = error.localizedDescription
        }
    }
    
}
