//
//  AddReminderViewController.swift
//  VehicleDiary
//
//  Created by Vachko on 27.10.20.
//

import UIKit

protocol AddReminderViewControllerDelegate: class {
    func AddReminderViewControllerDidCancel(_ controller: AddReminderViewController)
    func AddReminderViewController(_ controller: AddReminderViewController, didFinishAdding item: Reminder)
}

class AddReminderViewController: UIViewController {
    
    weak var delegate: AddReminderViewControllerDelegate?
    
    let datePicker = UIDatePicker()
    private var dueDate = Date()
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var reminderField: UITextField!
    @IBOutlet weak var dateField: UITextField! {
        didSet {
            dateField.attributedPlaceholder = NSAttributedString(string:"Tap to enter date", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        reminderField.resignFirstResponder()
        
        if reminderField.text != nil && dateField.text != nil {
            
            let reminder = Reminder (reminderField.text ?? "No text", dueDate: dueDate)
            reminder.scheduleNotification()
            delegate?.AddReminderViewController(self, didFinishAdding: reminder)
            
            dismiss(animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Attention!", message: "Must fill all text fields!", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            }
            
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDatePicker()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reminderField.becomeFirstResponder()
    }
    
    func setDatePicker(){
        dateField.inputView = datePicker
        datePicker.datePickerMode = .dateAndTime
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.setDate(dueDate, animated: false)
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexible, doneBtn], animated: true)
        dateField.inputAccessoryView = toolBar
        
    }
    
    @objc func doneAction() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) {
            granted, error in
            // do nothing
        }
        
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .medium
        dateformatter.timeStyle = .short
        dateField.text = dateformatter.string(from: datePicker.date)
        dueDate = datePicker.date
        view.endEditing(true)
    }
    
}

// MARK: - UITextFieldDelegate
extension AddReminderViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        view.endEditing(true)
    }
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange,
                                                  with: string)
        saveBtn.isEnabled = !newText.isEmpty
        return true
    }
}
