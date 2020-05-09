//
//  toDoCell.swift
//  to-do-app
//
//  Created by Meitar Basson on 05/05/2020.
//  Copyright © 2020 Meitar Basson. All rights reserved.
//

import UIKit

class toDoCell: UITableViewCell {

    @IBOutlet weak var checkmarkImage: UIImageView!
    @IBOutlet weak var taskLabel: UILabel!
    
    var task: Task?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func changeMark(state: TaskState) -> TaskState {
        switch state {
        case .Empty:
            checkmarkImage.image = UIImage(named: "V")
            return .V
        case .V:
            checkmarkImage.image = UIImage(named: "X")
            return .X
        case .X:
            checkmarkImage.image = UIImage(named: "Empty")
            return .Empty
        }
    }
}


