//
//  Tasks.swift
//  to-do-app
//
//  Created by Meitar Basson on 06/05/2020.
//  Copyright © 2020 Meitar Basson. All rights reserved.
//

import Foundation

struct Task {
    
    var state: TaskState = .Empty
    var taskTitle: String
    
}

enum TaskState {
    case Empty
    case V
    case X
}
