//
//  Station+CoreDataProperties.swift
//  
//
//  Created by etudiant-09 on 12/04/2017.
//
//

import Foundation
import CoreData


extension Station {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Station> {
        return NSFetchRequest<Station>(entityName: "Station");
    }

    @NSManaged public var address: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String
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
