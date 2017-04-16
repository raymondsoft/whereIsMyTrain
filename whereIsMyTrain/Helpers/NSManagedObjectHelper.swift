//
//  NSManagedObjectHelper.swift
//  whereIsMyTrain
//
//  Created by Kun LIANG on 15/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import UIKit
import CoreData

struct NSManagedObjectHelper {
    
    
    static func getManagedOjects<T : NSManagedObject>() -> [T]? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let objects = try context.fetch(T.fetchRequest()) as? [T]
            return objects
        } catch {
            print("Error While getting objects from Core Data")
            return nil
        }
    }
    
    static func getManagedObject<T : NSManagedObject>(fromId objectId: String) -> T?  {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request  = T.fetchRequest()
        let predicat = NSPredicate(format: "id = %@", objectId)
        request.predicate = predicat
        do {
            let collection = try context.fetch(request)
            return collection.first as! T?
            
        } catch {
            print("Error while getting object from Core Data")
        }
        return nil
        
    }
    
}
