//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Warren Buckley on 2018-01-01.
//  Copyright © 2018 Warren Buckley. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var todoItems = [TodoItem]()
    let cellID = "TodoItemCell"
    var selectedCategory : Category? {
        didSet {
            fetchTodoItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext
    
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
        todoItems[indexPath.row].completed = !todoItems[indexPath.row].completed
        saveTodoItems()
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
            let item = TodoItem(context: self.context)
            item.task = alertTextField.text!
            item.completed = false
            item.category = self.selectedCategory!
            self.todoItems.append(item)
            self.saveTodoItems()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    fileprivate func fetchTodoItems(with request : NSFetchRequest<TodoItem> = TodoItem.fetchRequest()) {
        let categoryPredicate = NSPredicate(format: "category.name MATCHES %@", selectedCategory!.name!)
        if let predicate = request.predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, categoryPredicate])
        }
        else {
            request.predicate = categoryPredicate
        }
        
        do {
            todoItems = try context.fetch(request)
        }
        catch {
            print("Error fetching data. \(error)")
        }
        tableView.reloadData()
    }
    
    
    fileprivate func saveTodoItems() {
        do {
            try context.save()
        }
        catch {
            print("Failed to save data to DB. \((error as NSError).userInfo.description)")
        }
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
        let request : NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        request.predicate = NSPredicate(format: "task CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "task", ascending: true)]
        fetchTodoItems(with: request)
    }
}

