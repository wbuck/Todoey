//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Warren Buckley on 2018-01-01.
//  Copyright © 2018 Warren Buckley. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    let cellID = "TodoItemCell"
    var todoItems : Results<TodoItem>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet {
            fetchTodoItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.task
            cell.accessoryType = item.completed ? .checkmark : .none
        }
        else {
            cell.textLabel?.text = "No Tasks"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let todoItem = todoItems?[indexPath.row] else { return }
        do {
            try realm.write {
                todoItem.completed = !todoItem.completed
            }
        }
        catch {
            print("Error updating todo item. \(error)")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
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
            guard let currentCategory = self.selectedCategory else { return }
            do {
                try self.realm.write {
                    let todoItem = TodoItem()
                    todoItem.task = alertTextField.text!
                    todoItem.completed = false
                    currentCategory.todoItems.append(todoItem)
                }
            }
            catch {
                print("Failed to save data to DB. \((error as NSError).userInfo.description)")
            }
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    fileprivate func fetchTodoItems() {
        guard let currentCategory = self.selectedCategory else { return }
        todoItems = currentCategory.todoItems.sorted(byKeyPath: "task", ascending: true)
        tableView.reloadData()
    }
}

// MARK: - Search bar methods

extension TodoListViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.isEmpty else { return }
        fetchTodoItems()
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard !searchBar.text!.isEmpty else { return }
        todoItems = todoItems?.filter("task CONTAINS[cd] %@", searchBar.text!)
            .sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
}


