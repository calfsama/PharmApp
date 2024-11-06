//
//  DataModel+CoreDataProperties.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 17/10/22.
//
//

import Foundation
import CoreData


extension DataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataModel> {
        return NSFetchRequest<DataModel>(entityName: "DataModel")
    }

    @NSManaged public var image: String?
    @NSManaged public var title: String?
    @NSManaged public var price: String?
    @NSManaged public var id: String?
    @NSManaged public var is_favorite: Bool

}
