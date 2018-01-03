//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Warren Buckley on 2018-01-01.
//  Copyright © 2018 Warren Buckley. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var todoItems = [TodoItem]()
    let cellID = "TodoItemCell"
    
    let dataFilePath =
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first?.appendingPathComponent("TodoItems.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = todoItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = item.task
        cell.accessoryType = item.completed ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = todoItems[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
        }
        else {
            cell?.accessoryType = .checkmark
        }
        item.completed = cell?.accessoryType == .checkmark
        writeTodoItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: String(), preferredStyle: .alert)
        
        var alertTextField = UITextField()
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Create new item"
            alertTextField = textfield
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            guard !alertTextField.text!.isEmpty else { return }
            self.todoItems.append(TodoItem(task: alertTextField.text!, completed: false))
            self.writeTodoItems()
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func readTodoItems() {
        let decoder = PropertyListDecoder()
        do {
            
        }
        catch {
            
        }
    }
    
    // Encode the todo list so that it can be persisted
    // in plist.
    fileprivate func writeTodoItems() {
        let encoder = PropertyListEncoder()
        do {
            let encoded = try encoder.encode(todoItems)
            try encoded.write(to: dataFilePath!)
        }
        catch {
            print("Error while saving data. \(error)")
        }
    }
}

