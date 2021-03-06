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
import CoreLocation
import MapKit


public class Station: NSManagedObject {
    
    var slugName : String {
        get {
            return self.name
                .replacingOccurrences(of: " ", with: "+")
                .replacingOccurrences(of: "-", with: "+")
                .folding(options: [.diacriticInsensitive], locale: .current)
                .lowercased()
        }
    }
    
    var formattedDistanceToUser : String {
        get {
            let distanceFormatter = MKDistanceFormatter()
            distanceFormatter.units = MKDistanceFormatterUnits.metric
            return distanceFormatter.string(fromDistance: self.distanceToUser)
//            
//            let numberFormatter = NumberFormatter()
//            numberFormatter.minimumFractionDigits = 0
//            let distanceString = numberFormatter.string(from: NSNumber(value: self.distanceToUser))
//            return distanceString! + " m"
            
        }
    }
    
    
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
    
    convenience init(context: NSManagedObjectContext, station json: JSON, line : Line) {
        self.init(context: context)
        
        self.name = json["name"].stringValue
        self.latitude = json["coord"]["lat"].doubleValue
        self.longitude = json["coord"]["lon"].doubleValue
        self.id = json["id"].stringValue
        self.label = json["label"].stringValue
        
        
        
        self.distanceToUser = 0.0
        
        self.addToLines(line)
        
    }
    
    func describe() {
        print("Station : \(name), \(id), (\(latitude),\(longitude)), \(label)")
    }
    
    func printDescription() {
        print("----------------------")
  //      print("Station: \(self.name), address : \(self.address), coord: (\(self.latitude),\(self.longitude))")
        var linesDesc = ""
        for line in self.lines?.allObjects as! [Line]{
            linesDesc += line.id + ","
        }
        print(linesDesc)
    }
    
    func has(transportMode : NavitiaPhysicalMode.RawValue) -> Bool {
        return self.getTransportModes().contains(transportMode)
    }
    
    func getTransportModes() -> [NavitiaPhysicalMode.RawValue] {
        var transportModes : [NavitiaPhysicalMode.RawValue] = []
        for line in self.lines?.allObjects as! [Line] {
            let transportMode = line.physicalMode
            if !transportModes.contains(transportMode) {
                transportModes.append(transportMode)
            }
            
        }
        return transportModes
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
    
    func computeDistanceToUser(from userLocation : CLLocation){
        let stationLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        self.distanceToUser = stationLocation.distance(from: userLocation)
    }
    
    // Sort by distance. If the distances are equals, sort by name. 
    // (If the distance to user are not computed, they are all 0.0)
    public static func sort(station1 : Station, station2 : Station) -> Bool {
        let distance1 = station1.distanceToUser
        let distance2 = station2.distanceToUser
        if distance1 != distance2 {
            return distance1 < distance2
        } else {
            return station1.name < station2.name
        }
    }
    
}
