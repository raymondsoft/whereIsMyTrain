//
//  StationAnnotation.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 10/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import UIKit
import MapKit

class StationAnnotation: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    
    var title: String?
    
    var subtitle: String?
    
    var station: Station
    
    var color: UIColor 
    
    init(_ station: Station) {
        self.coordinate = CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)
        self.title = station.name
        self.subtitle = station.address
        self.station = station
        
        self.color = UIColor.black
        
        super.init()
        self.computeColor()
    }
    
    func computeColor(){
        
        switch station.distanceToUser {
        case 0.0 ..< 1000.0:
            let newColor = UIColor(rgbHex: 0x0DA308)
            if !(self.color == newColor) {
                self.color = newColor
            }
        case 1000.0 ... 2000.0:
            if !(self.color == UIColor.orange) {
                self.color = UIColor.orange
            }
        default:
            if !(self.color == UIColor.black) {
                self.color = UIColor.black
            }
            
        }
    }
}
