//
//  NavitiaHelper.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 13/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import Foundation
import SwiftyJSON

struct NavitiaHelper {
    
    static private let baseEndPoint = "https://api.navitia.io/v1/"
    static private let user = "ead72df8-7e1a-4ecf-a325-3e779f5326fd"
    static private let password = ""
    
    private static func getNavitiaInfo(extensionParameters extensionParametersList : [NavitiaArgument], parameters : [String:String], _ completion    : @escaping (JSON?) -> Void){
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
                print("error lors de la récuppération des Informations JCDecaux")
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
    
    static func getNavitiaLines(for regionId : String, transportMode : NavitiaPhysicalMode, _ completion : @escaping (JSON?) -> Void) {
//        let extensionParameters : [NavitiaCommand : String?] = [
//            NavitiaCommand.region : regionId,
//            NavitiaCommand.line : nil
//        ]
        let extensionParameters = [
            NavitiaArgument(command: NavitiaCommand.region, argument: regionId),
            NavitiaArgument(command: NavitiaCommand.physicalMode, argument: transportMode.rawValue),
            NavitiaArgument(command: NavitiaCommand.line, argument: nil)
        ]
        getNavitiaInfo(extensionParameters: extensionParameters, parameters: [:], completion)
        
    }
    
    static func getNavitiaStation(for regionId : String, line : Line, _ completion : @escaping (JSON?) -> Void) {
        let extensionParameters = [
            NavitiaArgument(command: .region, argument: regionId),
            NavitiaArgument(command: .physicalMode, argument: line.physicalMode),
            NavitiaArgument(command: .line, argument: line.id),
            NavitiaArgument(command: .station, argument: nil)
            
        ]
        getNavitiaInfo(extensionParameters: extensionParameters, parameters: [NavitiaOption.GeoJson.rawValue:"true"], completion)
    }
    
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
}

enum NavitiaOption : String {
    case GeoJson = "disable_geojson"
}



enum NavitiaPhysicalMode : String {
    case metro = "physical_mode:Metro"
    case RER = "physical_mode:RapidTransit"
    case bus = "physical_mode:Bus"
    case tramway = "physical_mode:Tramway"
}

