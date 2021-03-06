//
//  Station+CoreDataProperties.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 14/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import Foundation
import CoreData


extension Station {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Station> {
        return NSFetchRequest<Station>(entityName: "Station");
    }

    @NSManaged public var distanceToUser: Double
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String
    @NSManaged public var id: String
    @NSManaged public var label: String
    @NSManaged public var lines: NSSet?

}

// MARK: Generated accessors for lines
extension Station {

    @objc(addLinesObject:)
    @NSManaged public func addToLines(_ value: Line)

    @objc(removeLinesObject:)
    @NSManaged public func removeFromLines(_ value: Line)

    @objc(addLines:)
    @NSManaged public func addToLines(_ values: NSSet)

    @objc(removeLines:)
    @NSManaged public func removeFromLines(_ values: NSSet)

}
