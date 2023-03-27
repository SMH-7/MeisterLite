//
//  MSProjects.swift
//  MeisterPro
//
//  Created by Apple Macbook on 15/02/2021.
//
import UIKit
import SnapKit
import RealmSwift


class MSProjectVC : BaseVC {
    
    private var projects : Results<Project>?
    private var senderEmail : String = ""

    private let viewModel = MSProjectViewModel()

    lazy private var tableView = BaseTV()
    lazy private var editorView =  EditContainerVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBinder()
        viewModel.fetchEmail()
        fetchData()
        checkNeedForCloud()
        setViews()
    }
    
    
    //MARK: - sync db
    private func setBinder() {
        viewModel.email.bind {[weak self] comingMail in
            guard let self else {return}
            self.senderEmail = comingMail
        }
        viewModel.projectList.bind { [weak self] updatedList in
            guard let self else {return}
            self.projects = updatedList
            self.tableView.reloadData()
        }
        
        viewModel.error.bind { err in
            print(err)
        }
    }
    
    private func fetchData(){
        viewModel.fetchObjectsLocally(forEmail: senderEmail)
    }
    
    private func checkNeedForCloud(){
        if projects?.count == 0 {
            viewModel.fetchDataFromFirebase(forEmail: senderEmail)
        }
    }

    //MARK: - setting views
    
    private func setViews(){
        let AddButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItems =  [AddButton]
        
        editorView.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: TableViewIdentifiers.projectCellID,
                                        bundle: nil),
                                  forCellReuseIdentifier: TableViewIdentifiers.projectID)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { para in
            para.top.bottom.leading.trailing.equalTo(view)
        }
    }
}


//MARK: - update delegate

extension MSProjectVC : textValuePasser {
    func didupdatevalue(string: String, index: Int) {
        guard let previousText = projects?[index].ProjectTitle else { return }
        viewModel.ModifyFireBaseData(forEmail: senderEmail, forTitle: previousText, newTitle: string)
        viewModel.updateObjectLocally(atIndex: index, title: string)
    }
}

//MARK: - triggers

extension MSProjectVC {
    @objc private func addTapped(){
        var localTextField = UITextField()
        let AddPop = UIAlertController(title: "Project", message: "Add ToDo Project ", preferredStyle: .alert)
        AddPop.addTextField { (textfield) in
            textfield.placeholder = "Enter Project Name..."
            localTextField = textfield
        }
        let PopAction = UIAlertAction(title: "Done", style: .default) {[weak self] (action) in
            guard let self else {return}
            if let text = localTextField.text {
                let temp = Project()
                temp.ProjectSender = self.senderEmail
                temp.ProjectTitle = text
                self.viewModel.uploadDataToFirebase(forEmail: self.senderEmail, Obj: temp)
                self.viewModel.writeObjectLocally(temp)
            }
        }
        AddPop.addAction(PopAction)
        present(AddPop, animated: true)
        
    }
}


//MARK: - table delegate

extension MSProjectVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let detachedObj = RealmHelper.DetachedCopy(of: projects![indexPath.row]) else { return nil}
        
        let DeleteButton = UITableViewRowAction(style: .default, title: "Delete") { [weak self] (_, indexpath) in
            guard let self else {return}
            self.viewModel.ModifyFireBaseData(forEmail: self.senderEmail,
                                              forTitle: detachedObj.ProjectTitle,
                                              toDel: true)
            self.viewModel.deleteObjectLocally(atIndex: indexpath.row)
            tableView.deleteRows(at: [indexpath], with: .fade)
        }
        
        DeleteButton.backgroundColor = .systemRed
        
        
        let EditButton = UITableViewRowAction(style: .default, title: "Edit") { [weak self] (_, indexpath) in
            guard let self else {return}
            self.editorView.textfieldMetaData(
                with: indexpath.row,
                withtext: self.projects![indexpath.row].ProjectTitle)
            self.editorView.modalPresentationStyle = .overFullScreen
            self.editorView.modalTransitionStyle = .crossDissolve
            self.present(self.editorView, animated: true)
        }
        EditButton.backgroundColor = .systemGreen
        
        return [DeleteButton,EditButton]
    }
    
}

extension MSProjectVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: TableViewIdentifiers.projectID, for: indexPath) as! MSProjectCell
        if let cellImage = UIImage(systemName: "pencil.and.outline") ,
           let text = projects?[indexPath.row].ProjectTitle {
            cell.SetCell(withimage: cellImage, withtext: text)
        }
        return cell
    }
}
