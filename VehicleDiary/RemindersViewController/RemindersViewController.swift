//
//  RemindersViewController.swift
//  VehicleDiary
//
//  Created by Vachko on 20.10.20.
//

import UIKit

class RemindersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataModel = DataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        setBackground()
        dataModel.loadReminders()
        tableView.reloadData()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataModel.loadReminders()
        print(dataModel.reminders)
        dataModel.sortReminders()
        tableView.reloadData()
    }
    
    @IBAction func addBtnTapped(_ sender: UIBarButtonItem) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddReminderViewController, segue.identifier == "addReminder" {
            destination.delegate = self
        }
    }
    
}

extension RemindersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataModel.reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if let recycledCell = tableView.dequeueReusableCell(withIdentifier: "remindCell") {
            cell = recycledCell
            
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "remindCell")
        }
        cell.textLabel?.text = dataModel.reminders[indexPath.row].text
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        cell.detailTextLabel?.text = dateFormatter.string(for: dataModel.reminders[indexPath.row].dueDate)
        return cell
    }
    
}

extension RemindersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            let alertController = UIAlertController(title: "Attention!", message: "Are you sure you want to delete this entry?", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction) in
                
                let reminderID = self.dataModel.reminders[indexPath.row].reminderID
                self.dataModel.reminders.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                
                let center = UNUserNotificationCenter.current()
                center.removePendingNotificationRequests(
                    withIdentifiers: [reminderID])
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
}

extension RemindersViewController: AddReminderViewControllerDelegate {
    func AddReminderViewControllerDidCancel(_ controller: AddReminderViewController) {
    }
    
    func AddReminderViewController(_ controller: AddReminderViewController, didFinishAdding item: Reminder) {
        let newRowIndex = (dataModel.reminders.count)
        dataModel.reminders.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
    }
}
