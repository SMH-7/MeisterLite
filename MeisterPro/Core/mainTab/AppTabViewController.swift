//
//  MSTabBar.swift
//  MeisterPro
//
//  Created by Apple Macbook on 15/02/2021.
//

import UIKit
import SnapKit

class AppTabViewController: UITabBarController {
    
    private let viewModel = AppTabViewModel()
    
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
        setAppearance()
        setTabButtons()
        
    }
    
    deinit {
        print("deinit called")
    }
    
    private func setAppearance(){
        UITabBar.appearance().tintColor = .cyan
        UITabBar.appearance().barTintColor = UIColor.clear
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage =  UIImage()
    }
    
    private func setTabButtons(){
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
        return viewModel.customizeNavBar(viewController: WelcomeViewController(),
                                  title: "Welcome",
                                  tabImage: .welcomeVC,
                                  tag: 0)
    }
    private func SettingProject() -> UINavigationController {
        return viewModel.customizeNavBar(viewController: MSProjectVC(),
                                  title: "Projects",
                                  tabImage: .projectVC,
                                  tag: 1)
    }
    private func SettingTask() -> UINavigationController {
        return viewModel.customizeNavBar(viewController: MSTaskVC(),
                                  title: "Tasks",
                                  tabImage: .taskVC,
                                  tag: 2)
    }
    private func SettingChecklist() -> UINavigationController {
        return viewModel.customizeNavBar(viewController: MSChecklistVC(),
                                  title: "CheckLists",
                                  tabImage: .checklistVC,
                                  tag: 3)
    }
    
}

//MARK: - trigger functions

extension AppTabViewController {
    @objc private func loggingOut(){
        viewModel.userSignOff(navigationController: self.navigationController)
    }
    
    @objc private func profileView(){
        present(viewModel.presentProfileVC(), animated: true)
    }
    
}
