//
//  registerViewModel.swift
//  MeisterPro
//
//  Created by Apple Macbook on 16/12/2022.
//
import UIKit
import Firebase


class registerViewModel {
    let db = Firestore.firestore()

    func createUser(withEmail email : String,
                    withPassword password : String,
                    onBar comingNavBar : UINavigationController){
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let err = error {
                print("error registering your account due to \(err.localizedDescription)")
            }else {
                comingNavBar.pushViewController(MSTabBar(), animated: true)
            }
        }
    }
    
    
    //MARK: - Test functions
    
    func createTestUser(withEmail email: String,
                    password: String) async throws -> String? {
        let response = try await Auth.auth().createUser(withEmail: email, password: password)
        return response.user.email
    }

    func deleteCreatedUser() async throws -> Bool {
        do {
            try await Auth.auth().currentUser?.delete()
            return true
        }catch {
            return false
        }
    }
}
