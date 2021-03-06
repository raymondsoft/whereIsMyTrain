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
    
    @IBOutlet weak var transportModeSegmentedControl: UISegmentedControl!
    
    var stations = [Station]()
    
    var lines = [Line]()
    
    let locationManager = CLLocationManager()
    
    var transportMode = NavitiaPhysicalMode.metro {
        didSet {
            self.addStationsAnnotations()
        }
    }
    
    private var myContext = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Map"
        
        self.mapView.delegate = self
        requestLocationAccess()
        
        // Do any additional setup after loading the view.
        
        self.initUserLocation()
        self.mapView.showsUserLocation = true
        
        //        readStation()
        readNavitiaLines()
        //        drawNavitiaLines(transportMode: NavitiaPhysicalMode.metro)
        if let stations = NavitiaHelper.getStations() {
            self.stations = stations
            print("Station ok")
        }
        
        centerView(at: self.locationManager.location!, radius: 0.1)
        
        addStationsAnnotations()
    }
    
    @IBAction func transportModeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            // Metro
            self.transportMode = .metro
            //            self.mapView.overlays.forEach({self.mapView.remove($0)})
        //            self.drawNavitiaLines(transportMode: .metro)
        case 1:
            // RER
            self.transportMode = .RER
            //            self.mapView.overlays.forEach({self.mapView.remove($0)})
        //            self.drawNavitiaLines(transportMode: .RER)
        case 2:
            // Tram
            self.transportMode = .tramway
            //            self.mapView.overlays.forEach({self.mapView.remove($0)})
        //            self.drawNavitiaLines(transportMode: .tramway)
        case 3:
            self.transportMode = .bus
        default:
            // Metro
            self.transportMode = .metro
            //            self.mapView.overlays.forEach({self.mapView.remove($0)})
            //            self.drawNavitiaLines(transportMode: .metro)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Location Methods
    
    func initUserLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
        self.mapView.showsUserLocation = true
        locationManager.startUpdatingLocation()
    }
    
    func centerView(at location: CLLocation, radius: Double) {
        //        print("CenterView")
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            self.stations.forEach({$0.computeDistanceToUser(from : lastLocation)})
            refreshAnnotation()
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
        self.mapView.annotations.forEach({self.mapView.removeAnnotation($0)})
        for station in stations {
            if station.has(transportMode: self.transportMode.rawValue) {
                addStationAnnotation(station)
            }
        }
    }
    
    func addStationAnnotation(_ station: Station) {
        let stationAnnotation = StationAnnotation(station)
        
        self.addObserver(self, forKeyPath: #keyPath(StationAnnotation.color), options: .new, context: &myContext)
        self.mapView.addAnnotation(stationAnnotation)
        
    }
    
    func refreshAnnotation() {
        for annotation in self.mapView.annotations {
            if let annotation = annotation as? StationAnnotation {
                annotation.computeColor()
                let annotationView = self.mapView.view(for: annotation)
                annotationView?.image = annotationView?.image?.maskWithColor(color: annotation.color)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? StationAnnotation {
            let annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "stationAnnotation") ?? MKAnnotationView(annotation: annotation, reuseIdentifier: "stationAnnotation")
            annotationView.image = #imageLiteral(resourceName: "metro").resizeImage(newWidth: 15)
            annotationView.image = annotationView.image?.maskWithColor(color: annotation.color)
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
            //            print("station : \(annotation.title)")
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
            //            print("station : \(annotation.title)")
            view.image = #imageLiteral(resourceName: "metro").resizeImage(newWidth: 15).maskWithColor(color: annotation.color)
        }
        self.mapView.removeOverlays(self.mapView.overlays)
    }
    
    func drawLines(for station: Station){
        
        let lines = station.lines?.allObjects as! [Line]
        for line in lines {
            drawNavitiaLine(line: line)
//            var stationOrdered = [Station]()
//            RATPHelper.getRATPStations(for: line) {
//                json in
//                if let json = json {
//                    let stations = json["result"]["stations"].arrayValue
//                    for stationJson in stations {
//                        if let index = self.stations.index(where: {$0.slugName == stationJson["slug"].stringValue}) {
//                            stationOrdered.append(self.stations[index])
//                        }
//                    }
//                    //                print("Draw Line \(line.id)")
//                    self.drawLine(from: stationOrdered, line: line)
//                }
//            }
        }
        
    }
    
    
    func drawNavitiaLines(transportMode : NavitiaPhysicalMode){
        for line in self.lines {
            //            print("line n° \(line.code)")
            if line.physicalMode == transportMode.rawValue {
                drawNavitiaLine(line: line)
            }
        }
    }
    
    
    func drawNavitiaLine(line : Line)
    {
        print("Draw Line \(line.code). Color : \(line.color)")
        if let routes = line.routes?.allObjects as? [Route]{
            print("\t nb routes : ")
            for route in routes {
                
                drawNavitiaRoute(route, color: UIColor(hexString: line.color))
            }
        }
    }
    func drawNavitiaRoute(_ route : Route, color : UIColor) {
        //        print("\t drawNavitiaRoute")
        var mapPoints = [MKMapPoint]()
        if let routePoints = route.routePoints?.allObjects as? [RoutePoint] {
            let routePointsSorted = routePoints.sorted(by: {$0.index < $1.index})
            for routePoint in routePointsSorted {
                //                routePoint.describe()
                mapPoints.append(
                    MKMapPointForCoordinate(CLLocationCoordinate2D(
                        latitude: routePoint.latitude,
                        longitude: routePoint.longitude)
                ))
            }
        }
        let polyline = NavitiaRoutePolyline(points: mapPoints, count: mapPoints.count)
        polyline.color = color
        self.mapView.add(polyline)
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
        //        print("ADD Polyline et \(mapPoints.count)")
        self.mapView.add(polyLine)
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        //        print("Renderrer For !!")
        if overlay is RATPPolyline {
            let ratpPolyline = overlay as! RATPPolyline
            //            print("Polyline !!")
            let polylinerenderer = MKPolylineRenderer(overlay: overlay)
            if let line = ratpPolyline.line {
                polylinerenderer.strokeColor = RATPHelper.getLineColor(from: line.id)
                polylinerenderer.lineWidth = 4
            } else {
                polylinerenderer.strokeColor = UIColor.black
            }
            return polylinerenderer
        } else {
            
            if overlay is NavitiaRoutePolyline {
                let navitiaPolyline = overlay as! NavitiaRoutePolyline
                let polylineRenderer = MKPolylineRenderer(overlay: navitiaPolyline)
                polylineRenderer.strokeColor = navitiaPolyline.color
                polylineRenderer.lineWidth = 4
                return polylineRenderer
            } else {
                
                return MKOverlayRenderer(overlay: overlay)
            }
        }
    }
    
    
    // MARK: - Observer
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &myContext {
            let newValue = change?[.newKey]
            print("Color Changed : \(newValue)")
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    
    // MARK: - CoreData Methods
    
    
    //    func readLines() {
    //
    //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //        let context = appDelegate.persistentContainer.viewContext
    //
    //        var compteur = 0
    //        do {
    //            let lines = try context.fetch(Line.fetchRequest()) as? [Line]
    //            for line in lines! {
    //                print("cpt: \(compteur) n° ligne : \(line.id)")
    //                compteur = compteur + 1
    //            }
    //        }
    //        catch {
    //            print("Error While getting Lines from Core Data")
    //        }
    //
    //    }
    //
    
    func readStation() {
        //        print("readStation")
        
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
    
    func readNavitiaLines() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let lines = try context.fetch(Line.fetchRequest()) as? [Line]
            for line in lines! {
                //                station.printDescription()
                self.lines.append(line)
            }
            print("nb lines : \(self.lines.count)")
        }
        catch {
            print("Error While getting stations from Core Data")
        }
    }
    
    //
    //    func readStationsFromJson() {
    //        print("readStationsFromJson")
    //
    //
    //        do {
    //            let stationsJsonUrl = Bundle.main.url(forResource: "metros", withExtension: "json")
    //            let stationsJson = try JSON(data: Data(contentsOf: stationsJsonUrl!))
    //            print(stationsJson)
    //
    //
    //            let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //            let context = appDelegate.persistentContainer.viewContext
    //
    //            for stationJson in stationsJson["result"].arrayValue {
    //                let station = Station(context: context, station: stationJson)
    //                station.printDescription()
    //            }
    //
    //            appDelegate.saveContext()
    //
    //        }
    //        catch {
    //            print("Error while getting stations")
    //        }
    //    }
    
    
    //    func deleteAll() {
    //
    //        let entitiesToDelete = ["station", "line"]
    //
    //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //        let context = appDelegate.persistentContainer.viewContext
    //
    //        for entityToDelete in entitiesToDelete {
    //            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityToDelete)
    //            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    //            do {
    //                try context.execute(deleteRequest)
    //                print("\(entityToDelete) deleted")
    //            } catch {
    //                print("Error while deleting \(entityToDelete)")
    //            }
    //
    //        }
    //
    //        do {
    //            try context.save()
    //        } catch {
    //            print("Error while saving context")
    //        }
    //        /*
    //        //        let fetch : NSFetchRequest<Station> = Station.fetchRequest()
    //        let requestStation = NSBatchDeleteRequest(fetchRequest: Station.fetchRequest())
    //        do {
    //            try context.execute(requestStation)
    //            print("Stations deleted")
    //        } catch {
    //            print("Error while deleting Stations")
    //        }
    //
    //
    //
    //
    //        let requestLine = NSBatchDeleteRequest(fetchRequest: Line.fetchRequest())
    //        do {
    //            try context.execute(requestLine)
    //            print("Lines deleted")
    //        } catch {
    //            print("Error while deleting Lines")
    //        }
    // */
    //    }
    
    
    
}
