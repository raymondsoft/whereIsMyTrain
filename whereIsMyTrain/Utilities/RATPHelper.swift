//
//  RATPHelper.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 07/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import Foundation
import SwiftyJSON


struct RATPHelper {
    
    static private let baseEndPoint = "https://api-ratp.pierre-grimaud.fr/v3"
    
    private static func getRATPInfos(
        endPoint        : String,
        requestType     : RATPRequestType,
        transportType   : RATPTransportType,
        lineCode        : String,
        station         : String?,
        sens            : RATPWay?,
        _ completion    : @escaping (JSON) -> Void
        ) {
        
        var requestUrl = endPoint + "/" + requestType.rawValue + "/" + transportType.rawValue + "/" + lineCode
        if station != nil {
            let formattedStationName = station!
                .replacingOccurrences(of: " ", with: "+")
                .replacingOccurrences(of: "-", with: "+")
                .folding(options: [.diacriticInsensitive], locale: .current)
                .lowercased()
            requestUrl += "/"  + formattedStationName
            if sens != nil {
                requestUrl += "/"  + sens!.rawValue
            }
        }
        NetworkManager.sharedInstance.getInfo(endPoint: requestUrl, extensionEndPoint: nil, parameters: [:] ){ (json: JSON?, error: Error? ) in
            guard error	== nil else {
                print("error lors de la récuppération des Informations JCDecaux")
                return
            }
            if let json = json {
                completion(json)
            }
        }
        
    }
    
    public static func getRATPSchedule(station : String,line : String, way: RATPWay, _ completion : @escaping (JSON) -> Void) {
        getRATPInfos(
            endPoint        : baseEndPoint,
            requestType     : .schedules,
            transportType   : .metros,
            lineCode        : line,
            station         : station,
            sens            : way,
            completion)
    }
    
}

enum RATPWay : String {
    case aller = "A"
    case retour = "R"
}

enum RATPRequestType : String {
    case destinations = "destinations"
    case lines = "lines"
    case schedules = "schedules"
    case stations = "stations"
    case traffic = "traffic"
}

enum RATPTransportType: String {
    case rers = "rers"
    case metros = "metros"
    case bus = "bus"
    case tramways = "tramways"
    case noctiliens = "noctiliens"
}
