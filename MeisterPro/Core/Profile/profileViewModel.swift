//
//  profileViewModel.swift
//  MeisterPro
//
//  Created by Apple Macbook on 16/12/2022.
//

import UIKit
import Firebase
import RealmSwift


class profileViewModel : basicViewModel {

    let db = Firestore.firestore()
    
    func loadData(byEmail email: String) -> Results<AppimageData>? {
        return realm.objects(AppimageData.self).filter(NSPredicate(format: "Sender == %@", "\(email)"))
    }
    
    func compressImage(_  image: UIImage) -> Data {
        if let data = image.jpegData(compressionQuality: 1) {
            return  data
        }
        return Data()
    }
    
    func loadFromCloud(byEmail email: String, completion: @escaping(Results<AppimageData>?) -> ()){
        db.collection(FireBaseConstant.InfoCollectionName).whereField(FireBaseConstant.InfoVC.Sender, isEqualTo: email).getDocuments() { (query, error) in
            if let err = error {
                print("there is a error fetching your data \(err.localizedDescription)")
            }else {
                if let ReturnData = query?.documents.first?.data() {
                    if let CurrentEmail = ReturnData[FireBaseConstant.InfoVC.Sender] as? String ,
                       let CurrentDP = ReturnData[FireBaseConstant.InfoVC.Profile] as? NSData ,
                       let CurrentBackground = ReturnData[FireBaseConstant.InfoVC.Background] as? NSData {
                        
                        let ToBeSave = AppimageData()
                        ToBeSave.Sender = CurrentEmail
                        ToBeSave.background =  CurrentBackground
                        ToBeSave.profile = CurrentDP
                        
                        do {
                            try self.realm.write{
                                self.realm.add(ToBeSave)
                            }
                        }catch let err  {
                            fatalError("unable to save your data because of \(err.localizedDescription)")
                        }
                        
                    }
                }
                let temp = self.realm.objects(AppimageData.self).filter(NSPredicate(format: "Sender == %@", "\(email)"))
                completion(temp)
                 
            }
        }
    }
    
    func updateToCloud(with comingObj : AppimageData,forEmail comingEmail: String){
        db.collection(FireBaseConstant.InfoCollectionName).addDocument(data: [
            FireBaseConstant.InfoVC.Sender : comingEmail,
            FireBaseConstant.InfoVC.Background : comingObj.background,
            FireBaseConstant.InfoVC.Profile :  comingObj.profile
        ]){ (error) in
            if let err = error {
                print("cannot upload your data because of \(err.localizedDescription)")
            }else {
                print("Successfully saved")
            }
        }
    }
    
    func GetIDFromFireBase(_ ComingEmail:String , completion:@escaping(String)->()){
        db.collection(FireBaseConstant.InfoCollectionName).whereField(FireBaseConstant.InfoVC.Sender, isEqualTo: ComingEmail).getDocuments { (query, error) in
            if let err = error {
                print("error getting documents\(err.localizedDescription)")
            }else {
                if let returnString = query?.documents.first?.documentID {
                    completion(returnString)
                }else {
                    completion("")
                }
            }
        }
    }
    
    func updateDPToCloud(withID id: String, withImage image : UIImage){
        db.collection(FireBaseConstant.InfoCollectionName).document(id).updateData([
            FireBaseConstant.InfoVC.Profile  : NSData(data: compressImage(image))
        ])
    }
    func updateCoverToCloud(withID id: String, withImage image : UIImage){
        db.collection(FireBaseConstant.InfoCollectionName).document(id).updateData([
            FireBaseConstant.InfoVC.Background : NSData(data: compressImage(image))
        ])
    }
        
    func formImageObj(email: String, profile: UIImage? = nil, cover: UIImage? = nil) -> AppimageData {
        let temp = AppimageData()
        temp.Sender = email
        temp.profile = NSData(data: compressImage(profile ?? UIImage()))
        temp.background = NSData(data: compressImage(cover ?? UIImage()))
        return temp
    }
    
}
