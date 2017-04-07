//
//  Station+CoreDataClass.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 06/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON


public class Station: NSManagedObject {
    
    /*
     {
     "name": "Nation",
     "address": "Nation (terre-plein face au 3 place de la) - 75112",
     "position": {
     "lat": 48.84811123157566,
     "long": 2.3980040127977436
     },
     "lines": ["1", "2", "6", "9"]
     }
     
     */
    
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
    
    
    func printDescription() {
        print("----------------------")
        print("Station: \(self.name), address : \(self.address), coord: (\(self.latitude),\(self.longitude))")
        var linesDesc = ""
        for line in self.lines?.allObjects as! [Line]{
            linesDesc += line.id + ","
        }
        print(linesDesc)
    }
    
    
    func linkStationToLine(id: String, with context: NSManagedObjectContext){
        let linePredicate = NSPredicate(format: "id = %@", id)
        let lineRequest : NSFetchRequest<Line> = Line.fetchRequest()
        lineRequest.predicate = linePredicate
        
        do {
            let lines = try context.fetch(lineRequest)
            if ( lines.count == 0 ) {
                // The line doesn't exist, we create it
                let line = Line(context: context)
                line.id = id
                self.addToLines(line)
            } else {
                // the line exist, we link it to the station
                self.addToLines(lines[0])
                
            }
        }
        catch {
            print("Error while getting line from Core Data")
        }
    }
}
