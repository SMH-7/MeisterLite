//
//  MSProjects.swift
//  MeisterPro
//
//  Created by Apple Macbook on 15/02/2021.
//
import UIKit
import SnapKit
import RealmSwift


class MSProjects : basicVC {
    
    private var Projects : Results<MyProject>?
    
    lazy private var projectTableView = toDoTV()
    lazy private var TFOverlay =  TFeditorVC()
    
    private let viewModel = projectViewModel()
    private var senderEmail : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingBinder()
        viewModel.fetchEmail()
        
        checkCache()
        checkNeedForCloud()
        settingViews()
    }
    
    
    //MARK: - sync db
    private func settingBinder() {
        viewModel.email.bind {[weak self] comingMail in
            guard let self else {return}
            self.senderEmail = comingMail
        }
        viewModel.projectList.bind { [weak self] updatedList in
            guard let self else {return}
            self.Projects = updatedList
            self.projectTableView.reloadData()
        }
        
        viewModel.error.bind { err in
            print(err)
        }
    }
    
    private func checkCache(){
        viewModel.loadDatalocally(forEmail: senderEmail)
    }
    
    private func checkNeedForCloud(){
        if Projects?.count == 0 {
            viewModel.LoadDataFirebase(forEmail: senderEmail)
        }
    }

    //MARK: - setting views
    
    private func settingViews(){
        let AddButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItems =  [AddButton]
        
        TFOverlay.delegate = self
        
        projectTableView.dataSource = self
        projectTableView.delegate = self
        projectTableView.register(UINib(nibName: Contants.ProjectNib,
                                        bundle: nil),
                                  forCellReuseIdentifier: Contants.ProjectResueID)
        view.addSubview(projectTableView)
        
        projectTableView.snp.makeConstraints { para in
            para.trailing.leading.bottom.top.equalTo(view)
        }
    }
}


//MARK: - update delegate

extension MSProjects : textValuePasser {
    func didupdatevalue(string: String, index: Int) {
        guard let previousText = Projects?[index].ProjectTitle else { return }
        viewModel.ModifyDataFireBase(forEmail: senderEmail, forTitle: previousText, newTitle: string)
        viewModel.updateLocally(title: string, atIndex: index, arr: Projects)
    }
}

//MARK: - triggers

extension MSProjects {
    @objc private func addTapped(){
        var localTextField = UITextField()
        let AddPop = UIAlertController(title: "Project", message: "Add TODO Project ", preferredStyle: .alert)
        AddPop.addTextField { (textfield) in
            textfield.placeholder = "Enter Project Name..."
            localTextField = textfield
        }
        let PopAction = UIAlertAction(title: "Done", style: .default) {[weak self] (action) in
            guard let self else {return}
            if let text = localTextField.text {
                let temp = MyProject()
                temp.ProjectSender = self.senderEmail
                temp.ProjectTitle = text
                
                self.viewModel.UploadDataFirebase(forEmail: self.senderEmail, Obj: temp)
                self.viewModel.writeDatalocally(temp)
            }
        }
        AddPop.addAction(PopAction)
        present(AddPop, animated: true)
        
    }
}


//MARK: - table delegate

extension MSProjects : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        guard let detachedObj = RealmHelper.DetachedCopy(of: Projects![indexPath.row]) else {
            print("couldnt detached your object")
            return nil
        }
        let DeleteButton = UITableViewRowAction(style: .default, title: "Delete") { [weak self] (_, indexpath) in
            guard let self else {return}
            self.viewModel.ModifyDataFireBase(forEmail: self.senderEmail,
                                              forTitle: detachedObj.ProjectTitle,
                                              toDel: true)
            self.viewModel.deletelocally(fromArr: self.Projects, atIndex: indexpath.row)
            tableView.deleteRows(at: [indexpath], with: .fade)
        }
        
        DeleteButton.backgroundColor = .systemRed
        
        
        let EditButton = UITableViewRowAction(style: .default, title: "Edit") { [weak self] (_, indexpath) in
            guard let self else {return}
            self.TFOverlay.textfieldMetaData(
                with: indexpath.row,
                withtext: self.Projects![indexpath.row].ProjectTitle)
            self.TFOverlay.modalPresentationStyle = .overFullScreen
            self.TFOverlay.modalTransitionStyle = .crossDissolve
            self.present(self.TFOverlay, animated: true)
        }
        EditButton.backgroundColor = .systemGreen
        
        return [DeleteButton,EditButton]
    }
    
}

extension MSProjects : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Projects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = projectTableView.dequeueReusableCell(withIdentifier: Contants.ProjectResueID, for: indexPath) as! MSProjectCell
        if let cellImage = UIImage(systemName: "pencil.and.outline") ,
           let text = Projects?[indexPath.row].ProjectTitle {
            cell.SetCell(withimage: cellImage, withtext: text)
        }
        return cell
    }
}
