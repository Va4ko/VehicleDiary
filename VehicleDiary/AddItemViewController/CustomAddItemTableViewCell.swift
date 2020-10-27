//
//  CustomAddItemTableViewCell.swift
//  VehicleDiary
//
//  Created by Vachko on 21.10.20.
//

import UIKit

class CustomAddItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var type: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var shop: UITextField!
    @IBOutlet weak var service: UITextField!
    @IBOutlet weak var details: UITextField!
    @IBOutlet weak var thumb: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
