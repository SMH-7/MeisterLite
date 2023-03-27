//
//  MSTasks.swift
//  MeisterPro
//
//  Created by Apple Macbook on 15/02/2021.
//

import UIKit
import SnapKit
import RealmSwift


class MSTaskVC: BaseVC {
    
    
    lazy private var editorView = EditContainerVC()
    private var  tableView =  BaseTV()
    private let viewModel = MSTaskViewModel()
    
    private var tasks : Results<Task>?
    private var senderEmail : String  = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBinders()
        viewModel.fetchEmail()
        fetchData()
        checkNeedForCloud()
        setViews()
    }
    
//MARK: - database action
    
    private func setBinders() {
        viewModel.email.bind { [weak self] comingMail in
            guard let self else { return }
            self.senderEmail = comingMail
        }
        viewModel.tasks.bind { [weak self] updateTasks in
            guard let self else {return}
            self.tasks = updateTasks
            self.tableView.reloadData()
        }
        viewModel.error.bind { newErr in
            print(newErr)
        }
    }
    
    private func fetchData(){
        viewModel.fetchObjectsLocally(forEmail: senderEmail)
    }
    
    private func checkNeedForCloud(){
        if tasks?.count == 0 {
            viewModel.fetchDataFromFirebase(forEmail: senderEmail)
        }
    }
    
    //MARK: - setting views
    
    private func setViews(){
        let AddButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItems = [AddButton]
        editorView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MSTaskCell.self, forCellReuseIdentifier: TableViewIdentifiers.taskID)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { para in
            para.leading.trailing.top.bottom.equalTo(view)
        }
    }
}
//MARK: - protocol delegate

extension MSTaskVC : textValuePasser {
    func didupdatevalue(string: String, index: Int) {
        guard let previousTitle = tasks?[index].TaskTitle else { return }
        viewModel.ModifyFireBaseData(forEmail: senderEmail, forTitle: previousTitle, newTitle: string)
        viewModel.updateObjectLocally(atIndex: index, title: string)
    }
}

//MARK: - trigger

extension MSTaskVC {
    @objc private func addTapped(){
        var localTextField = UITextField()
        let AddPop = UIAlertController(title: "Task", message: "Add TODO Task", preferredStyle: .alert)
        AddPop.addTextField { (textfield) in
            textfield.placeholder = "Enter Task name..."
            localTextField = textfield
        }
        let PopAction = UIAlertAction(title: "Done", style: .default) {[weak self] (action) in
            guard let self else {return}
            if let text = localTextField.text {
                let temp = Task()
                temp.TaskSender = self.senderEmail
                temp.TaskTitle = text
                
                self.viewModel.uploadDataToFirebase(forEmail: self.senderEmail, Obj: temp)
                self.viewModel.writeObjectLocally(temp)
            }
        }
        AddPop.addAction(PopAction)
        present(AddPop, animated: true)
    }
}

//MARK: - Table view data source delegate

extension MSTaskVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewIdentifiers.taskID, for: indexPath) as! MSTaskCell
        cell.textLabel?.text = tasks?[indexPath.row].TaskTitle
        return cell
    }
}

extension MSTaskVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let detachedObjc = RealmHelper.DetachedCopy(of: tasks![indexPath.row])else {
            print("couldnt detached your object ")
            return nil
        }
        
        let DeleteButton = UITableViewRowAction(style: .default, title: "Delete") { [weak self] (_, indexpath) in
            guard let self else {return}
            self.viewModel.ModifyFireBaseData(forEmail: detachedObjc.TaskSender, forTitle: detachedObjc.TaskTitle, toDel: true)
            self.viewModel.deleteObjectLocally(atIndex: indexpath.row)
            tableView.deleteRows(at: [indexpath], with: .fade)
        }
        
        DeleteButton.backgroundColor = .systemRed
        
        let EditButton =  UITableViewRowAction(style: .default, title: "Edit") { [weak self] (_, indexpath) in
            guard let self else {return}
            self.editorView.textfieldMetaData(with: indexpath.row, withtext: self.tasks![indexpath.row].TaskTitle)
            self.editorView.modalPresentationStyle = .overFullScreen
            self.editorView.modalTransitionStyle = .crossDissolve
            self.present(self.editorView, animated: true)
        }
        EditButton.backgroundColor = .systemGreen
        
        return [DeleteButton,EditButton]
    }
    
}
