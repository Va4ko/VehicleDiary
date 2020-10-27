//
//  SelectVehicleViewController.swift
//  VehicleDiary
//
//  Created by Vachko on 15.10.20.
//

import UIKit
import CoreData

protocol SelectVehicleViewControllerDelegate: class {
    func selectVehicleViewControllerDidCancel(
        _ controller: SelectVehicleViewController)
    
    func selectVehicleViewControllerFinishAdding(
        _ controller: SelectVehicleViewController)
    
}

class SelectVehicleViewController: UITableViewController {
    
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var pickerViewFirst: UIPickerView!
    @IBOutlet weak var pickerViewSecond: UIPickerView!
    
    weak var delegate: SelectVehicleViewControllerDelegate?
    
    var controller: NSFetchedResultsController<Car>!
    
    var brandsAndModels: [String: [String]] = [:]
    var brands = [String]()
    
    var _models: [String] = ["-- Select vehicle model --"]
    
    var _selectedBrand: String!
    var _selectedModel: String!
    
    var models: [String] {
        if _models.isEmpty {
            _models.append("")
        }
        return _models
    }
    
    var selectedBrand: String {
        if _selectedBrand == nil {
            _selectedBrand = "-- Select vehicle brand --"
        }
        return _selectedBrand
    }
    
    var selectedModel: String {
        if _selectedModel == nil {
            _selectedModel = "-- Select vehicle model --"
        }
        return _selectedModel
    }
    
    var logo: UIImage?
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        delegate?.selectVehicleViewControllerDidCancel(self)
    }
    
    
    @IBAction func doneBtnTapped(_ sender: UIBarButtonItem) {
        if selectedBrand != "-- Select vehicle brand --" && selectedModel != "-- Select vehicle model --" {

            if checkForAnother() == 0 {

                guard let car = NSEntityDescription.insertNewObject(forEntityName: "Car", into: context) as? Car else {
                    return
                }
                car.brand = selectedBrand
                car.model = selectedModel
                car.logo = logo!.jpegData(compressionQuality: 1)

                do {
                    try context.save()
                } catch {
                    print("core data save error : \(error)")
                }
                delegate?.selectVehicleViewControllerFinishAdding(self)
            } else {
                let number = checkForAnother() + 1
                guard let car = NSEntityDescription.insertNewObject(forEntityName: "Car", into: context) as? Car else {
                    return
                }
                car.brand = selectedBrand
                car.model = "\(selectedModel) \(number)"
                car.logo = logo!.jpegData(compressionQuality: 1)
                
                do {
                    try context.save()
                } catch {
                    print("core data save error : \(error)")
                }
                delegate?.selectVehicleViewControllerFinishAdding(self)
            }
            
        } else {
            let alert = UIAlertController(title: "Attention!", message: "Please select brand and model of your vehicle!", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default){ _ in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            
            self.present(alert, animated: true)
        }
        
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = UIImageView(image: UIImage(named: "background.jpg"))
    }
    
    func pickerUpdate() {
        var firstElement = _models.first!
        _models.removeAll()
        _models.append(firstElement)
        if selectedBrand != "-- Select vehicle brand --" {
            for i in brandsAndModels[selectedBrand]!{
                _models.append(i)
            }
            pickerViewSecond.alpha = 1.0
            pickerViewSecond.reloadAllComponents()
            pickerViewSecond.selectRow(0, inComponent: 0, animated: true)
        } else {
            firstElement = "-- Select vehicle model --"
            _models.removeAll()
            _models.append(firstElement)
            pickerViewSecond.reloadAllComponents()
            pickerViewSecond.selectRow(0, inComponent: 0, animated: true)
        }
    }
    
    func checkForAnother() -> Int {
        var cars:[Car] = []
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        let key = selectedModel
        fetchRequest.predicate = NSPredicate(format: "model BEGINSWITH %@", key)
        
        do {
            cars = try context.fetch(fetchRequest)
        } catch {
            print("error")
        }
        return cars.count
    }
    
}

extension SelectVehicleViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            _selectedBrand = brands[pickerView.selectedRow(inComponent: 0)]
            let indexOfBrand: Int = brands.firstIndex(of: _selectedBrand)!
            urlEnd = "\(indexOfBrand)"
            downloadLogo() { image in
                DispatchQueue.main.async {
                    self.logo = image
                    self.doneBtn.isEnabled = true
                }
            }
            pickerUpdate()
            _selectedModel = nil
        } else if pickerView.tag == 2 {
            _selectedModel = models[pickerView.selectedRow(inComponent: 0)]
            
        }
    }
}

extension SelectVehicleViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 1 {
            return 1
        } else if pickerView.tag == 2 {
            return 1
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return brands.count
        } else if pickerView.tag == 2 {
            return models.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return brands[row]
        } else if pickerView.tag == 2 {
            return models[row]
        }
        return ""
    }
    
}
