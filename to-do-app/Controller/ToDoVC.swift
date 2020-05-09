//
//  ToDoVC.swift
//  to-do-app
//
//  Created by Meitar Basson on 05/05/2020.
//  Copyright © 2020 Meitar Basson. All rights reserved.
//

import UIKit
import CoreData

class ToDoVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    
    @IBOutlet weak var checklistTable: UITableView!
    
    // MARK: Variables
    
    var destinationType : ToDoType?
    
    // MARK: Data handling
    
    var list: [NSManagedObject] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    // MARK: View loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checklistTable.dataSource = self
        checklistTable.delegate = self
        
        checklistTable.estimatedRowHeight = 0
        checklistTable.rowHeight = UITableView.automaticDimension
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))
        
        setTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getTasks()
        for task in list {
//            print(task.value(forKey: "taskTitle")!)
        }
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
                cell.task = (list[indexPath.row] as! Task)
                cell.taskLabel.text = cell.task?.taskTitle
                if let img = cell.task?.state {
                    cell.checkmarkImage.image = UIImage(named: "\(TaskState(rawValue: img)!)")
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = checklistTable.cellForRow(at: indexPath) as? toDoCell {
            if let task = cell.task {
                if let state = TaskState(rawValue: task.state) {
                    list[indexPath.row].setValue(cell.changeMark(state: state).rawValue, forKey: "state")
                    // need to save to db
                    save()
                }
            }
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(list[indexPath.row])
            list.remove(at: indexPath.row)
            checklistTable.deleteRows(at: [indexPath], with: .fade)
            save()
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
            print(text)
            // Save new object
            self.saveNewTask(title: text, state: .Empty)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let actions = [addAction, cancelAction]

        for action in actions {
            alert.addAction(action)
        }

        present(alert, animated: true)
    }
    
    func saveNewTask(title: String, state: TaskState) {
       
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)!
        let task = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 3
        task.setValue(title, forKey: "taskTitle")
        task.setValue(state.rawValue, forKey: "state")
        
        // 4
        save()
    
        // 5 Update Table
        list.insert(task, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.checklistTable.insertRows(at: [indexPath], with: .automatic)
          if let cell = self.checklistTable.cellForRow(at: indexPath) as? toDoCell {
              cell.checkmarkImage.image = UIImage(named: "Empty")
        }
    }
    
    func getTasks() {
        //1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        //3
        do {
          list = try managedContext.fetch(fetchRequest)
          list.reverse()
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func save() {
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}

enum TaskState: Int32 {
    case Empty
    case V
    case X
}
