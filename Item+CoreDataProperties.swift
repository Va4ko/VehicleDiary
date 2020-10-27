//
//  Item+CoreDataProperties.swift
//  VehicleDiary
//
//  Created by Vachko on 19.10.20.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var date: Date?
    @NSManaged public var details: String?
    @NSManaged public var price: Double
    @NSManaged public var service: String?
    @NSManaged public var shop: String?
    @NSManaged public var type: String?
    @NSManaged public var image: Data?
    @NSManaged public var car: Car?

}

extension Item : Identifiable {

}
