//
//  ViewController.swift
//  to-do-app
//
//  Created by Meitar Basson on 05/05/2020.
//  Copyright © 2020 Meitar Basson. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    // MARK: Variables
    
    var destinationType: ToDoType?

    // MARK: View loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ToDoVC {
            vc.destinationType = destinationType
        }
    }
    
    // MARK: IBActions
    
    @IBAction func categoryTapped(_ sender: UIButton) {
        destinationType = ToDoType(rawValue: sender.tag)
        performSegue(withIdentifier: "toToDoVC", sender: self)
    }
    
}


// MARK: Enum

enum ToDoType : Int {
    case daily = 1
    case monthly
    case halfYear
    case yearly
}

