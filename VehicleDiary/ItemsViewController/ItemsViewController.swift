//
//  ItemsViewController.swift
//  VehicleDiary
//
//  Created by Vachko on 18.10.20.
//

import UIKit
import CoreData

class ItemsViewController: UIViewController {
    
    // MARK: - Enumeration
    enum TableView {
        enum CellIdentifiers: String {
            case CustomItemCell = "CustomItemCell"
            case CustomNoItemsCell = "CustomNoItemsCell"
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let customItemCellNib = UINib(nibName: TableView.CellIdentifiers.CustomItemCell.rawValue, bundle: nil)
            tableView.register(customItemCellNib, forCellReuseIdentifier: TableView.CellIdentifiers.CustomItemCell.rawValue)
            
            let customNoItemsCellNib = UINib(nibName: TableView.CellIdentifiers.CustomNoItemsCell.rawValue, bundle: nil)
            tableView.register(customNoItemsCellNib, forCellReuseIdentifier: TableView.CellIdentifiers.CustomNoItemsCell.rawValue)
        }
    }
    
    // MARK: - Properties
    var selectedCar: Car?
    var hasItems = Bool()
    var controller: NSFetchedResultsController<Item>!
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor.clear
        setBackground()
        attemptFetch()
        
    }
    
    // MARK: - Actions
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        attemptFetch()
        tableView.reloadData()
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        
    }
    
    // MARK: - Helper methods
    /// Fetch saved entities from CoreData stack
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format:"car = %@", selectedCar!)
        
        
        if segment.selectedSegmentIndex == 0 {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "type", ascending: true)]
        } else if segment.selectedSegmentIndex == 1 {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        } else if segment.selectedSegmentIndex == 2 {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "price", ascending: true)]
        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        
        self.controller = controller
        
        do {
            try controller.performFetch()
            let itemsCount = try context.count(for: fetchRequest)
            if itemsCount != 0 {
                hasItems = true
            } else {
                hasItems = false
            }
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    func configureCell(cell: ItemCell, indexPath: NSIndexPath) {
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem", let destination = segue.destination as? AddItemTableViewController {
            destination.selectedCar = selectedCar
            destination.delegate = self
            hasItems = true
            tableView.reloadData()
        } else if segue.identifier == "EditItem", let destination = segue.destination as? AddItemTableViewController {
            if let cell = sender as? ItemCell, let indexPath = tableView.indexPath(for: cell) {
                let item = controller.object(at: indexPath as IndexPath)
                destination.itemToEdit = item
                destination.selectedCar = selectedCar
                destination.delegate = self
            }
        } else if segue.identifier == "showImage", let destination = segue.destination as? ShowImageViewController {
            if let indexPath = sender as? IndexPath {
                let item = controller.object(at: indexPath)
                destination.item = item
            }
        }
    }
}

// MARK: - Extensions
extension ItemsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            let alertController = UIAlertController(title: "Attention!", message: "Are you sure you want to delete this entry?", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction) in
                let car = self.controller.object(at: indexPath as IndexPath)
                context.delete(car)
                
                do {
                    try context.save()
                } catch {
                    print("core data save error : \(error)")
                }
            }
            
            let action2 = UIAlertAction(title: "No", style: .cancel) { (action:UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            }
            
            alertController.addAction(action1)
            alertController.addAction(action2)
            self.present(alertController, animated: true, completion: nil)
        }
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            let alertController = UIAlertController(title: "Attention!", message: "Are you sure you want to change this entry?", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction) in
                let cell = tableView.cellForRow(at: indexPath)
                self.performSegue(withIdentifier: "EditItem", sender: cell)
            }
            
            let action2 = UIAlertAction(title: "No", style: .cancel) { (action:UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            }
            
            alertController.addAction(action1)
            alertController.addAction(action2)
            self.present(alertController, animated: true, completion: nil)
        }
        
        delete.backgroundColor = UIColor.red
        edit.backgroundColor = UIColor.blue
        
        let config = UISwipeActionsConfiguration(actions: [delete, edit])
        config.performsFirstActionWithFullSwipe = true
        
        return config
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showImage", sender: indexPath)
    }
    
}

extension ItemsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hasItems {
            if let sections = controller.sections {
                
                let sectionInfo = sections[section]
                return sectionInfo.numberOfObjects
            }
        } else {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if hasItems == false {
            let cellOne = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.CustomNoItemsCell.rawValue, for: indexPath)
            return cellOne
        } else {
            let cellTwo = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.CustomItemCell.rawValue, for: indexPath) as! ItemCell
            configureCell(cell: cellTwo, indexPath: indexPath as NSIndexPath)
            return cellTwo
        }
    }
    
    
}

extension ItemsViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
        
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        @unknown default:
            fatalError()
        }
    }
}

extension ItemsViewController: AddItemTableViewControllerDelegate {
    func addItemTableViewControllerDidCancel(_ controller: AddItemTableViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addItemTableViewControllerFinishAdding(_ controller: AddItemTableViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addItemTableViewControllerFinishEditing(_ controller: AddItemTableViewController) {
        navigationController?.popViewController(animated: true)
    }
}
