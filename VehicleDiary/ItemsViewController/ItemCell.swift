//
//  ItemCell.swift
//  VehicleDiary
//
//  Created by Vachko on 19.10.20.
//

import UIKit

class ItemCell: UITableViewCell {
    
    
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var shop: UILabel!
    @IBOutlet weak var service: UILabel!
    @IBOutlet weak var details: UITextView!
    @IBOutlet weak var thumb: UIImageView!
    
    func configureCell(item: Item) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyyy"
        
        type.adjustsFontSizeToFitWidth = true;
        type.numberOfLines = 0;
        type.text = item.type
        price.text = "$\(item.price)"
        if item.date != nil {
            date.text = dateformatter.string(from: item.date!)
        } else {
            date.text = "No date entered"
        }
        details.text = item.details
        shop.text = item.shop
        service.text = item.service
        if item.image == nil {
            thumb.image = UIImage(named: "noImg")
        } else {
            thumb.image = UIImage(data: item.image!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
