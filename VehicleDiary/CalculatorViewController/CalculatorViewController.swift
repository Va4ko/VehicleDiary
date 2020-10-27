//
//  CalculatorViewController.swift
//  VehicleDiary
//
//  Created by Vachko on 27.10.20.
//

import UIKit

class CalculatorViewController: UIViewController {
        
    @IBOutlet weak var hpField: textFieldStyle!
    @IBOutlet weak var kwField: textFieldStyle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        setBackground()
        hpField.becomeFirstResponder()
    }
    
    @IBAction func hpFieldDidChanged(_ sender: Any) {
        let hpFieldInt: Double? = Double(hpField.text!)
        if hpFieldInt != nil {
            kwField.text = String(format: "%.0f", hpFieldInt! * 0.73549875)
        } else {
            kwField.text = nil
        }
    }
    
    @IBAction func kwFieldDidChanged(_ sender: Any) {
        let kwFieldInt: Double? = Double(kwField.text!)
        if kwFieldInt != nil {
            hpField.text = String(format: "%.0f", kwFieldInt! * 1.35962173)
        } else {
            hpField.text = nil
        }
    }
}

extension CalculatorViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == hpField {
            let allowingChars = "0123456789."
            let numberOnly = NSCharacterSet.init(charactersIn: allowingChars).inverted
            let validString = string.rangeOfCharacter(from: numberOnly) == nil
            return validString
        } else if textField == kwField {
            let allowingChars = "0123456789."
            let numberOnly = NSCharacterSet.init(charactersIn: allowingChars).inverted
            let validString = string.rangeOfCharacter(from: numberOnly) == nil
            return validString
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }
}
