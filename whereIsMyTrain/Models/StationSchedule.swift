//
//  StationSchedule.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 07/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import Foundation


struct StationSchedule {
    var lineCode : String
    var destination : String
    var departures : [Date]
    var traffic : String = "OK"
    var color : String
    var textColor : String
//    var firstDeparture : String
//    var secondDeparture : String
    
    public static func sortSchedule(schedule1 : StationSchedule , schedule2 : StationSchedule) -> Bool {
        
        let id1 = Int(schedule1.lineCode.components(separatedBy: .letters).joined())
        let id2 = Int(schedule2.lineCode.components(separatedBy: .letters).joined())
        if id1 != id2 {
            return id1! < id2!
        } else {
            return schedule1.destination < schedule2.destination
        }
    }
    
    public func isNextDepartureInLess(than minutes: Double) -> Bool {
        if let nextDeparture = departures.first {
            return nextDeparture.timeIntervalSinceNow < minutes * 60
        } else {
            return false
        }
    }
}
