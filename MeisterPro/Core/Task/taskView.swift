//
//  MSTasks.swift
//  MeisterPro
//
//  Created by Apple Macbook on 15/02/2021.
//

import UIKit
import SnapKit
import RealmSwift


class MSTasks: basicVC {
    
    var Tasks : Results<MyTask>? {
        didSet {
            taskTableView.reloadData()
        }
    }
    
    lazy private var TFOverlay = TFeditorVC()
    private var  taskTableView =  toDoTV()
    private let viewModel = taskViewModel()
    
    private var senderEmail : String  = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        senderEmail = viewModel.fetchEmailForCurrentSession()
        
        checkCache()
        checkNeedForCloud()
        settingViews()
    }
    
//MARK: - database action
    
    private func checkCache(){
        Tasks = viewModel.loadData(byEmail: senderEmail)
    }
    
    private func writeDataAndSync(_ comingTask : MyTask){
        Tasks = viewModel.writeTaskToLocal(comingTask)
    }
    
    private func checkNeedForCloud(){
        if Tasks?.count == 0 {
            viewModel.loadFromCloud(forEmail: senderEmail) {[weak self] returnedTasks in
                guard let self else {return}
                self.Tasks = returnedTasks
            }
        }
    }
    
    //MARK: - setting views
    
    private func settingViews(){
        let AddButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItems = [AddButton]
        
        TFOverlay.delegate = self
        
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.register(MSTaskCell.self, forCellReuseIdentifier: Contants.TaskReuseID)
        view.addSubview(taskTableView)
        
        taskTableView.snp.makeConstraints { para in
            para.leading.trailing.top.bottom.equalTo(view)
        }
    }
}
//MARK: - protocol delegate

extension MSTasks : textValuePasser {
    func didupdatevalue(string: String, index: Int) {
        guard let previousTitle = Tasks?[index].TaskTitle else { return }
        
        viewModel.GetFireBaseID(byName: previousTitle, forEmail: senderEmail) {[weak self] (returnedID) in
            guard let self else {return}
            if returnedID.count > 0 {
                self.viewModel.updateTaskToCloud(withID: returnedID, updateTask: string)
            }else {
                print("couldnt find your doc ")
            }
        }
        Tasks  = viewModel.updateTaskAndSync(lhs: Tasks, atIndex: index, withText: string)
    }
}

//MARK: - trigger

extension MSTasks {
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
                
                let temp = self.viewModel.formTaskObj(withName: text,
                                                      forEmail: self.senderEmail)
                self.viewModel.uploadTaskToCloud(temp)
                self.writeDataAndSync(temp)
            }
        }
        AddPop.addAction(PopAction)
        present(AddPop, animated: true)
    }
}

//MARK: - Table view data source delegate

extension MSTasks : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Tasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskTableView.dequeueReusableCell(withIdentifier: Contants.TaskReuseID, for: indexPath) as! MSTaskCell
        cell.textLabel?.text = Tasks?[indexPath.row].TaskTitle
        return cell
    }
}

extension MSTasks : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let detachedObjc = RealmHelper.DetachedCopy(of: Tasks![indexPath.row])else {
            print("couldnt detached your object ")
            return nil
        }
        
        let DeleteButton = UITableViewRowAction(style: .default, title: "Delete") { [weak self] (_, indexpath) in
            guard let self else {return}
            self.viewModel.GetFireBaseID(byName: detachedObjc.TaskTitle,
                                         forEmail: detachedObjc.TaskSender) { (returnedID) in
                if returnedID.count > 0 {
                    self.viewModel.DelFromFireBase(id: returnedID)
                }else {
                    print("object to be delete is not found")
                }
            }
            
            self.viewModel.deleteObjectlocally(fromArr: self.Tasks, atIndex: indexpath.row)
            tableView.deleteRows(at: [indexpath], with: .fade)
        }
        
        DeleteButton.backgroundColor = .systemRed
        
        let EditButton =  UITableViewRowAction(style: .default, title: "Edit") { [weak self] (_, indexpath) in
            guard let self else {return}
            self.TFOverlay.textfieldMetaData(with: indexpath.row, withtext: self.Tasks![indexpath.row].TaskTitle)
            self.TFOverlay.modalPresentationStyle = .overFullScreen
            self.TFOverlay.modalTransitionStyle = .crossDissolve
            self.present(self.TFOverlay, animated: true)
        }
        EditButton.backgroundColor = .systemGreen
        
        return [DeleteButton,EditButton]
    }
    
}
