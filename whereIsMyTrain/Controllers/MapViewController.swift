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

class MapViewController: UIViewController , CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var stations = [Station]()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Map"
        
        self.mapView.delegate = self
        requestLocationAccess()
        
        // Do any additional setup after loading the view.
        
        self.initUserLocation()
        self.mapView.showsUserLocation = true
        
        readStation()
        
        centerView(at: self.locationManager.location!, radius: 0.1)
        self.locationManager.stopUpdatingLocation()
        
        addStationsAnnotations()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    
    func initUserLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
        self.mapView.showsUserLocation = true
        locationManager.startUpdatingLocation()
    }
    
    func centerView(at location: CLLocation, radius: Double) {
        print("CenterView")
        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: radius, longitudeDelta: radius))
        self.mapView.setRegion(region, animated: true)
    }
    
    
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? StationDetailViewController {
            if let selectedAnnotation = self.mapView.selectedAnnotations.first as? StationAnnotation {
                destinationVC.station = selectedAnnotation.station
        }
        }
    }
    
    
    // MARK: - ANNOTATIONS
    
    func addStationsAnnotations() {
        for station in stations {
            addStationAnnotation(station)
        }
    }
    
    func addStationAnnotation(_ station: Station) {
        let stationAnnotation = StationAnnotation(station)
        self.mapView.addAnnotation(stationAnnotation)
    
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is StationAnnotation {
            let annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "stationAnnotation") ?? MKAnnotationView(annotation: annotation, reuseIdentifier: "stationAnnotation")
            annotationView.image = #imageLiteral(resourceName: "metro").resizeImage(newWidth: 15)
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .infoLight) as UIView
            return annotationView
        } else {
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            performSegue(withIdentifier: "MapToDetailStation", sender: self)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? StationAnnotation {
            print("station : \(annotation.title)")
            view.image = #imageLiteral(resourceName: "metro").maskWithColor(color: UIColor.red)?.resizeImage(newWidth: 20)
            self.mapView.setCenter(
                CLLocationCoordinate2D(
                    latitude : annotation.station.latitude,
                    longitude: annotation.station.longitude),
                animated: true)
            drawLines(for: annotation.station)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let annotation = view.annotation as? StationAnnotation {
            print("station : \(annotation.title)")
            view.image = #imageLiteral(resourceName: "metro").resizeImage(newWidth: 15)
        }
        self.mapView.removeOverlays(self.mapView.overlays)
    }
    
    func drawLines(for station: Station){
        let slugStationName = station.name
            .replacingOccurrences(of: " ", with: "+")
            .replacingOccurrences(of: "-", with: "+")
            .folding(options: [.diacriticInsensitive], locale: .current)
            .lowercased()
        
        
        let lines = station.lines?.allObjects as! [Line]
        for line in lines {
            var stationOrdered = [Station]()
            RATPHelper.getRATPStations(for: line) {
                json in
                let stations = json["result"]["stations"].arrayValue
                for stationJson in stations {
                    if let index = self.stations.index(where: {$0.slugName == stationJson["slug"].stringValue}) {
                        stationOrdered.append(self.stations[index])
                    }
                }
                print("Draw Line \(line.id)")
                self.drawLine(from: stationOrdered, line: line)
            }
        }
        
        print(slugStationName)
    }
    
    func drawLine(from stations : [Station], line : Line) {
        var mapPoints = [MKMapPoint]()
        for station in stations {
                mapPoints.append(
                    MKMapPointForCoordinate(CLLocationCoordinate2D(
                        latitude: station.latitude,
                        longitude: station.longitude)
                ))
        }
//        let polyLine = MKPolyline(points: mapPoints, count: mapPoints.count)
        let polyLine = RATPPolyline(points: mapPoints, count: mapPoints.count)
        polyLine.line = line
        print("ADD Polyline et \(mapPoints.count)")
        self.mapView.add(polyLine)
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print("Renderrer For !!")
        if overlay is RATPPolyline {
            let ratpPolyline = overlay as! RATPPolyline
            print("Polyline !!")
            let polylinerenderer = MKPolylineRenderer(overlay: overlay)
            if let line = ratpPolyline.line {
                polylinerenderer.strokeColor = RATPHelper.getLineColor(from: line.id)
                polylinerenderer.lineWidth = 4
            } else {
                polylinerenderer.strokeColor = UIColor.black
            }
            return polylinerenderer
        } else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    // MARK: - CoreData Methods
    
    
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
//                station.printDescription()
                self.stations.append(station)
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
