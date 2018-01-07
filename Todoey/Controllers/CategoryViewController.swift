//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Warren Buckley on 2018-01-06.
//  Copyright © 2018 Warren Buckley. All rights reserved.
//

import UIKit
import CoreData     

class CategoryViewController: UITableViewController {

    let cellID = "CategoryCell"
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext
    
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
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTodoItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? TodoListViewController else { return }
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categories[indexPath.row]
        }
    }
    
    fileprivate func fetchCategories() {
        do {
            categories = try context.fetch(Category.fetchRequest())
        }
        catch {
            print("Failed to fetch categories. \(error)")
        }
        tableView.reloadData()
    }
    
    fileprivate func saveCategories() {
        do {
            try context.save()
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
            let category = Category(context: self.context)
            category.name = alertTextField.text
            self.categories.append(category)
            self.saveCategories()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}











