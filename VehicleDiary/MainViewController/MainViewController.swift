//
//  ViewController.swift
//  VehicleDiary
//
//  Created by Vachko on 14.10.20.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addVehicleBtn: UIButton!
    
    var controller: NSFetchedResultsController<Car>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground()
        downloadVehicles()
        attemptFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectVehicle",
           let destination = segue.destination as? SelectVehicleViewController {
            destination.brands = brands;
            destination.brandsAndModels = brandsAndModels
            destination.delegate = self
        }
        if segue.identifier == "showItems",
           let destination = segue.destination as? ItemsViewController {
            if let cell = sender as? VehicleCell, let indexPath = tableView.indexPath(for: cell) {
                let car = controller.object(at: indexPath as IndexPath)
                destination.title = "\(car.brand!) \(car.model!)"
                destination.selectedCar = car
                
            }
        }
    }
    
    func configureCell(cell: VehicleCell, indexPath: NSIndexPath) {
        
        let car = controller.object(at: indexPath as IndexPath)
        cell.configureCell(car: car)
        
    }
    
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        let titleSort = NSSortDescriptor(key: "brand", ascending: true)
        fetchRequest.sortDescriptors = [titleSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        self.controller = controller
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleCell", for: indexPath) as? VehicleCell else {
            return UITableViewCell()
        }
        
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        return cell
    }
    
}

extension MainViewController: NSFetchedResultsControllerDelegate {
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
                let cell = tableView.cellForRow(at: indexPath) as! VehicleCell
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

extension MainViewController: UITableViewDelegate {
    
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
        
        delete.backgroundColor = UIColor.red
        
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = true
        
        return config
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 0, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = NSLocalizedString("Your cars:", comment: "List with registered cars")
        label.font = UIFont.init(name: "Nasalization", size: 20.0)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        
        headerView.addSubview(label)
        
        return headerView
    }
}

extension MainViewController: SelectVehicleViewControllerDelegate {
    func selectVehicleViewControllerFinishAdding(_ controller: SelectVehicleViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func selectVehicleViewControllerDidCancel(_ controller: SelectVehicleViewController) {
        navigationController?.popViewController(animated: true)
    }
    
}
