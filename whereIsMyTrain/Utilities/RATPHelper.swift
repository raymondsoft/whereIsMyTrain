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
    
    public static func getRATPTraffic(station : String,line : String, _ completion : @escaping (JSON) -> Void) {
        getRATPInfos(
            endPoint        : baseEndPoint,
            requestType     : .traffic,
            transportType   : .metros,
            lineCode        : line,
            station         : nil,
            sens            : nil,
            completion)
    }
    
    
    public static func getLineColor(from id: String) -> UIColor{
        switch id {
        case "1":
            return UIColor(rgbHex: 0xFFCD00)
        case "2":
            return UIColor(rgbHex: 0x003CA6)
        case "3":
            return UIColor(rgbHex: 0x837902)
        case "3B":
            return UIColor(rgbHex: 0x6EC4E8)
        case "4":
            return UIColor(rgbHex: 0xCF009E)
        case "5":
            return UIColor(rgbHex: 0xFF7E2E)
        case "6":
            return UIColor(rgbHex: 0x6ECA97)
        case "7":
            return UIColor(rgbHex: 0xFA9ABA)
        case "7B":
            return UIColor(rgbHex: 0x6ECA97)
        case "8":
            return UIColor(rgbHex: 0xE19BDF)
        case "9":
            return UIColor(rgbHex: 0xB6BD00)
        case "10":
            return UIColor(rgbHex: 0xC9910D)
        case "11":
            return UIColor(rgbHex: 0x704B1C)
        case "12":
            return UIColor(rgbHex: 0x007852)
        case "13":
            return UIColor(rgbHex: 0x6EC4E8)
        case "14":
            return UIColor(rgbHex: 0x62259D)
        default:
            return UIColor(rgbHex: 0x000000)
        }
    }
    
    
    
    public static func getLineInnerColor(from id: String) -> UIColor{
        switch id {
        case "1":
            return UIColor(rgbHex: 0x000000)
        case "2":
            return UIColor(rgbHex: 0xFFFFFF)
        case "3":
            return UIColor(rgbHex: 0xFFFFFF)
        case "3B":
            return UIColor(rgbHex: 0x000000)
        case "4":
            return UIColor(rgbHex: 0xFFFFFF)
        case "5":
            return UIColor(rgbHex: 0x000000)
        case "6":
            return UIColor(rgbHex: 0x000000)
        case "7":
            return UIColor(rgbHex: 0x000000)
        case "7B":
            return UIColor(rgbHex: 0x000000)
        case "8":
            return UIColor(rgbHex: 0x000000)
        case "9":
            return UIColor(rgbHex: 0x000000)
        case "10":
            return UIColor(rgbHex: 0x000000)
        case "11":
            return UIColor(rgbHex: 0xFFFFFF)
        case "12":
            return UIColor(rgbHex: 0xFFFFFF)
        case "13":
            return UIColor(rgbHex: 0x000000)
        case "14":
            return UIColor(rgbHex: 0xFFFFFF)
        default:
            return UIColor(rgbHex: 0xFFFFFF)
        }
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
