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

class ProfileVC: BaseVC {
    
    
    private let viewModel = UserProfileViewModel()

    
    lazy private var profileCover = CoverImageView()
    lazy private var profilePicture = MainProfileImageView()
    lazy private var coverTrigger = UIImageView()
    lazy private var profilePicker = UIImagePickerController()
    lazy private var coverPicker = UIImagePickerController()
    lazy private var usernameLabel = UILabel()
    lazy private var usernameBackground =  UIView()
    lazy private var introButton = SocialsButton()
    
    private var senderEmail : String  = ""
    private var filteredObj : Results<Profile>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBinder()
        viewModel.fetchEmail()
        checkIfLocalDataExists()
        checkNeedForCloud()
        setViews()
    }
    
    deinit {
        print("deinit called")
    }
    
    //MARK: - sync database and setting binders
    
    private func setBinder() {
        viewModel.email.bind { [weak self] comingEmail in
            guard let self else { return }
            self.senderEmail = comingEmail
        }
        viewModel.userProfileData.bind { [weak self] comingData in
            guard let self else { return }
            self.filteredObj = comingData
            if let back = self.filteredObj?.first?.background ,
               let front = self.filteredObj?.first?.profile  {
                self.profileCover.image = UIImage(data: (back as Data))
                self.profilePicture.image = UIImage(data: (front as Data))
            }
        }
    }
    
    private func checkIfLocalDataExists(){
        viewModel.loadProfileLocally(forEmail: senderEmail)
    }
    
    private func checkNeedForCloud(){
        if filteredObj?.count == 0 {
            viewModel.loadProfileFromFirebase(forEmail: senderEmail)
        }
    }
    
    
    //MARK: - get backup email and username from tab view (nav method)
    func setUsernameEmail(username : String ,email : String){
        senderEmail = email
        usernameLabel.text = username
    }
    
    //MARK: - setting views
    
    private func setViews() {
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
        let tappedgesture_1 =  UserProfileViewGesture(target: self, action: #selector(editCover))
        coverTrigger.addGestureRecognizer(tappedgesture_1)
        
        coverTrigger.snp.makeConstraints { (para) in
            para.height.width.equalTo(25)
            para.trailing.equalTo(10).offset(-10)
            para.bottom.equalTo(profileCover).offset(-30)
        }
        
        view.addSubview(profilePicture)
        let tappedgesture_2 =  UserProfileViewGesture(target: self, action: #selector(editDP))
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
        
        usernameBackground.addSubview(introButton)
        introButton.addTarget(self, action: #selector(pushSocial), for: .touchUpInside)
        
        introButton.snp.makeConstraints { (para) in
            para.bottom.equalTo(usernameBackground)
            para.leading.trailing.equalTo(usernameBackground)
            para.height.equalTo(view.frame.width/9.35)
        }
    }
}

//MARK: - triggers

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
        profilePicker.delegate = self
        profilePicker.allowsEditing = true
        profilePicker.modalPresentationStyle = .popover
        present(profilePicker, animated: true)
    }
    
    @objc private func editCover(){
        coverPicker.delegate = self
        coverPicker.allowsEditing = true
        coverPicker.modalPresentationStyle = .popover
        present(coverPicker, animated: true)
    }
}



//MARK: - picker delegate

extension ProfileVC : UIImagePickerControllerDelegate ,  UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image  = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        dismiss(animated: true) {[weak self] in
            guard let self else {return}
            switch picker {
            case self.profilePicker:
                
                self.viewModel.ModifyFireBaseProfile(forEmail: self.senderEmail,
                                                  isProfileImage: true,
                                                  newImage: image)
                
                
                if self.filteredObj?.first == nil {
                    self.viewModel.writeProfileLocally(forEmail: self.senderEmail, isProfileImage: true, image: image)
                } else {
                    self.viewModel.updateProfileLocally(forEmail: self.senderEmail, isProfileImage: true, image: image)
                }
                
            case self.coverPicker:

                self.viewModel.ModifyFireBaseProfile(forEmail: self.senderEmail,
                                                      isProfileImage: false,
                                                      newImage: image)

    
                if self.filteredObj?.first == nil {
                    self.viewModel.writeProfileLocally(forEmail: self.senderEmail, isProfileImage: false, image: image)
                } else {
                    self.viewModel.updateProfileLocally(forEmail: self.senderEmail, isProfileImage: false, image: image)
                }
            default:
                NSLog("picker out of bound")
            }
        }
    }
}
