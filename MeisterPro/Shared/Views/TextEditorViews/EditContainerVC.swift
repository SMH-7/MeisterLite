//
//  TFeditorVC.swift
//  MeisterPro
//
//  Created by Apple Macbook on 02/03/2021.
//

import UIKit
import SnapKit

protocol textValuePasser : AnyObject {
    func didupdatevalue(string : String , index : Int)
}

class EditContainerVC: UIViewController {
    
    weak var delegate : textValuePasser?
    
    private let padding = 20
    private var index : Int = 0
    
    lazy private var containerView = EditContainer()
    lazy private var editableTF = EditContainerTextField()
    lazy private var dismissButton = containerTFButton()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.52, green: 0.52, blue: 0.52, alpha: 0.7)
        
        settingContainerView()
        settingContainerTextField()
        settingContainerButton()
    }

    
    //MARK: - communicator
    
    func textfieldMetaData(with comingIndex : Int , withtext comingText: String){
        self.index = comingIndex
        self.editableTF.text = comingText
    }
    
    //MARK: - setting UI
    
    private func settingContainerView(){
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { (para) in
            para.centerX.equalTo(view.snp.centerX)
            para.centerY.equalTo(view.snp.centerY).offset(-50)
            para.width.equalTo(280)
            para.height.equalTo(220)
        }
    }
    
    private func settingContainerTextField(){
        editableTF.delegate = self
        containerView.addSubview(editableTF)
        
        editableTF.snp.makeConstraints { (para) in
            para.leading.top.equalTo(containerView).offset(padding/2)
            para.trailing.equalTo(containerView.snp.trailing).offset(-padding/2)
            para.height.equalTo(126)
        }
    }
    
    private func settingContainerButton(){
        dismissButton.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        containerView.addSubview(dismissButton)
        
        dismissButton.snp.makeConstraints { (para) in
            para.leading.equalTo(containerView.snp.leading).offset(padding)
            para.trailing.bottom.equalTo(containerView).offset(-padding)
            para.height.equalTo(44)
        }
    }
}



//MARK: - delegates
extension EditContainerVC {
    @objc private func dismissTapped(){
        dismiss(animated: true) {
            if let typedtext = self.editableTF.text {
                self.delegate?.didupdatevalue(string: typedtext, index: self.index)
            }
        }
    }
}

extension EditContainerVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismiss(animated: true)
        return true
    }
}


