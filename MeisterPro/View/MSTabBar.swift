//
//  MSTabBar.swift
//  MeisterPro
//
//  Created by Apple Macbook on 15/02/2021.
//

import UIKit
import SnapKit

class MSTabBar: UITabBarController {
    
    private let viewModel = tabViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        navigationItem.hidesBackButton = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        navigationItem.hidesBackButton = false
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        appearance()
        settingTopSideButtons()
        
    }
    
    deinit {
        print("deinit called")
    }
    
    private func appearance(){
        UITabBar.appearance().tintColor = .cyan
        UITabBar.appearance().barTintColor = UIColor.clear
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage =  UIImage()
    }
    
    private func settingTopSideButtons(){
        viewControllers = [SettingWelcome(),
                           SettingProject(),
                           SettingTask(),
                           SettingChecklist()]
        
        let logoutButtton = UIBarButtonItem(title: "SignOut", style: .plain, target: self, action: #selector(loggingOut))
        navigationItem.rightBarButtonItems = [logoutButtton]
        
        let profileButton = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.fill"), style: .plain, target: self, action: #selector(profileView))
        navigationItem.leftBarButtonItems = [profileButton]
    }
    
    private func SettingWelcome() -> UINavigationController {
        return viewModel.customizeNavBar(withView: WelcomeViewController(),
                                  title: "Welcome",
                                  image: .Bell,
                                  tag: 0)
    }
    private func SettingProject() -> UINavigationController {
        return viewModel.customizeNavBar(withView: MSProjects(),
                                  title: "Projects",
                                  image: .Project,
                                  tag: 1)
    }
    private func SettingTask() -> UINavigationController {
        return viewModel.customizeNavBar(withView: MSTasks(),
                                  title: "Tasks",
                                  image: .Task,
                                  tag: 2)
    }
    private func SettingChecklist() -> UINavigationController {
        return viewModel.customizeNavBar(withView: MSChecklist(),
                                  title: "CheckLists",
                                  image: .CheckList,
                                  tag: 3)
    }
    
}

//MARK: - trigger functions

extension MSTabBar {
    @objc private func loggingOut(){
        viewModel.signOff(nav: self.navigationController)
    }
    
    @objc private func profileView(){
        present(viewModel.presentProfileNav(), animated: true)
    }
    
}
