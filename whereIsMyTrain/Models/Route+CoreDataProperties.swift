//
//  Route+CoreDataProperties.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 14/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import Foundation
import CoreData


extension Route {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Route> {
        return NSFetchRequest<Route>(entityName: "Route");
    }

    @NSManaged public var line: Line?
    @NSManaged public var routePoints: NSSet?

}

// MARK: Generated accessors for routePoints
extension Route {

    @objc(addRoutePointsObject:)
    @NSManaged public func addToRoutePoints(_ value: RoutePoint)

    @objc(removeRoutePointsObject:)
    @NSManaged public func removeFromRoutePoints(_ value: RoutePoint)

    @objc(addRoutePoints:)
    @NSManaged public func addToRoutePoints(_ values: NSSet)

    @objc(removeRoutePoints:)
    @NSManaged public func removeFromRoutePoints(_ values: NSSet)

}
