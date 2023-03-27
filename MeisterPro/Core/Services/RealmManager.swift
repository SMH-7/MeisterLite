//
//  localServices.swift
//  MeisterPro
//
//  Created by Apple Macbook on 02/02/2023.
//

import Foundation
import RealmSwift

final class RealmManager<T : Object> {
    
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
    lazy var fetchedObjects : Binder<Results<T>> = Binder(realm.objects(T.self))
    

    /// writing data
    func writeObjectToRealm(_ object : T){
        do {
            try realm.write{
                realm.add(object)
            }
        }catch {
            self.error.value = error.localizedDescription
        }
    }
    
    /// checking for the data
    func dataExistsInRealm(forEmail email: String, queryFilter Filter: String){
        self.fetchedObjects.value = realm.objects(T.self).filter(NSPredicate(format: "\(Filter) == %@", "\(email)"))
    }


    
    /// updating data
    func updateCategoryTitleInRealm(title: String, at index: Int, category : Category) {
        do {
            try realm.write{
                switch category {
                case .checkList:
                    (fetchedObjects.value as? Results<Checklist>)?[index].CheckListTitle = title
                case .projectList:
                    (fetchedObjects.value as? Results<Project>)?[index].ProjectTitle = title
                case .taskList:
                    (fetchedObjects.value as? Results<Task>)?[index].TaskTitle = title
                default:
                    break
                }
            }
        }catch let err {
            self.error.value = err.localizedDescription
        }
        self.fetchedObjects.value = fetchedObjects.value
    }
    
    
        
    
    ///  updating data only applicable to checklist
    func updateCheckInRealmAtIndex(_ index: Int, category : Category) {
        do {
            try realm.write{
                if category == .checkList {
                    var reff = (fetchedObjects.value[index] as! Checklist)
                    reff.Check = !reff.Check
                }
            }
        }catch {
            self.error.value = error.localizedDescription
        }
        self.fetchedObjects.value = fetchedObjects.value
    }
        
    
    ///  updating data only applicable to profile
    func updateProfileImageInRealm(isProfileImage : Bool, image : NSData ) {
        do {
            try realm.write{
                if isProfileImage {
                    (self.fetchedObjects.value.first as! Profile).profile = image
                } else {
                    (self.fetchedObjects.value.first as! Profile).background = image
                }
            }
        }catch {
            self.error.value = error.localizedDescription
        }
    }
    
    /// deleting data
    func deleteObjectFromRealm(atIndex index: Int){
        do {
            try realm.write{
                realm.delete(fetchedObjects.value[index])
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
    
//    self.fetchObjects.value = realm.objects(T.self).filter(NSPredicate(format: "\(Filter) == %@", "\(email)"))

}



