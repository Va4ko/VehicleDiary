//
//  textFieldExtension.swift
//  VehicleDiary
//
//  Created by Vachko on 27.10.20.
//

import UIKit

class textFieldStyle: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextField()
    }
    
    private func setupTextField(){
        tintColor = .blue
        textColor = .blue
        autocorrectionType = .no

        font = UIFont.init(name: "Nasalization", size: 20.0)
        textAlignment = NSTextAlignment.left

        autocapitalizationType = UITextAutocapitalizationType.sentences
        
        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: frame.height))
        leftView = paddingView
        leftViewMode = UITextField.ViewMode.always
    }
}
