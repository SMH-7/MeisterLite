//
//  MSChecklist.swift
//  MeisterPro
//
//  Created by Apple Macbook on 15/02/2021.
//

import UIKit
import SnapKit
import RealmSwift

class MSChecklist: basicVC {
    
    
    var CheckLists : Results<MyCheckList>? {
        didSet {
            checklistTableView.reloadData()
        }
    }
    
    private var checklistTableView = toDoTV()
    private let viewModel = checklistViewModel()
    lazy private var TFOverlay = TFeditorVC()
    
    private var senderEmail : String = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        senderEmail = viewModel.fetchEmailForCurrentSession()
        
        LoadData()
        checkNeedForCloud()
        settingViews()
    }
    
    //MARK: - database functions
    
    private func LoadData(){
        CheckLists = viewModel.loadDatalocally(forEmail: senderEmail)
    }
    
    private func checkNeedForCloud(){
        if CheckLists?.count == 0 {
            viewModel.loadDataFromCloud(byEmail: senderEmail) {[weak self] comingData in
                guard let self else {return}
                self.CheckLists = comingData
            }
        }
    }
    
    private func writeChecklistAndSync(_ comingObj : MyCheckList){
        CheckLists = viewModel.writeChecklistlocally(comingObj)
    }
    
    
    //MARK: - setting ui
    
    private func settingViews(){
        let AddButton =  UIBarButtonItem(barButtonSystemItem: .add , target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItems = [AddButton]
        
        TFOverlay.delegate = self
        
        checklistTableView.delegate = self
        checklistTableView.dataSource = self
        checklistTableView.register(MSChecklistCell.self, forCellReuseIdentifier: Contants.CheckListReuseID)
        view.addSubview(checklistTableView)
        
        checklistTableView.snp.makeConstraints { (para) in
            para.leading.trailing.top.bottom.equalTo(view)
        }
        
    }
    
    

    

    
}

//MARK: - protocol delegate

extension MSChecklist : textValuePasser {
    func didupdatevalue(string: String, index: Int) {
        guard let previousTitle = CheckLists?[index].CheckListTitle else { return }
        
        viewModel.GetFireBaseID(forEmail: senderEmail, forTitle: previousTitle){[weak self] (returnedID) in
            guard let self else {return}
            if returnedID.count > 0 {
                self.viewModel.updateToCloud(withID: returnedID, name: string)
            }else {
                print("couldnt find your file ")
            }
        }

        CheckLists = viewModel.updateLocally(title: string, atIndex: index, arr: CheckLists)
    }
}


//MARK: - trigger functions

extension MSChecklist {
    @objc private func addTapped(){
        var localTextField = UITextField()
        let AddPopUp = UIAlertController(title: "Checklist", message: "Add to your checklist...", preferredStyle: .alert)
        AddPopUp.addTextField { (textfield) in
            textfield.placeholder = "Add new item..."
            localTextField = textfield
        }
        let PopAction = UIAlertAction(title: "Done", style: .default) {[weak self] (action) in
            guard let self else {return}
            if let text = localTextField.text {
                let temp = self.viewModel.formChecklistObj(name: text,
                                                           email: self.senderEmail)
                self.viewModel.uploadChecklistToCloud(forEmail: self.senderEmail,
                                                      checklist: temp)
                self.writeChecklistAndSync(temp)
            }
        }
        AddPopUp.addAction(PopAction)
        present(AddPopUp, animated: true)
    }
}

//MARK: - table view delegate
extension MSChecklist : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if var CheckLists {
            viewModel.GetFireBaseID(forEmail: senderEmail, forTitle: CheckLists[indexPath.row].CheckListTitle) {[weak self] (returnedID) in
                guard let self else { return }
                if returnedID.count > 0 {
                    self.viewModel.updateToCloud(withID: returnedID, check: CheckLists[indexPath.row].Check)
                }else  {
                    print("couldnt find your file")
                }
            }
            self.CheckLists = viewModel.updateLocally(atIndex: indexPath.row, arr: CheckLists)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let detachedObj = RealmHelper.DetachedCopy(of: CheckLists![indexPath.row]) else {
            print("Couldnt detached your object")
            return nil
        }
        
        let DeleteButton =  UITableViewRowAction(style: .default, title: "Delete") { [weak self] (_, indexpath) in
            guard let self else {return}
            self.viewModel.GetFireBaseID(forEmail: detachedObj.CheckListSender,
                                    forTitle: detachedObj.CheckListTitle) { (returnedID) in
                if returnedID.count > 0 {
                    self.viewModel.DelFromFireBase(with: returnedID)
                }else {
                    print("Couldnt find your file ")
                }
            }
            
            self.viewModel.deleteObjectlocally(fromArr: self.CheckLists, atIndex: indexpath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        DeleteButton.backgroundColor = .systemRed
        
        let EditButton = UITableViewRowAction(style: .default, title: "Edit") {[weak self] (rowaction, indexpath) in
            guard let self else {return}
            self.TFOverlay.textfieldMetaData(with: indexpath.row, withtext: self.CheckLists![indexpath.row].CheckListTitle)
            self.TFOverlay.modalPresentationStyle = .overFullScreen
            self.TFOverlay.modalTransitionStyle = .crossDissolve
            self.present(self.TFOverlay, animated: true, completion: nil)
        }
        
        EditButton.backgroundColor = .systemGreen
        
        return [DeleteButton,EditButton]
    }
    
}
extension MSChecklist : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CheckLists?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = checklistTableView.dequeueReusableCell(withIdentifier: Contants.CheckListReuseID, for: indexPath) as! MSChecklistCell
        cell.accessoryType = (CheckLists?[indexPath.row].Check)! ? .checkmark : .none
        cell.textLabel?.text = CheckLists?[indexPath.row].CheckListTitle
        return cell
    }
}
