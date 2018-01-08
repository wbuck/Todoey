//
//  Category.swift
//  Todoey
//
//  Created by Warren Buckley on 2018-01-07.
//  Copyright © 2018 Warren Buckley. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = String()
    let todoItems = List<TodoItem>()
}
