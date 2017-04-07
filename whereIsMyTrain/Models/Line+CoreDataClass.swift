//
//  Line+CoreDataClass.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 06/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import UIKit
import CoreData


public class Line: NSManagedObject {

    
    public static func sortLine(line1: Line, line2: Line) -> Bool {
        let id1 = Int(line1.id.components(separatedBy: .letters).joined())
        let id2 = Int(line2.id.components(separatedBy: .letters).joined())
        return id1! < id2!
    }

}
