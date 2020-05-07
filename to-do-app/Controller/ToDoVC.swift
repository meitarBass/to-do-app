//
//  ToDoVC.swift
//  to-do-app
//
//  Created by Meitar Basson on 05/05/2020.
//  Copyright © 2020 Meitar Basson. All rights reserved.
//

import UIKit

class ToDoVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    
    @IBOutlet weak var checklistTable: UITableView!
    
    // MARK: Variables
    
    var destinationType : ToDoType?
    var list = [Task]()

    // MARK: View loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checklistTable.dataSource = self
        checklistTable.delegate = self
        
        checklistTable.estimatedRowHeight = 0
        checklistTable.rowHeight = UITableView.automaticDimension
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))
        
        title = "Hello"
        setTitle()
        
    }
    
    func setTitle() {
        let date = Date()
        let format = DateFormatter()
        switch destinationType {
        case .daily:
            format.dateFormat = "dd-MM-yyyy"
            let formattedDate = format.string(from: date)
            title =  "The end of \(formattedDate)"
        case .monthly:
            format.dateFormat = "LLLL yyyy"
            let formattedDate = format.string(from: date)
            title = "The end of \(formattedDate)"
        case .yearly:
            format.dateFormat = "yyyy"
            let formattedDate = format.string(from: date)
            title = "The end of \(formattedDate)"
        case .halfYear:
            format.dateFormat = "yyyy"
            let formattedDate = format.string(from: date)
            title = "1/2 Half of \(formattedDate)"
        case .none:
            debugPrint("something weird")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = checklistTable.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as? toDoCell {
            if list.count > 0 {
                cell.task = list[indexPath.row]
                cell.taskLabel.text = cell.task?.taskTitle
                if let img = cell.task?.state {
                    cell.checkmarkImage.image = UIImage(named: "\(img)")
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = checklistTable.cellForRow(at: indexPath) as? toDoCell {
            cell.changeMark()
        }
    }
    
    // Control row height
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
           if indexPath.section == 0 {
             return UITableView.automaticDimension
         } else {
             return 40
         }
    }
    
    // Add new task function
    
    @objc func addNewTask() {
        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Please enter your task"
        }
        
        let addAction = UIAlertAction(title: "Done", style: .default, handler: { _ in
            guard let text = alert.textFields![0].text else { return }
            let task = Task(state: .Empty, taskTitle: text)
            let indexPath = IndexPath(row: 0, section: 0)
            self.list.insert(task, at: 0)
            self.checklistTable.insertRows(at: [indexPath], with: .automatic)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let actions = [addAction, cancelAction]

        for action in actions {
            alert.addAction(action)
        }

        present(alert, animated: true)
    }

}
