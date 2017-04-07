//
//  MapViewController.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 06/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit
import CoreData

class MapViewController: UIViewController {
    
    var stations = [Station]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        print("ViewWillAppear")
//        readStation()
//        readLines()
//        deleteAll()
//        readStationsFromJson()
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func readLines() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        var compteur = 0
        do {
            let lines = try context.fetch(Line.fetchRequest()) as? [Line]
            for line in lines! {
                print("cpt: \(compteur) n° ligne : \(line.id)")
                compteur = compteur + 1
            }
        }
        catch {
            print("Error While getting Lines from Core Data")
        }
        
    }
    
    
    func readStation() {
        print("readStation")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let stations = try context.fetch(Station.fetchRequest()) as? [Station]
            for station in stations! {
                station.printDescription()
            }
        }
        catch {
            print("Error While getting stations from Core Data")
        }
        
    }
    
    func readStationsFromJson() {
        print("readStationsFromJson")
        
        
        do {
            let stationsJsonUrl = Bundle.main.url(forResource: "metros", withExtension: "json")
            let stationsJson = try JSON(data: Data(contentsOf: stationsJsonUrl!))
            print(stationsJson)
            
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            for stationJson in stationsJson["result"].arrayValue {
                let station = Station(context: context, station: stationJson)
                station.printDescription()
            }
            
            appDelegate.saveContext()
            
        }
        catch {
            print("Error while getting stations")
        }
    }
    
    
    func deleteAll() {
        
        let entitiesToDelete = ["station", "line"]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        for entityToDelete in entitiesToDelete {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityToDelete)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(deleteRequest)
                print("\(entityToDelete) deleted")
            } catch {
                print("Error while deleting \(entityToDelete)")
            }
            
        }
        
        do {
            try context.save()
        } catch {
            print("Error while saving context")
        }
        /*
        //        let fetch : NSFetchRequest<Station> = Station.fetchRequest()
        let requestStation = NSBatchDeleteRequest(fetchRequest: Station.fetchRequest())
        do {
            try context.execute(requestStation)
            print("Stations deleted")
        } catch {
            print("Error while deleting Stations")
        }
        
        
        
        
        let requestLine = NSBatchDeleteRequest(fetchRequest: Line.fetchRequest())
        do {
            try context.execute(requestLine)
            print("Lines deleted")
        } catch {
            print("Error while deleting Lines")
        }
 */
    }
}
