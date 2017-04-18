//
//  Line+CoreDataClass.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 06/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON


public class Line: NSManagedObject {

    
    convenience init(context: NSManagedObjectContext, line json: JSON) {
        
        self.init(context: context)
        
        self.name = json["name"].stringValue
        self.code = json["code"].stringValue
        self.color = json["color"].stringValue
        self.textColor = json["text_color"].stringValue
        self.id = json["id"].stringValue
        self.physicalMode = json["physical_modes"][0]["id"].stringValue
        
        let routeArray = json["geojson"]["coordinates"].arrayValue
//        print ("creation des route de la ligne \(self.code) couleur de ligne : \(self.color)")
        for routeJson in routeArray {
//            print(routeJson)
            let route = Route(context: context, route: routeJson)
            self.addToRoutes(route)
        }
        
    }
    
    func describe(){
        print("Line : \(self.name), \(self.code), \(self.color), \(self.textColor), \(self.id), \(self.physicalMode)")
//        if let routes = self.routes?.allObjects as? [Route] {
//            for route in routes {
//                route.describe()
//            }
//        }
    }
    
    
    public static func sortLine(line1: Line, line2: Line) -> Bool {
        let id1 = Int(line1.id.components(separatedBy: .letters).joined())
        let id2 = Int(line2.id.components(separatedBy: .letters).joined())
        return id1! < id2!
    }

}
