//
//  TodoItem.swift
//  Todoey
//
//  Created by Warren Buckley on 2018-01-07.
//  Copyright © 2018 Warren Buckley. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem: Object {
    @objc dynamic var task : String = String()
    @objc dynamic var completed : Bool = false
    @objc dynamic var dateCreated : Date = Date()
    var category = LinkingObjects(fromType: Category.self, property: "todoItems")
}
