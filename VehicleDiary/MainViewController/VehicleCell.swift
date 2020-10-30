//
//  VehicleCell.swift
//  VehicleDiary
//
//  Created by Vachko on 14.10.20.
//

import UIKit

class VehicleCell: UITableViewCell {
    
    @IBOutlet weak var cellBg: UIView!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var VehicleLabel: UILabel!
    
    func configureCell(car: Car) {
        VehicleLabel.text = """
        \(car.brand!)
        \(car.model!)
        """
        logoImg.image = UIImage(data: car.logo!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
