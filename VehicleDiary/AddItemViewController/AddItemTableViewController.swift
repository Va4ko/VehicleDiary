//
//  AddItemTableViewController.swift
//  VehicleDiary
//
//  Created by Vachko on 21.10.20.
//

import UIKit
import CoreData

protocol AddItemTableViewControllerDelegate: class {
    func addItemTableViewControllerDidCancel(_ controller: AddItemTableViewController)
    
    func addItemTableViewControllerFinishAdding(_ controller: AddItemTableViewController)
    
    func addItemTableViewControllerFinishEditing(_ controller: AddItemTableViewController)
}

class AddItemTableViewController: UITableViewController {
    
    weak var delegate: AddItemTableViewControllerDelegate?
    
    var selectedCar: Car?
    let datePicker = UIDatePicker()
    var imagePicker: UIImagePickerController!
    var photo: UIImage?
    var itemToEdit: Item?
    
    @IBOutlet weak var type: UITextField!
    @IBOutlet weak var date: UITextField! {
        didSet {
            date.attributedPlaceholder = NSAttributedString(string:"Date", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        }
    }
    @IBOutlet weak var price: UITextField! {
        didSet {
            price.attributedPlaceholder = NSAttributedString(string:"Price", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        }
    }
    @IBOutlet weak var shop: UITextField! {
        didSet {
            shop.attributedPlaceholder = NSAttributedString(string:"Shop", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        }
    }
    @IBOutlet weak var service: UITextField! {
        didSet {
            service.attributedPlaceholder = NSAttributedString(string:"Service", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        }
    }
    @IBOutlet weak var details: UITextField! {
        didSet {
            details.attributedPlaceholder = NSAttributedString(string:"details", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        }
    }
    @IBOutlet weak var thumb: UIImageView!
    
    
    @IBAction func cancelBtnTaped(_ sender: Any) {
        delegate?.addItemTableViewControllerDidCancel(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6507651969)
        setDatePicker()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        price.delegate = self
        
        if itemToEdit != nil {
            loadItemData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        type.becomeFirstResponder()
    }
    
    @IBAction func saveBtnTaped(_ sender: Any) {
        if itemToEdit != nil {
            guard let item = itemToEdit else {
                return
            }
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "dd.MM.yyyy"
            if type.text?.isEmpty == false {
                item.setValue("\(type.text!)", forKey: "type")
            } else {
                item.setValue("No name entered", forKey: "type")
            }
            if price.text?.isEmpty == false {
                item.price = Double(price.text!)!
            } else {
                item.price = 0
            }
            if dateformatter.date(from: date.text!) != nil {
                item.date = dateformatter.date(from: date.text!)
            } else {
                item.date = nil
            }
            if shop.text?.isEmpty == false {
                item.shop = shop.text
            } else {
                item.shop = "No shop entered"
            }
            if service.text?.isEmpty == false {
                item.service = service.text
            } else {
                item.service = "No service entered"
            }
            if details.text?.isEmpty == false {
                item.details = details.text
            } else {
                item.details = "No details entered"
            }
            item.image = photo?.jpegData(compressionQuality: 1)
            item.car = selectedCar
            
            do {
                try context.save()
            } catch {
                print("core data save error : \(error)")
            }
            delegate?.addItemTableViewControllerFinishAdding(self)
            
        } else {
            guard let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: context) as? Item else {
                return
            }
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "dd.MM.yyyy"
            if type.text?.isEmpty == false {
                item.type = type.text
            } else {
                item.type = "No name entered"
            }
            if price.text?.isEmpty == false {
                item.price = Double(price.text!)!
            } else {
                item.price = 0.0
            }
            if dateformatter.date(from: date.text!) != nil {
                item.date = dateformatter.date(from: date.text!)
            } else {
                item.date = nil
            }
            if shop.text?.isEmpty == false {
                item.shop = shop.text
            } else {
                item.shop = "No shop entered"
            }
            if service.text?.isEmpty == false {
                item.service = service.text
            } else {
                item.service = "No service entered"
            }
            if details.text?.isEmpty == false {
                item.details = details.text
            } else {
                item.details = "No details entered"
            }
            item.image = photo?.jpegData(compressionQuality: 1)
            item.car = selectedCar
            
            do {
                try context.save()
            } catch {
                print("core data save error : \(error)")
            }
            delegate?.addItemTableViewControllerFinishAdding(self)
        }
    }
    
    @IBAction func getImage(_ sender: UITapGestureRecognizer) {
        type.resignFirstResponder()
        price.resignFirstResponder()
        date.resignFirstResponder()
        shop.resignFirstResponder()
        service.resignFirstResponder()
        details.resignFirstResponder()
        
        imagePicker =  UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func loadItemData() {
        let currentDateTime = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyyy"
        if let item = itemToEdit {
            type.text = item.type
            price.text = "\(item.price)"
            details.text = item.details
            shop.text = item.shop
            service.text = item.service
            date.text = dateformatter.string(from: item.date ?? currentDateTime)
            if item.image != nil {
                thumb.image = UIImage(data: item.image!)
            } else {
                thumb.image = UIImage(named: "addImg")
            }
        }
    }
    
    func setDatePicker(){
        date.inputView = datePicker
        datePicker.datePickerMode = .date
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .inline
        }
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexible, doneBtn], animated: true)
        date.inputAccessoryView = toolBar
        
    }
    
    @objc func doneAction() {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyyy"
        date.text = dateformatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
}

extension AddItemTableViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Error while taking photo: \(info)")
        }
        
        thumb.image = image
        photo = image
    }
}

extension AddItemTableViewController: UINavigationControllerDelegate {
    
}

extension AddItemTableViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == price {
            let allowingChars = "0123456789."
            let numberOnly = NSCharacterSet.init(charactersIn: allowingChars).inverted
            let validString = string.rangeOfCharacter(from: numberOnly) == nil
            return validString
        }
        return true
    }
}
