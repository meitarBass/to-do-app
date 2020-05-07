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
    
    func changeMark() {
        if let state = task?.state {
            switch state {
            case .Empty:
                self.task!.state = .V
                checkmarkImage.image = UIImage(named: "V")
            case .V:
                self.task!.state = .X
                checkmarkImage.image = UIImage(named: "X")
            case .X:
                self.task!.state = .Empty
                checkmarkImage.image = UIImage(named: "Empty")
            }
        }
    }
}


