//
//  Basket+CoreDataProperties.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 25/10/22.
//
//

import Foundation
import CoreData


extension Basket {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Basket> {
        return NSFetchRequest<Basket>(entityName: "Basket")
    }

    @NSManaged public var title: String?
    @NSManaged public var price: String?
    @NSManaged public var image: String?
    @NSManaged public var id: String?
    @NSManaged public var amount: String?
    @NSManaged public var art: String?

}
