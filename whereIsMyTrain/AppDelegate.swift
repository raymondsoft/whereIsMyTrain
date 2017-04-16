//
//  AppDelegate.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 04/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
//        let isStationMetroLoaded = UserDefaults.standard.bool(forKey: "StationsMetroLoaded")
//        if !isStationMetroLoaded {
//            loadData()
//            UserDefaults.standard.set(true, forKey: "StationsMetroLoaded")
//        }
        
        loadNavitiaData()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "whereIsMyTrain")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /*
    func loadData() {
        
        let context = persistentContainer.viewContext
        
        removeData()
        print("trying to load datas")
        guard let jsonUrl = Bundle.main.url(forResource: "metros", withExtension: "json") else {
            print(" file 'metros.json' not found")
            return
        }
        let jsonData = try! Data(contentsOf: jsonUrl)
        let stationsData = JSON(jsonData)
        let jsonArray = stationsData["result"].arrayValue
        for station in jsonArray {
            _ = Station(context: context, station: station)
        }
        
        self.saveContext()
    }
    */
    func loadNavitiaData() {
        let context = persistentContainer.viewContext
//        removeNavitiaData(context)
        
//        loadNavitiaRegionData(context)
//        loadNavitiaPhysicalModes(context)
//        loadNavitiaLines(context)
//        loadNavitiaStations(context)
        
//        fetchNavitia(context)
        
//        self.saveContext()
    }
    
    func fetchNavitia(_ context : NSManagedObjectContext) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let lines = try context.fetch(Line.fetchRequest()) as? [Line]
            for line in lines! {
                line.describe()
            }
        }
        catch {
            print("Error While getting stations from Core Data")
        }
    }
    
    func loadNavitiaRegionData(_ context : NSManagedObjectContext) {
        // TODO : removeDatas
        print("Trying to load regions datas")
        NavitiaHelper.getNavitiaRegions() {
            json in
            if let json = json {
                let regionsArray = json["regions"].arrayValue
                for regionJson in regionsArray {
                    let region = Region(context: context, region: regionJson)
                    region.describe()
                }
                self.saveContext()
            }
        }
    }
    
    
    func loadNavitiaLines(_ context : NSManagedObjectContext) {
        print("rtying to load Lines")
        
        let transportModes = [NavitiaPhysicalMode.metro, .RER, .tramway, .bus]
        
        for transportMode in transportModes {
            NavitiaHelper.getNavitiaLines(for: "fr-idf", transportMode: transportMode) {
                json in
                if let json = json {
                    //                print(json)
                    let lineArray = json["lines"].arrayValue
                    for lineJson in lineArray {
                        let line = Line(context: context, line: lineJson)
                        print("\(line.code)")
                    }
                    self.saveContext()
                }
            }
        }
    }

    
    
    func loadNavitiaStations(_ context : NSManagedObjectContext) {
        print("trying to load stations")
        if let lines = NavitiaHelper.getLines() {
//        if let lines = NSManagedObjectHelper.getManagedOjects()<Line> {
            for line in lines {
                line.describe()
//                if line.physicalMode == NavitiaPhysicalMode.metro.rawValue {
                    NavitiaHelper.getNavitiaStation(for: "fr-idf", line: line) {
                        json in
                        if let json = json {
                            let stationArray = json["stop_areas"].arrayValue
                            for stationJson in stationArray {
                                let stationId = stationJson["id"].stringValue
                                if let station = NavitiaHelper.getStation(fromId: stationId) {
                                    // The station already exist. We link it to the line
                                    station.addToLines(line)
//                                    print ("Station ADDD !!")
                                } else {
                                    let station = Station(context: context, station: stationJson, line: line)
//                                    station.describe()
                                    
                                }
                                
                            }
                        }
                                                self.saveContext()
                    }
                    
//                }
            }
        }
        
    }
    
    
    private func stationExist(with stationId: String, in context : NSManagedObjectContext) -> Bool{
        
        var exist = false
        
        let request : NSFetchRequest<Station> = Station.fetchRequest()
        let predicat = NSPredicate(format: "id = %@", stationId)
        request.predicate = predicat
        do {
            let stations = try context.fetch(request)
            exist = (stations.count > 0)
        
        } catch {
            print("Error while getting station from Core Data")
        }
        print("station \(stationId) exist ?  \(exist)")
        return exist
    }
    
    
    func loadNavitiaPhysicalModes(_ context : NSManagedObjectContext) {
        print("Trying to load Physical Modes datas")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        NavitiaHelper.getNavitiaPhysicalsMode() {
            json in
            if let json = json {
                //                            print(json)
                let physicalModeArray = json["physical_modes"].arrayValue
                for physicalModeJson in physicalModeArray {
                    let physicalMode = PhysicalMode(context: context, physicalMode: physicalModeJson)
                    physicalMode.describe()
                }
            }
            self.saveContext()
        }
    }
    
    func removeData() {
        
        let entitiesToDelete = ["Station", "Line"]
        
        let context = persistentContainer.viewContext
        
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
        self.saveContext()
    }
    
    func removeNavitiaData(_ context : NSManagedObjectContext) {
        let entitiesToDelete = ["Region", "PhysicalMode", "Line", "Route", "RoutePoint", "Station"]
        
        
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
        self.saveContext()
        
    }
    
}

