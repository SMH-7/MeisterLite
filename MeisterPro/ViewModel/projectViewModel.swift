//
//  projectViewModel.swift
//  MeisterPro
//
//  Created by Apple Macbook on 17/12/2022.
//

import UIKit
import Firebase
import RealmSwift


class projectViewModel : basicViewModel {

    
    func  loadData(byEmail comingEmail: String) -> Results<MyProject>? {
        return realm.objects(MyProject.self).filter(NSPredicate(format: "ProjectSender == %@", "\(comingEmail)"))
    }
    
    
    func loadFromCloud(forEmail email:String, completion: @escaping(Results<MyProject>) -> ()){
        db.collection(FireBaseConstant.ProjectCollectioName).whereField(FireBaseConstant.ProjectVC.SenderName, isEqualTo: email).order(by: FireBaseConstant.ProjectVC.DateField).getDocuments() { (query, error) in
            
            if let e = error {
                print("There was an error fetching your data \(e.localizedDescription)")
            }else {
                if let ReturnData = query?.documents {
                    for EachData in ReturnData {
                        let CurrentData = EachData.data()
                        if let CurrentProjectName = CurrentData[FireBaseConstant.ProjectVC.ProjectName] as? String ,
                           let  CurrentEmail =  CurrentData[FireBaseConstant.ProjectVC.SenderName] as? String {
                            
                            let CurrentObj = MyProject()
                            CurrentObj.ProjectTitle = CurrentProjectName
                            CurrentObj.ProjectSender = CurrentEmail
                            do {
                                try self.realm.write{
                                    self.realm.add(CurrentObj)
                                }
                            }catch let err {
                                fatalError("unable to save your project because of \(err.localizedDescription)")
                            }
                            
                        }
                    }
                }
                if let temp = self.loadData(byEmail: email) { completion(temp)}
            }
        }
    }
    
    func formProjectObj(withName name:String,withEmail email:String) -> MyProject {
        let temp = MyProject()
        temp.ProjectSender = email
        temp.ProjectTitle = name
        return temp
    }
    
    func updateProjectToCloud(_ object: MyProject){
        db.collection(FireBaseConstant.ProjectCollectioName).addDocument(data: [
            FireBaseConstant.ProjectVC.SenderName :  object.ProjectSender ,
            FireBaseConstant.ProjectVC.ProjectName : object.ProjectTitle,
            FireBaseConstant.ProjectVC.DateField : Date().timeIntervalSince1970
            
        ]) { (error) in
            if let err = error {
                print("cannot upload your data because of \(err.localizedDescription)")
            }else {
                print("Successfully saved ")
            }
        }
    }
    
    func writeProjectToLocal(_ object: MyProject) -> Results<MyProject>?{
        do {
            try realm.write{
                realm.add(object)
            }
        }catch {
            fatalError("unable to save your project because of \(error.localizedDescription)")
        }
        
        return loadData(byEmail: object.ProjectSender)
    }
    
    func updateProjectToLocal(lhs : Results<MyProject>?,
                              toIndex index: Int,
                              withString : String) -> Results<MyProject>?{
        do {
            try realm.write{
                lhs?[index].ProjectTitle = withString
            }
        }catch {
            fatalError("cannot updated due to \(error.localizedDescription)")
        }
        return lhs
    }
    
    func GetFireBaseID(byName name : String,forEmail email :String ,
                               completion:@escaping(String) -> ()) {
        db.collection(FireBaseConstant.ProjectCollectioName)
            .whereField(FireBaseConstant.ProjectVC.SenderName, isEqualTo: email)
            .whereField(FireBaseConstant.ProjectVC.ProjectName, isEqualTo: name).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err.localizedDescription)")
            } else {
                if let returnString = querySnapshot?.documents.first?.documentID {
                    completion(returnString)
                }else {
                    completion("")
                }
            }
        }
    }
    
    
    func updateProjectObj(ObjectID : String, updateName: String){
        db.collection(FireBaseConstant.ProjectCollectioName).document(ObjectID).updateData([
            FireBaseConstant.ProjectVC.ProjectName : updateName
        ])
    }
    
    
    func DelFromFireBase(withid id:String){
        db.collection(FireBaseConstant.ProjectCollectioName).document(id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
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
