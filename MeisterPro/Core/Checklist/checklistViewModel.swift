//
//  checklistViewModel.swift
//  MeisterPro
//
//  Created by Apple Macbook on 17/12/2022.
//

import UIKit
import Firebase
import RealmSwift


class checklistViewModel : basicViewModel {

    
    func formChecklistObj(name : String, email: String) -> MyCheckList {
        let temp = MyCheckList()
        temp.CheckListTitle = name
        temp.CheckListSender = email
        return temp
    }
    
    func uploadChecklistToCloud(forEmail email: String,
                                        checklist comingObj: MyCheckList){
        db.collection(FireBaseConstant.CheckListCollectionName).addDocument(data: [
            FireBaseConstant.CheckListVC.SenderName : email,
            FireBaseConstant.CheckListVC.CheckListName : comingObj.CheckListTitle,
            FireBaseConstant.CheckListVC.Condition : comingObj.Check,
            FireBaseConstant.CheckListVC.DateField : Date().timeIntervalSince1970
            
        ]) { (error) in
            if let err = error  {
                print("Couldnt upload your data because of \(err.localizedDescription)")
            }else {
                print("Successfully saved your data to cloud ")
            }
        }
    }
    

    
    func writeChecklistlocally(_ comingObj : MyCheckList) -> Results<MyCheckList>? {
        do {
            try realm.write{
                realm.add(comingObj)
            }
        }catch {
            fatalError("couldnt save your task due to \(error.localizedDescription)")
        }
        return loadDatalocally(forEmail: comingObj.CheckListSender)
    }
    
    func loadDatalocally(forEmail email: String) -> Results<MyCheckList>? {
         return realm.objects(MyCheckList.self).filter(NSPredicate(format: "CheckListSender == %@", "\(email)"))
    }
    
    
    func loadDataFromCloud(byEmail email: String,
                                   completion: @escaping(Results<MyCheckList>?)->()){
        db.collection(FireBaseConstant.CheckListCollectionName)
            .whereField(FireBaseConstant.CheckListVC.SenderName, isEqualTo: email).order(by: FireBaseConstant.CheckListVC.DateField).getDocuments() { (query, error) in
            if let e = error {
                print("Couldnt load your data from cloud due to \(e.localizedDescription)")
            }else {
                if let ReturnData = query?.documents {
                    for EachData in ReturnData {
                        let currData = EachData.data()
                        if let currCheckListName =  currData[FireBaseConstant.CheckListVC.CheckListName] as? String ,
                           let currEmail = currData[FireBaseConstant.CheckListVC.SenderName] as? String,
                           let CurrentCondition = currData[FireBaseConstant.CheckListVC.Condition] as? Bool{
                            
                            let newObj = MyCheckList()
                            newObj.CheckListTitle = currCheckListName
                            newObj.CheckListSender = currEmail
                            newObj.Check = CurrentCondition
                            do {
                                try self.realm.write{
                                    self.realm.add(newObj)
                                }
                            }catch {
                                fatalError("unable to save your project because of \(error.localizedDescription)")
                            }
                        }
                        
                    }
                }
                completion(self.loadDatalocally(forEmail: email))
            }
        }
    }
    
    
    func updateToCloud(withID: String, name: String){
        db.collection(FireBaseConstant.CheckListCollectionName).document(withID).updateData([
            FireBaseConstant.CheckListVC.CheckListName : name
        ])
    }
    func updateToCloud(withID: String, check: Bool){
        db.collection(FireBaseConstant.CheckListCollectionName).document(withID).updateData([
            FireBaseConstant.CheckListVC.Condition : check
        ])
    }
    
    func updateLocally(title: String, atIndex index: Int,
                       arr: Results<MyCheckList>?) -> Results<MyCheckList>? {
        do {
            try realm.write{
                arr?[index].CheckListTitle = title
            }
        }catch let err {
            print("couldnt update in db due to \(err.localizedDescription)")
        }
        return arr
    }
    
    func updateLocally(atIndex index: Int,
                       arr: Results<MyCheckList>) -> Results<MyCheckList> {
        do {
            try realm.write{
                arr[index].Check = !arr[index].Check
            }
        }catch {
            print("error checking or unchecking your object \(error.localizedDescription)")
        }
        return arr
    }
    

    func GetFireBaseID(forEmail email:String,
                       forTitle comingCheckListTitle : String ,
                       completion:@escaping(String) -> ()) {
        db.collection(FireBaseConstant.CheckListCollectionName)
            .whereField(FireBaseConstant.CheckListVC.SenderName, isEqualTo: email)
            .whereField(FireBaseConstant.CheckListVC.CheckListName, isEqualTo: comingCheckListTitle).getDocuments() { (querySnapshot, err) in
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
    
    func DelFromFireBase(with id:String) {
        db.collection(FireBaseConstant.CheckListCollectionName).document(id).delete { (error) in
            if let err = error {
                print("Error removing document \(err)")
            }else {
                print("Document Successfully removed")
            }
        }
    }

}
