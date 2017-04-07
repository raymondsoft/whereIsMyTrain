//
//  StationImageHelper.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 06/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import UIKit


struct StationImageHelper {
    
    public static func getImage(from id: String) -> UIImage{
        switch id {
        case "1":
            return #imageLiteral(resourceName: "M_1")
        case "2":
            return #imageLiteral(resourceName: "M_2")
        case "3":
            return #imageLiteral(resourceName: "M_3")
        case "3B":
            return #imageLiteral(resourceName: "M_3B")
        case "4":
            return #imageLiteral(resourceName: "M_4")
        case "5":
            return #imageLiteral(resourceName: "M_5")
        case "6":
            return #imageLiteral(resourceName: "M_6")
        case "7":
            return #imageLiteral(resourceName: "M_7")
        case "7B":
            return #imageLiteral(resourceName: "M_7B")
        case "8":
            return #imageLiteral(resourceName: "M_8")
        case "9":
            return #imageLiteral(resourceName: "M_9")
        case "10":
            return #imageLiteral(resourceName: "M_10")
        case "11":
            return #imageLiteral(resourceName: "M_11")
        case "12":
            return #imageLiteral(resourceName: "M_12")
        case "13":
            return #imageLiteral(resourceName: "M_13")
        case "14":
            return #imageLiteral(resourceName: "M_14")
        default:
            return #imageLiteral(resourceName: "metro")
        }
    }
}
