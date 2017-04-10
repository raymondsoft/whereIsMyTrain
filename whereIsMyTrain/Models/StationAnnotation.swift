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
    
    init(_ station: Station) {
        self.coordinate = CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)
        self.title = station.name
        self.subtitle = station.address
        self.station = station
    }
}
