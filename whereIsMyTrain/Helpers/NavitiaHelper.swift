//
//  NavitiaHelper.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 13/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

struct NavitiaHelper {
    
    static private let baseEndPoint = "https://api.navitia.io/v1/"
    static private let user = "ead72df8-7e1a-4ecf-a325-3e779f5326fd"
    static private let password = ""
    
    private static func getNavitiaInfo(extensionParameters extensionParametersList : [NavitiaArgument], parameters : [String:String], firstTry : Bool = true, _ completion    : @escaping (JSON?) -> Void){
        var extensionParameters = ""
        for argument in extensionParametersList {
            extensionParameters = extensionParameters + argument.command.rawValue + "/"
            if let arg = argument.argument {
                extensionParameters = extensionParameters + arg + "/"
            }
        }
        /*
        for (key, value) in extensionParametersDict {
            extensionParameters = extensionParameters + key.rawValue + "/"
            if let value = value {
                extensionParameters = extensionParameters + value + "/"
            }
        }
 */
        let networkManager = NetworkManager.sharedInstance
        networkManager.getInfo(endPoint: baseEndPoint, extensionEndPoint: extensionParameters, parameters: parameters, user: "ead72df8-7e1a-4ecf-a325-3e779f5326fd", password: "" ) {
            (json, error) in
            guard error	== nil else {
                print("error lors de la récuppération des Informations Navitia")
                if firstTry {
                    getNavitiaInfo(extensionParameters: extensionParametersList, parameters: parameters, firstTry: false, completion)
                } 
                return
            }
            completion(json)
            
        }
    }
    
    static func getNavitiaRegions(_ completion : @escaping (JSON?) -> Void) {
//        let extensionParameters : [NavitiaCommand : String?] = [NavitiaCommand.region : nil]
        let extensionParameters = [NavitiaArgument(command: NavitiaCommand.region, argument: nil)]
        getNavitiaInfo(extensionParameters: extensionParameters, parameters: [NavitiaOption.GeoJson.rawValue:"true"], completion)
    }
    
    static func getNavitiaPhysicalsMode(_ completion : @escaping (JSON?) -> Void) {
//        let extensionParameters : [NavitiaCommand : String?] = [
//            NavitiaCommand.physicalMode : nil
//        ]
        let extensionParameters = [NavitiaArgument(command: NavitiaCommand.physicalMode, argument: nil)]
//        extensionParameters.updateValue(nil, forKey: NavitiaCommand.physicalMode)
//        extensionParameters.updateValue(region.id, forKey: NavitiaCommand.region)
        
        getNavitiaInfo(extensionParameters: extensionParameters, parameters: [:], completion)
    }
    
    static func getNavitiaLines(for regionId : String, transportMode : NavitiaPhysicalMode, startPage : Int = 0, _ completion : @escaping (JSON?) -> Void) {
        
        let parameters = [
            NavitiaOption.startPage.rawValue : String(startPage)
        ]
        let extensionParameters = [
            NavitiaArgument(command: NavitiaCommand.region, argument: regionId),
            NavitiaArgument(command: NavitiaCommand.physicalMode, argument: transportMode.rawValue),
            NavitiaArgument(command: NavitiaCommand.line, argument: nil)
        ]
        getNavitiaInfo(extensionParameters: extensionParameters, parameters: parameters) {
            // manage pagination
            json in
            if let json = json {
                // this json result is pagined.
                
                // First, we process the data of the current json page
                completion(json)
                
                // Next we look to know if there is an other page
                let currentPage = json["pagination"]["start_page"].intValue
                let itemsOnPage = json["pagination"]["items_on_page"].intValue
                let itemsPerPage = json["pagination"]["items_per_page"].intValue
                let totalItems = json["pagination"]["total_result"].intValue
                
                print("page : \(currentPage) / \(totalItems/itemsPerPage) mode : \(transportMode.rawValue)")
                let numberOfItemsRead = currentPage * itemsPerPage + itemsOnPage
                
                // if the number of items read is less than the total number of items, then we call the next page
                if( numberOfItemsRead < totalItems) {
                    getNavitiaLines(for: regionId, transportMode: transportMode, startPage: (startPage + 1), completion)
                }
                
            }
        }
        
    }
    
    static func getNavitiaStation(for regionId : String, line : Line, startPage : Int = 0, _ completion : @escaping (JSON?) -> Void) {
        let extensionParameters = [
            NavitiaArgument(command: .region, argument: regionId),
            NavitiaArgument(command: .physicalMode, argument: line.physicalMode),
            NavitiaArgument(command: .line, argument: line.id),
            NavitiaArgument(command: .station, argument: nil)
            
        ]
        
        let parameters = [
            NavitiaOption.GeoJson.rawValue : "true",
            NavitiaOption.startPage.rawValue : String(startPage)
        ]
        print("getNavitiaStation(for \(regionId), line : \(line.code), startPage : \(startPage)")
        getNavitiaInfo(extensionParameters: extensionParameters, parameters: parameters) {
            // manage pagination
            json in
            if let json = json {
                // this json result is pagined.
                
                // First, we process the data of the current json page
                completion(json)
                
                // Next we look to know if there is an other page
                let currentPage = json["pagination"]["start_page"].intValue
                let itemsOnPage = json["pagination"]["items_on_page"].intValue
                let itemsPerPage = json["pagination"]["items_per_page"].intValue
                let totalItems = json["pagination"]["total_result"].intValue
                
                let numberOfItemsRead = currentPage * itemsPerPage + itemsOnPage
                
                // if the number of items read is less than the total number of items, then we call the next page
                if( numberOfItemsRead < totalItems) {
                    getNavitiaStation(for: regionId, line: line, startPage: startPage + 1, completion)
                }
                
            }
        }
    }
    
    
    static func getNavitiaSchedules(for regionId : String, station : Station, startPage : Int = 0, _ processing : @escaping (JSON?) -> Void, _ completion : @escaping () -> Void) {
        let extensionParameters = [
            NavitiaArgument(command: .region, argument: regionId),
            NavitiaArgument(command: .station, argument: station.id),
            NavitiaArgument(command: .schedules, argument: nil)
            
        ]
        
        let parameters = [
            NavitiaOption.startPage.rawValue : String(startPage),
            NavitiaOption.itemsPerSchedules.rawValue : String(2)
        ]
        print("getNavitiaStation(for \(regionId), line : \(station.label), startPage : \(startPage)")
        var shouldComplete = false
        getNavitiaInfo(extensionParameters: extensionParameters, parameters: parameters) {
            // manage pagination
            json in
            if let json = json {
                // this json result is pagined.
                
                // First, we process the data of the current json page
                processing(json)
                
                // Next we look to know if there is an other page
                let currentPage = json["pagination"]["start_page"].intValue
                let itemsOnPage = json["pagination"]["items_on_page"].intValue
                let itemsPerPage = json["pagination"]["items_per_page"].intValue
                let totalItems = json["pagination"]["total_result"].intValue
                
                let numberOfItemsRead = currentPage * itemsPerPage + itemsOnPage
                
                // if the number of items read is less than the total number of items, then we call the next page
                if( numberOfItemsRead < totalItems) {
                    getNavitiaSchedules(for: regionId, station: station, startPage: startPage + 1 , processing, completion)
                } else {
                    shouldComplete = true
                }
                
            }
            print(shouldComplete)
            if shouldComplete {
                completion()
            }
        }
    }
    
    // MARK: - Fetch Helpers
    
    static func getLines() -> [Line]? {
        
        return getManagedOjects()
        
    }
    
    
    static func getStations() -> [Station]? {
        return getManagedOjects()
    }
    
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
    
    
    
    static func getLine(fromId objectId: String) -> Line? {
        return getManagedObject(fromId: objectId)
    }
    
    static func getStation(fromId objectId: String) -> Station? {
        return getManagedObject(fromId: objectId)
    }
    
    private static func getManagedObject<T : NSManagedObject>(fromId objectId: String) -> T?  {
        
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
//
//    static getManagedObject<T : NSManagedObject>(fromId objectId: String) -> T?  {
//    
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    let context = appDelegate.persistentContainer.viewContext
//    
//    }
    
}

struct NavitiaArgument {
    let command : NavitiaCommand
    let argument : String?
}


enum NavitiaCommand : String {
    case region = "coverage"
    case physicalMode = "physical_modes"
    case line = "lines"
    case station = "stop_areas"
    case departure = "departures"
    case schedules = "stop_schedules"
}

enum NavitiaOption : String {
    case GeoJson = "disable_geojson"
    case startPage = "start_page"
    case itemsPerSchedules = "items_per_schedule"
}



enum NavitiaPhysicalMode : String {
    case metro = "physical_mode:Metro"
    case RER = "physical_mode:RapidTransit"
    case bus = "physical_mode:Bus"
    case tramway = "physical_mode:Tramway"
}

