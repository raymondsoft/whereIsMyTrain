//
//  Region+CoreDataProperties.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 14/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import Foundation
import CoreData


extension Region {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Region> {
        return NSFetchRequest<Region>(entityName: "Region");
    }

    @NSManaged public var status: String
    @NSManaged public var endDate: NSDate
    @NSManaged public var id: String
    @NSManaged public var name: String

}
