//
//  MSChecklist.swift
//  MeisterPro
//
//  Created by Apple Macbook on 15/02/2021.
//

import UIKit
import SnapKit
import RealmSwift

class MSChecklistVC: BaseVC {
    
    
    var checklists : Results<Checklist>? 
    private var senderEmail : String = ""
    
    private let viewModel = ChecklistViewModel()

    private var tableView = BaseTV()
    lazy private var editorView = EditContainerVC()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setBinder()
        viewModel.fetchEmail()
        fetchData()
        checkNeedForCloud()
        setViews()
    }
    
    //MARK: - database functions
    
    private func setBinder() {
        viewModel.email.bind {[weak self] comingMail in
            guard let self else {return}
            self.senderEmail = comingMail
        }
        viewModel.checklists.bind({ [weak self] updateList in
            guard let self else { return }
            self.checklists = updateList
            self.tableView.reloadData()
        })
        viewModel.error.bind { err in
            print(err)
        }
    }
    private func fetchData(){
        viewModel.fetchObjectsLocally(forEmail: senderEmail)
    }
    
    private func checkNeedForCloud(){
        if checklists?.count == 0 {
            viewModel.fetchDataFromFirebase(forEmail: senderEmail)
        }
    }
    
    //MARK: - setting ui
    private func setViews(){
        let AddButton =  UIBarButtonItem(barButtonSystemItem: .add , target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItems = [AddButton]
        editorView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MSChecklistCell.self, forCellReuseIdentifier: TableViewIdentifiers.checklistID)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (para) in
            para.leading.trailing.top.bottom.equalTo(view)
        }
        
    }
    
    

    

    
}

//MARK: - protocol delegate

extension MSChecklistVC : textValuePasser {
    func didUpdateValueAtIndex(value: String, index: Int) {
        guard let previousTitle = checklists?[index].CheckListTitle else { return }
        viewModel.ModifyFireBaseData(forEmail: senderEmail, forTitle: previousTitle, newTitle: value)
        viewModel.updateObjectLocally(atIndex: index, title: value)
    }
}


//MARK: - trigger functions

extension MSChecklistVC {
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
                let temp = Checklist()
                temp.CheckListTitle = text
                temp.CheckListSender = self.senderEmail

                self.viewModel.uploadDataToFirebase(forEmail: self.senderEmail, Obj: temp)
                self.viewModel.writeObjectLocally(temp)
            }
        }
        AddPopUp.addAction(PopAction)
        present(AddPopUp, animated: true)
    }
}

//MARK: - table view delegate
extension MSChecklistVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if var checklists {
            viewModel.ModifyFireBaseData(forEmail: senderEmail, forTitle: checklists[indexPath.row].CheckListTitle, newCheck: checklists[indexPath.row].Check)
            viewModel.updateLocally(atIndex: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let detachedObj = RealmHelper.DetachedCopy(of: checklists![indexPath.row]) else {
            print("Couldnt detached your object")
            return nil
        }
        
        let DeleteButton =  UITableViewRowAction(style: .default, title: "Delete") { [weak self] (_, indexpath) in
            guard let self else {return}

            self.viewModel.ModifyFireBaseData(forEmail: detachedObj.CheckListSender, forTitle: detachedObj.CheckListTitle, toDel : true)
            self.viewModel.deleteObjectLocally(atIndex: indexpath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        DeleteButton.backgroundColor = .systemRed
        
        let EditButton = UITableViewRowAction(style: .default, title: "Edit") {[weak self] (rowaction, indexpath) in
            guard let self else {return}
            self.editorView.textfieldMetaDataAtIndex(index: indexpath.row, withText: self.checklists![indexpath.row].CheckListTitle)
            self.editorView.modalPresentationStyle = .overFullScreen
            self.editorView.modalTransitionStyle = .crossDissolve
            self.present(self.editorView, animated: true, completion: nil)
        }
        
        EditButton.backgroundColor = .systemGreen
        
        return [DeleteButton,EditButton]
    }
    
}
extension MSChecklistVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklists?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewIdentifiers.checklistID, for: indexPath) as! MSChecklistCell
        cell.accessoryType = (checklists?[indexPath.row].Check)! ? .checkmark : .none
        cell.textLabel?.text = checklists?[indexPath.row].CheckListTitle
        return cell
    }
}
