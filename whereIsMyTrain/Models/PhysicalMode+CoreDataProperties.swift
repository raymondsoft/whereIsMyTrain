//
//  PhysicalMode+CoreDataProperties.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 14/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import Foundation
import CoreData


extension PhysicalMode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhysicalMode> {
        return NSFetchRequest<PhysicalMode>(entityName: "PhysicalMode");
    }

    @NSManaged public var name: String
    @NSManaged public var id: String

}
