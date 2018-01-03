//
//  TodoItem.swift
//  Todoey
//
//  Created by Warren Buckley on 2018-01-01.
//  Copyright © 2018 Warren Buckley. All rights reserved.
//

import Foundation

class TodoItem : Codable {
    
    var task : String
    var completed : Bool
    
    init(task: String, completed: Bool) {
        self.task = task
        self.completed = completed
    }
    
}
