//
//  Car+CoreDataProperties.swift
//  VehicleDiary
//
//  Created by Vachko on 19.10.20.
//
//

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var brand: String?
    @NSManaged public var logo: Data?
    @NSManaged public var model: String?
    @NSManaged public var item: NSSet?

}

// MARK: Generated accessors for item
extension Car {

    @objc(addItemObject:)
    @NSManaged public func addToItem(_ value: Item)

    @objc(removeItemObject:)
    @NSManaged public func removeFromItem(_ value: Item)

    @objc(addItem:)
    @NSManaged public func addToItem(_ values: NSSet)

    @objc(removeItem:)
    @NSManaged public func removeFromItem(_ values: NSSet)

}

extension Car : Identifiable {

}
