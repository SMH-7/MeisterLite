//
//  ProfileVC.swift
//  MeisterPro
//
//  Created by Apple Macbook on 04/03/2021.
//

import UIKit
import Firebase
import RealmSwift
import SafariServices

class ProfileVC: basicVC {
    
    private var realm: Realm {
        get {
            do {
                let realm = try Realm()
                return realm
            }
            catch let err {
                print("problem with database", err.localizedDescription)
            }
            return self.realm
        }
    }
    private let viewModel = profileViewModel()
    
    private var senderEmail : String  = ""

    lazy private var profileCover = coverImageView()
    lazy private var profilePicture = mainProfileImageView()
    
    lazy private var coverTrigger = UIImageView()
    lazy private var profilePicPicker = UIImagePickerController()
    lazy private var profileCoverPicker = UIImagePickerController()
    
    lazy private var usernameLabel = UILabel()
    lazy private var usernameBackground =  UIView()
    lazy private var taptoIntro = socialsButton()
    
    private var filteredObj : Results<AppimageData>? {
        didSet {
            if let back = filteredObj?.first?.background ,
               let front = filteredObj?.first?.profile  {
                profileCover.image = UIImage(data: (back as Data))
                profilePicture.image = UIImage(data: (front as Data))
            }
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkCache()
        checkNeedForCloud()
        
        settingViews()
    }
    
    deinit {
        print("deinit called")
    }
    
    
    //MARK: - get user email and id
    func SetEmailAndTitle(Title : String ,Email : String){
        senderEmail = Email
        usernameLabel.text = Title
    }
    
    //MARK: - sync with local and cloud db
    private func checkCache(){
        filteredObj = viewModel.loadData(byEmail: senderEmail)
    }
    
    private func checkNeedForCloud(){
        if filteredObj?.count == 0 {
            viewModel.loadFromCloud(byEmail: senderEmail) {[weak self] comingData in
                guard let self else {return}
                self.filteredObj = comingData
            }
        }
    }
    
    //MARK: - setting up views
    
    private func settingViews(){
        title =  "Profile"
        view.backgroundColor = .white
        
        let dissmissButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissView))
        dissmissButton.tintColor = .cyan
        navigationItem.rightBarButtonItem = dissmissButton
        
        view.addSubview(profileCover)
        
        profileCover.snp.makeConstraints { (para) in
            para.top.equalTo(view)
            para.leading.trailing.equalTo(view)
            para.height.equalTo(view.frame.width/1.5)
        }
        
        
        coverTrigger.tintColor = .black
        coverTrigger.image = UIImage(systemName: "pencil")
        coverTrigger.isUserInteractionEnabled = true
        
        view.addSubview(coverTrigger)
        let tappedgesture_1 =  userProfileViewGesture(target: self, action: #selector(editCover))
        coverTrigger.addGestureRecognizer(tappedgesture_1)
        
        
        coverTrigger.snp.makeConstraints { (para) in
            para.height.width.equalTo(25)
            para.trailing.equalTo(10).offset(-10)
            para.bottom.equalTo(profileCover).offset(-30)
        }
        
        
        view.addSubview(profilePicture)
        let tappedgesture_2 =  userProfileViewGesture(target: self, action: #selector(editDP))
        profilePicture.addGestureRecognizer(tappedgesture_2)
        
        profilePicture.snp.makeConstraints { (para) in
            para.top.equalTo(view).offset(view.frame.width/2.14)
            para.centerX.equalTo(view.snp.centerX)
            para.width.height.equalTo(view.frame.width/3.6)
        }
        
        usernameBackground.backgroundColor = .clear
        view.addSubview(usernameBackground)
        view.sendSubviewToBack(usernameBackground)
        
        usernameBackground.snp.makeConstraints { (para) in
            para.top.equalTo(profileCover.snp.bottom)
            para.leading.trailing.equalTo(view)
            para.height.equalTo(view.frame.width/2)
        }
        
        
        usernameLabel.textColor = .black
        usernameLabel.textAlignment = .center
        usernameBackground.addSubview(usernameLabel)
        
        usernameLabel.snp.makeConstraints { (para) in
            para.top.equalTo(profilePicture.snp.bottom).offset(10)
            para.centerX.equalTo(profilePicture.snp.centerX)
            para.height.equalTo(view.frame.width/9.35)
            para.width.equalTo(view.frame.width/3.12)
        }
        
        
        usernameBackground.addSubview(taptoIntro)
        taptoIntro.addTarget(self, action: #selector(pushSocial), for: .touchUpInside)
        
        taptoIntro.snp.makeConstraints { (para) in
            para.bottom.equalTo(usernameBackground)
            para.leading.trailing.equalTo(usernameBackground)
            para.height.equalTo(view.frame.width/9.35)
        }
        
    }
    
}

//MARK: - view triggers

extension ProfileVC {
    @objc private func dismissView(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func pushSocial(){
        if let profileURL = URL(string: "https://www.linkedin.com/in/muaz-hassan-b671967b/") {
            let safariVC = SFSafariViewController(url: profileURL)
            safariVC.preferredControlTintColor = .cyan
            present(safariVC, animated: true)
        }
    }
    
    @objc private func editDP(){
        profilePicPicker.delegate = self
        profilePicPicker.allowsEditing = true
        profilePicPicker.modalPresentationStyle = .popover
        present(profilePicPicker, animated: true)
    }
    
    @objc private func editCover(){
        profileCoverPicker.delegate = self
        profileCoverPicker.allowsEditing = true
        profileCoverPicker.modalPresentationStyle = .popover
        present(profileCoverPicker, animated: true)
    }
}



//MARK: - picker delegate

extension ProfileVC : UIImagePickerControllerDelegate ,  UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        guard let image = image else { return }
        dismiss(animated: true) {[weak self] in
            guard let self else {return}

            if picker == self.profilePicPicker {
                self.profilePicture.image = image
                
                self.viewModel.GetIDFromFireBase(self.senderEmail) {[weak self] returningID in
                    guard let self else {return}
                    if returningID.count > 0 {
                        self.viewModel.updateDPToCloud(withID: returningID, withImage: image)
                    } else {
                        self.viewModel.updateToCloud(with: self.viewModel.formImageObj(email: self.senderEmail,
                                                                                       profile: image), forEmail: self.senderEmail)
                    }
                }
                
                do {
                    try self.realm.write{
                        if self.filteredObj?.first == nil {
                            self.realm.add(self.viewModel.formImageObj(email: self.senderEmail, profile: image))
                        } else {
                            self.filteredObj?.first?.profile = NSData(data: self.viewModel.compressImage(image))
                        }
                    }
                }catch {
                    print("error saving your profile image")
                }
            }else {
                self.profileCover.image = image
                
                self.viewModel.GetIDFromFireBase(self.senderEmail) {[weak self] returningID in
                    guard let self else {return}
                    if  returningID.count > 0 {
                        self.viewModel.updateCoverToCloud(withID: returningID, withImage: image)
                    }
                    else {
                        self.viewModel.updateToCloud(with: self.viewModel.formImageObj(email: self.senderEmail,
                                                                                       cover: image), forEmail: self.senderEmail)
                    }
                    
                }
                do {
                    try self.realm.write{
                        if self.filteredObj?.first?.background ==  nil {
                            self.realm.add(self.viewModel.formImageObj(email: self.senderEmail,cover: image))
                        }else {
                            self.filteredObj?.first?.background = NSData(data: self.viewModel.compressImage(image))
                        }
                        
                    }
                }catch {
                    print("error saving your background image ")
                }
            }
            
        }
    }
}
