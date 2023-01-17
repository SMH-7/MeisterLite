//
//  taskViewModel.swift
//  MeisterPro
//
//  Created by Apple Macbook on 17/12/2022.
//

import UIKit
import Firebase
import RealmSwift

class taskViewModel : basicViewModel {
    
    func formTaskObj(withName name: String, forEmail email: String) -> MyTask {
        let temp = MyTask()
        temp.TaskSender = email
        temp.TaskTitle = name
        return temp
    }
    
    func uploadTaskToCloud(_ object: MyTask){
        db.collection(FireBaseConstant.TaskCollectionName).addDocument(data: [
            FireBaseConstant.TaskVC.SenderName : object.TaskSender,
            FireBaseConstant.TaskVC.TaskName : object.TaskTitle,
            FireBaseConstant.TaskVC.DateField : Date().timeIntervalSince1970
        ]) { (error) in
            if let err = error {
                print("cannot upload your data because of \(err.localizedDescription)")
            }else {
                print("Successfully saved")
            }
        }
    }
        
    func loadData(byEmail : String) -> Results<MyTask>? {
        return realm.objects(MyTask.self).filter(NSPredicate(format: "TaskSender == %@", "\(byEmail)"))
    }
    
    
    func writeTaskToLocal(_ comingtask : MyTask) -> Results<MyTask>? {
        do {
            try realm.write {
                realm.add(comingtask)
            }
            
        }catch{
            fatalError("unable to save your task due to \(error.localizedDescription)")
        }
        return loadData(byEmail: comingtask.TaskSender)
    }
    
    
    func loadFromCloud(forEmail email: String,completion: @escaping(Results<MyTask>)->()){
        db.collection(FireBaseConstant.TaskCollectionName).whereField(FireBaseConstant.TaskVC.SenderName, isEqualTo: email).order(by: FireBaseConstant.TaskVC.DateField).getDocuments() { (query, error) in
            if let e = error {
                print("There are error fetching your data \(e.localizedDescription)")
            }else {
                if let ReturnData = query?.documents {
                    for EachData in ReturnData {
                        let CurrentData = EachData.data()
                        if let CurrentTaskName = CurrentData[FireBaseConstant.TaskVC.TaskName] as? String ,
                           let CurrentEmail =  CurrentData[FireBaseConstant.TaskVC.SenderName] as? String {
                            
                            let ToBeSave =  MyTask()
                            ToBeSave.TaskSender = CurrentEmail
                            ToBeSave.TaskTitle = CurrentTaskName
                            do {
                                try self.realm.write{
                                    self.realm.add(ToBeSave)
                                }
                            }catch let err {
                                fatalError("unable to save your project because of \(err.localizedDescription)")
                            }
                        }
                    }

                    if let temp = self.loadData(byEmail: email) { completion(temp)}
                }
            }
        }
        
    }

    func GetFireBaseID(byName : String ,forEmail :String,
                       completion:@escaping(String) -> ()) {
        db.collection(FireBaseConstant.TaskCollectionName)
            .whereField(FireBaseConstant.TaskVC.SenderName, isEqualTo: forEmail)
            .whereField(FireBaseConstant.TaskVC.TaskName, isEqualTo: byName).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let returnString = querySnapshot?.documents.first?.documentID {
                    completion(returnString)
                }else {
                    completion("")
                }
            }
        }
    }
    
    func updateTaskToCloud(withID : String, updateTask: String){
        db.collection(FireBaseConstant.TaskCollectionName).document(withID).updateData([
            FireBaseConstant.TaskVC.TaskName : updateTask
        ])
    }
    
    func updateTaskAndSync(lhs : Results<MyTask>?,
                           atIndex index: Int,
                           withText text:String) -> Results<MyTask>?{
        do {
            try realm.write{
                lhs?[index].TaskTitle =  text
            }
        }catch {
            print("couldnt be updated due to \(error.localizedDescription)")
        }
        return lhs
    }
    
    
    func DelFromFireBase(id: String){
        db.collection(FireBaseConstant.TaskCollectionName).document(id).delete(){ err in
            if let err = err {
                print("Error removing document due to \(err.localizedDescription)")
            }else {
                print("Document successfully removed!")
            }
        }
    }
}
