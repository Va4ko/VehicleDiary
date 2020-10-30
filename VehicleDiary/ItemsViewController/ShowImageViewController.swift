//
//  ShowImageViewController.swift
//  VehicleDiary
//
//  Created by Vachko on 23.10.20.
//

import UIKit
import CoreData

class ShowImageViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var bigImage: UIImageView!
    
    // MARK: Properties
    var item: Item?
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if item?.image != nil {
            bigImage.image = UIImage(data: item!.image!)
        } else {
            bigImage.image = UIImage(named: "noImg")
            bigImage.contentMode = .center
        }
    }
    
}
