//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Warren Buckley on 2018-01-06.
//  Copyright © 2018 Warren Buckley. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let cellID = "CategoryCell"
    var categories : Results<Category>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: - Table source delegate methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTodoItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? TodoListViewController else { return }
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categories?[indexPath.row]
        }
    }
    
    fileprivate func fetchCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    fileprivate func save(category : Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Failed to save categoriers. \(error)")
        }
        tableView.reloadData()
    }

    
    @IBAction func addCategoryButtonClicked(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add Category", message: String(), preferredStyle: .alert)
        var alertTextField = UITextField()
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Create new category"
            alertTextField = textfield
        }
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            guard !alertTextField.text!.isEmpty else { return }
            let category = Category()
            category.name = alertTextField.text!
            self.save(category: category)
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}











