//
//  AddItemTableViewController.swift
//  VehicleDiary
//
//  Created by Vachko on 21.10.20.
//

import UIKit
import CoreData


//MARK: - Class Protocol
protocol AddItemTableViewControllerDelegate: class {
    func addItemTableViewControllerDidCancel(_ controller: AddItemTableViewController)
    
    func addItemTableViewControllerFinishAdding(_ controller: AddItemTableViewController)
    
    func addItemTableViewControllerFinishEditing(_ controller: AddItemTableViewController)
}

class AddItemTableViewController: UITableViewController {
    
    
    //MARK: = Properties
    weak var delegate: AddItemTableViewControllerDelegate?
    
    var selectedCar: Car?
    let datePicker = UIDatePicker()
    var imagePicker: UIImagePickerController!
    var photo: UIImage?
    var itemToEdit: Item?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var type: UITextField! {
        didSet {
            type.attributedPlaceholder = NSAttributedString(string:"Type", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        }
    }
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
    
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.clear
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
    
    
    //MARK: - IBActions
    @IBAction func saveBtnTaped(_ sender: Any) {
        if itemToEdit != nil {
            guard let item = itemToEdit else {
                return
            }
            saveData(itemToSave: item)
        } else {
            guard let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: context) as? Item else {
                return
            }
            saveData(itemToSave: item)
        }
    }
    
    @IBAction func getImage(_ sender: UITapGestureRecognizer) {
        type.resignFirstResponder()
        price.resignFirstResponder()
        date.resignFirstResponder()
        shop.resignFirstResponder()
        service.resignFirstResponder()
        details.resignFirstResponder()
        
        pickPhoto()
    }
    
    // MARK: - Helper methods
    /// Save item info to CoreData
    /// - Parameter itemToSave: Making new instance of Item or editing previously added item
    private func saveData(itemToSave: Item) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyyy"
        if type.text?.isEmpty == false {
            itemToSave.type = type.text
        } else {
            itemToSave.type = "No name entered"
        }
        if price.text?.isEmpty == false {
            itemToSave.price = Double(price.text!)!
        } else {
            itemToSave.price = 0.0
        }
        if dateformatter.date(from: date.text!) != nil {
            itemToSave.date = dateformatter.date(from: date.text!)
        } else {
            itemToSave.date = nil
        }
        if shop.text?.isEmpty == false {
            itemToSave.shop = shop.text
        } else {
            itemToSave.shop = "No shop entered"
        }
        if service.text?.isEmpty == false {
            itemToSave.service = service.text
        } else {
            itemToSave.service = "No service entered"
        }
        if details.text?.isEmpty == false {
            itemToSave.details = details.text
        } else {
            itemToSave.details = "No details entered"
        }
        itemToSave.image = photo?.jpegData(compressionQuality: 1)
        itemToSave.car = selectedCar
        
        do {
            try context.save()
        } catch {
            print("core data save error : \(error)")
        }
        delegate?.addItemTableViewControllerFinishAdding(self)
    }
    
    /// Load previously added item info for editing
    func loadItemData() {
        let currentDateTime = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyyy"
        if let item = itemToEdit {
            if item.type != "No name entered" {
                type.text = item.type
            }
            if item.price != 0.0 {
                price.text = "\(item.price)"
            }
            if item.details != "No details entered" {
                details.text = item.details
            }
            if item.shop != "No shop entered" {
                shop.text = item.shop
            }
            if item.service != "No service entered" {
                service.text = item.service
            }
            if item.date != nil {
                date.text = dateformatter.string(from: item.date ?? currentDateTime)
            }
            if item.image != nil {
                thumb.image = UIImage(data: item.image!)
            } else {
                thumb.image = UIImage(named: "addImg")
            }
        }
    }
    
    /// Here check if this app is running on real device or on simulator becouse the simulator is not camera capable
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            //            choosePhotoFromLibrary()
            let alert = UIAlertController(title: "Attention!", message: "You are on simulator and taking photo with camera is not supported.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default){ _ in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            
            self.present(alert, animated: true)
        }
    }
    
    /// If on real device showing menu for choosing camera or photo library to use
    func showPhotoMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let actPhoto = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in self.takePhotoWithCamera() })
        
        let actLibrary = UIAlertAction(title: "Choose From Library", style: .default, handler: { _ in self.choosePhotoFromLibrary() })
        
        alert.addAction(actPhoto)
        alert.addAction(actCancel)
        alert.addAction(actLibrary)
        
        present(alert, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func takePhotoWithCamera() {
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func setDatePicker(){
        date.inputView = datePicker
        datePicker.datePickerMode = .date
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
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

//MARK: - Extensions
extension AddItemTableViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
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
