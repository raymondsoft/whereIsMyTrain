//
//  Region+CoreDataClass.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 14/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON


public class Region: NSManagedObject {

    
    convenience init(context: NSManagedObjectContext, region json: JSON) {
        
        self.init(context: context)
        
        self.status = json["status"].stringValue
        self.id  = json["id"].stringValue
        self.name  = json["name"].stringValue
        
        let endProductionDate = json["end_production_date"].stringValue
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        if let formattedDate = dateFormatter.date(from: endProductionDate) {
            self.endDate =  NSDate(timeIntervalSince1970: formattedDate.timeIntervalSince1970)
        } else {
            self.endDate = NSDate()
        }
        
        
    }
  
    
    func describe() {
        print("--------------")
        print ("Region|\(name)|\(id)|\(status)|\(endDate)|")

    }
}


/*
convenience init(context: NSManagedObjectContext, station json: JSON) {
    self.init(context: context)
    
    self.name = json["name"].stringValue
    self.address = json["address"].stringValue
    self.latitude = json["position"]["lat"].doubleValue
    self.longitude = json["position"]["long"].doubleValue
    
    let lines = json["lines"].arrayValue.map({$0.stringValue})
    for lineId in lines {
        self.linkStationToLine(id: lineId, with: context)
    }
    
    self.distanceToUser = 0.0
    
    
}
 
 */
