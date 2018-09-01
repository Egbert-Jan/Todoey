//
//  ViewController.swift
//  Todoey
//
//  Created by Egbert-Jan Terpstra on 21/08/2018.
//  Copyright © 2018 Egbert-Jan Terpstra. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewControler: UITableViewController {

    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//        print("current date: \(Date.init())")
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    
    
    
    // MARK: - tableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let todoItem = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    todoItem.done = !todoItem.done
                }
            } catch {
                print("Error met het updaten: \(error)")
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    

    
    // MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in

            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("error met het toevoegen van de item: \(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Your new item"
            textField = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    
//    LOAD ITEMS
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}



extension TodoListViewControler: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text!.count != 0 {
        
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
            
            tableView.reloadData()
        }
    }
    
    

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.count != 0 {
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
            tableView.reloadData()
        } else{
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

    
    
}



























//
//func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//    if searchText.count != 0 {
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        // DIT WERKT OOK <-- zelf bedacht:
//        //            request.predicate = NSPredicate(format: "parentCategory.name MATCHES %@ AND title CONTAINS[cd] %@", argumentArray: [selectedCategory!.name!, searchBar.text!])
//
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        request.sortDescriptors = [sortDescriptor]
//
//
//        loadItems(with: request, predicate: predicate)
//    } else{
//
//        DispatchQueue.main.async {
//            searchBar.resignFirstResponder()
//        }
//
//        // DIT WERKT OOK <-- zelf bedacht:
//        //            let request: NSFetchRequest<Item> = Item.fetchRequest()
//        //            let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        //            request.predicate = predicate
//        loadItems()
//    }
//
//}
