//
//  profileViewModel.swift
//  MeisterPro
//
//  Created by Apple Macbook on 16/12/2022.
//

import UIKit
import Firebase
import RealmSwift


class UserProfileViewModel : BaseViewModel {
            
    private let realmService = RealmManager<Profile>()
    private let firebaseService = FirebaseManager<Profile>()
    
    lazy var userProfileData = Binder< Results<Profile> >(realm.objects(Profile.self))
    lazy var email = Binder<String>("")
    lazy var error = Binder<String>("")

    override init() {
        super.init()
        realmService.fetchedObjects.bind { [weak self] localData in
            guard let self else { return }
            self.userProfileData.value = localData
        }
        realmService.error.bind { [weak self] comingErr in
            guard let self else { return }
            self.error.value = comingErr
        }
        firebaseService.email.bind { [weak self] comingMail in
            guard let self else { return }
            self.email.value = comingMail
        }
        firebaseService.error.bind { [weak self] comingErr in
            guard let self else { return }
            self.error.value = comingErr
        }
        
    }
    
    //MARK: - cloud methods
    
    // fetch the user session email
    func fetchEmail() {
        firebaseService.fetchEmailForCurrentSession()
    }

    // read
    func loadProfileFromFirebase(forEmail email: String) {
        firebaseService.fetchFirebaseData(forEmail: email, category: .profile) { [weak self] in
            guard let self else { return }
            self.realmService.dataExistsInRealm(forEmail: email, queryFilter: "Sender")
        }
    }
    
    // update
    func ModifyFireBaseProfile(forEmail email:String,
                            isProfileImage : Bool,
                            newImage : UIImage ) {
        
        let arg = isProfileImage ? createProfileObject(email: email, profile: newImage)
                                : createProfileObject(email: email, cover: newImage)
        let newImage = NSData(data: compressImageToData(newImage))

        self.firebaseService.modifyFirebaseData(forEmail: email,
                                isProfileImage: isProfileImage,
                                newProfileData : newImage,
                                newProfileDataObject: arg,
                                category: .profile)
    }
    
    //MARK: - local methods
    
    // read
    func loadProfileLocally(forEmail email: String) {
        realmService.dataExistsInRealm(forEmail: email, queryFilter: "Sender")
    }
    
    // write
    func writeProfileLocally(forEmail: String, isProfileImage: Bool, image: UIImage) {
        let arg = isProfileImage ? createProfileObject(email: forEmail, profile: image)
                                : createProfileObject(email: forEmail, cover: image)
        realmService.writeObjectToRealm(arg)
        self.loadProfileLocally(forEmail: forEmail)
    }
    
    //update
    func updateProfileLocally(forEmail: String, isProfileImage: Bool, image: UIImage) {
        let newImage = NSData(data: compressImageToData(image))
        realmService.updateProfileImageInRealm(isProfileImage: isProfileImage,
                            image : newImage)
        self.loadProfileLocally(forEmail: forEmail)
    }
    
    //MARK: - helpers
    private func compressImageToData(_ image: UIImage) -> Data {
        guard let jpegData = image.jpegData(compressionQuality: 1) else {
            return Data()
        }
        return jpegData
    }
    
    private func createProfileObject(email: String, profile: UIImage? = nil, cover: UIImage? = nil) -> Profile {
        let temp = Profile()
        temp.Sender = email
        temp.profile = NSData(data: compressImageToData(profile ?? UIImage()))
        temp.background = NSData(data: compressImageToData(cover ?? UIImage()))
        return temp
    }
}
