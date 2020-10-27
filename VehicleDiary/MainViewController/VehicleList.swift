//
//  VehicleList.swift
//  VehicleDiary
//
//  Created by Vachko on 16.10.20.
//

import UIKit

class VehicleList {
    var brand: String
    var model: String
    var logo: UIImage
//    var Items: [Item] = []
    
    init(_ selectedBrand: String, model: String, logo: UIImage ) {
        self.brand = selectedBrand
        self.model = model
        self.logo = logo
    }
    
//    func countItems() -> Int {
//        var count = 0
//        count = checklistItems.count
//
//        return count
//    }
    
//    func countUncheckedItems() -> Int {
//        var count = 0
//        for item in checklistItems where !item.isChecked {
//            count += 1
//        }
//
//        return count
//    }
    
//    func sortListItem() {
//        let sortedList = checklistItems.sorted(by: { $0.dueDate > $1.dueDate })
//        checklistItems = sortedList
//    }
}

extension VehicleList: Equatable {
    static func == (lhs: VehicleList, rhs: VehicleList) -> Bool {
        lhs.brand == rhs.brand && lhs.model == rhs.model
    }
}
