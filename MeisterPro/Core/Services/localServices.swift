//
//  localServices.swift
//  MeisterPro
//
//  Created by Apple Macbook on 02/02/2023.
//

import Foundation
import RealmSwift

class localServices<T : Object> {
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
    lazy var fetchObjects : Binder<Results<T>> = Binder(realm.objects(T.self))
    

    /// writing data
    func writeData(_ comingObj : T){
        do {
            try realm.write{
                realm.add(comingObj)
            }
        }catch {
            self.error.value = error.localizedDescription
        }
    }
    
    /// checking for the data
    func checkForData(forEmail email: String, withFilter Filter: String){
        self.fetchObjects.value = realm.objects(T.self).filter(NSPredicate(format: "\(Filter) == %@", "\(email)"))
    }


    
    /// updating data
    func updateTitle(title: String,
             atIndex index: Int,
             arr: Results<T>?,
             type : ObjectType) {
        do {
            try realm.write{
                switch type {
                case .checklist:
                    (arr as? Results<MyCheckList>)?[index].CheckListTitle = title
                case .projectlist:
                    (arr as? Results<MyProject>)?[index].ProjectTitle = title
                case .tasklist:
                    (arr as? Results<MyTask>)?[index].TaskTitle = title
                }
            }
        }catch let err {
            self.error.value = err.localizedDescription
        }
        self.fetchObjects.value = arr!
    }
    
    
        
    
    ///  updating data only applicable to checklist
    func updateCheck(atIndex index: Int,
             arr: Results<T>,
             type : ObjectType) {
        do {
            try realm.write{
                if type == .checklist {
                    var arr = arr as! Results<MyCheckList>
                    arr[index].Check = !arr[index].Check
                }
            }
        }catch {
            self.error.value = error.localizedDescription
        }
        self.fetchObjects.value = arr
    }
    
    /// deleting data
    func deleteData(fromArr : Results<T>?, atIndex index: Int){
        guard let fromArr else { return }
        do {
            try realm.write{
                realm.delete(fromArr[index])
            }
        }catch let err {
            self.error.value = err.localizedDescription
        }
    }
    
    //MARK: - new approach dont take objects at all
    
//    func deleteDatav2(title: String?, withFilter Filter: String) {
//        guard title.count > 0 else { return }
//        do {
//            try realm.write{
//                realm.delete(realm.objects(T.self).filter(NSPredicate(format: "\(Filter) == %@", "\(title)")))
//            }
//        }catch let err {
//            self.error.value = err.localizedDescription
//        }
//
//    }

    
    
}



