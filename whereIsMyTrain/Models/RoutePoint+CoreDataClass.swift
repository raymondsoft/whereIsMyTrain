//
//  RoutePoint+CoreDataClass.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 14/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import Foundation
import CoreData


public class RoutePoint: NSManagedObject {

    
    convenience init(context: NSManagedObjectContext, index: Int16, latitude: Double, longitude: Double) {
        
        self.init(context: context)
        self.index = index
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
    func describe() {
        print("\t RoutePoint : \(self.index) -> (\(self.latitude),\(self.longitude))")
    }
}
