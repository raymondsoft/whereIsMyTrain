//
//  PhysicalMode+CoreDataClass.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 14/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON


public class PhysicalMode: NSManagedObject {
    
    
    convenience init(context: NSManagedObjectContext, physicalMode json: JSON) {
        
        self.init(context: context)
        
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        
    }
    
    func describe() {
        print ("PhysicalMode|\(name)|\(id)|")
    }
}
