//
//  Countries+CoreDataProperties.swift
//  Covid19 app
//
//  Created by David T on 6/3/21.
//
//

import Foundation
import CoreData


extension Countries {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Countries> {
        return NSFetchRequest<Countries>(entityName: "Countries")
    }

    @NSManaged public var country: String
    @NSManaged public var totalConfirmed: Int64
    @NSManaged public var totalRecovered: Int64
    @NSManaged public var totalDeaths: Int64
    @NSManaged public var newConfirmed: Int64
    @NSManaged public var newRecovered: Int64
    @NSManaged public var newDeaths: Int64

}
