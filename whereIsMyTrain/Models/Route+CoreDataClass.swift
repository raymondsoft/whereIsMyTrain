//
//  Route+CoreDataClass.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 14/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData
import SwiftyJSON


public class Route: NSManagedObject {

    
    
    convenience init(context: NSManagedObjectContext, route json: JSON) {
        
        self.init(context: context)
        let routeArray = json.arrayValue
        var index = 0
        for routePointJson in routeArray {
            print("\t \(routePointJson)")
            let routePoint = RoutePoint(
                context: context,
                index: Int16(index),
                latitude: routePointJson[0].doubleValue,
                longitude: routePointJson[1].doubleValue)
            self.addToRoutePoints(routePoint)
            index = index + 1
        }
        
    }
    
    func describe() {
        print("\t Route : ")
        if let routePoints = self.routePoints?.allObjects as? [RoutePoint] {
            let routePointsBis = routePoints.sorted(by: {$0.index < $1.index})
            for routePoint in routePointsBis {
                routePoint.describe()
            }
        }
    }
}
