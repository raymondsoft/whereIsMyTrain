//
//  StationDetailViewController.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 07/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import UIKit

class StationDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var scheduleTableView: UITableView!
    
    var stationSchedules  = [StationSchedule]() {
        didSet {
            self.stationSchedules = self.stationSchedules.sorted(by: StationSchedule.sortSchedule  )//{$0.lineCode < $1.lineCode})
        }
    }
     /*
    var refreshState = [String : Bool]() {
        didSet {
            var refreshing = false
            for refreshingState in refreshState.values {
                refreshing = refreshing || refreshingState
                //                print("\t \(key) \(refreshingState)")
            }
            self.isRefreshing = refreshing
        }
    }
    var isRefreshing = false {
        didSet {
            if (oldValue && !isRefreshing) {
                self.scheduleTableView.refreshControl?.endRefreshing()
                //                print("END")
            }
            if(!oldValue && isRefreshing) {
                self.scheduleTableView.refreshControl?.beginRefreshing()
                //                print("START")
            }
            //            print("\(oldValue) \(isRefreshing)")
        }
    }
 */
    
    // station given by the segue
    var station : Station!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scheduleTableView.delegate = self
        self.scheduleTableView.dataSource = self
        self.scheduleTableView.allowsSelection = false
        
        self.scheduleTableView.estimatedRowHeight = 68
        self.scheduleTableView.rowHeight = UITableViewAutomaticDimension
        
        self.scheduleTableView.setNeedsLayout()
        self.scheduleTableView.layoutIfNeeded()
        
        self.scheduleTableView.refreshControl = UIRefreshControl()
        self.scheduleTableView.refreshControl?.addTarget(self, action: #selector(StationDetailViewController.buildSchedules), for: UIControlEvents.valueChanged)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        //        print(self.station.description)
        
        self.title = self.station.name
        
        buildSchedules()
        /*
         var lines = station.lines?.allObjects as! [Line]
         lines = lines.sorted(by: Line.sortLine)
         print("line n° : \(lines[0].id)")
         
         RATPHelper.getRATPSchedule(station: self.station.name, line: lines[0].id, way: .aller) {
         json in
         print(json)
         }
         */
    }
    
    func buildSchedules() {
        
        //        self.scheduleTableView.refreshControl?.beginRefreshing()
        
        self.stationSchedules.removeAll()
        self.scheduleTableView.reloadData()
        self.scheduleTableView.refreshControl?.beginRefreshing()
        NavitiaHelper.getNavitiaSchedules(for: "fr-idf", station: station, {
            json in
            if let json = json {
                for jsonSchedule in json["stop_schedules"].arrayValue {
                    let lineCode        = jsonSchedule["display_informations"]["code"].stringValue
                    let destination     = jsonSchedule["display_informations"]["direction"].stringValue
                    let color           = jsonSchedule["display_informations"]["color"].stringValue
                    let textColor       = jsonSchedule["display_informations"]["text_color"].stringValue
                    let traffic         = "OK"
                    let departuresJson = jsonSchedule["date_times"].arrayValue
                    var departuresString = [String]()
                    for departureJson in departuresJson {
                        departuresString.append(departureJson["date_time"].stringValue)
                    }
                    
                    var departures = [Date]()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyyMMdd'T'HHmmSS"
                    for dateString in departuresString {
                        if let formattedDate = dateFormatter.date(from: dateString) {
                            departures.append(formattedDate)
                        }
                    }
                    let schedule = StationSchedule(lineCode: lineCode, destination: destination, departures: departures, traffic: traffic, color: color, textColor: textColor)
                    if schedule.isNextDepartureInLess(than: 60) {
                        self.stationSchedules.append(schedule)
                    }
                }
                
            }
        }) {
            
            self.scheduleTableView.reloadData()
            self.scheduleTableView.refreshControl?.endRefreshing()}
        /*
         var lines = station.lines?.allObjects as! [Line]
         lines = lines.sorted(by: Line.sortLine)
         self.initializeRefreshDict(from: self.station, lines: lines)
         for line in lines {
         buildSchedule(lineId: line.id)
         }
         */
        //        self.stationSchedules.sort(by: {$0.lineCode < $1.lineCode})
        //        self.scheduleTableView.refreshControl?.endRefreshing()
    }
    /*
    func initializeRefreshDict(from station: Station, lines : [Line]) {
        for line in lines {
            let refreshKeyA = self.station.name + line.id + RATPWay.aller.rawValue
            self.refreshState[refreshKeyA] = true
            let refreshKeyR = self.station.name + line.id + RATPWay.retour.rawValue
            self.refreshState[refreshKeyR] = true
            
        }
    }
 */
    /*
     func buildSchedule(lineId : String) {
     //        print("Calcul de la ligne n° \(lineId)")
     RATPHelper.getRATPSchedule(station: self.station.name, line: lineId, way: .aller) {
     json in
     let refreshKey = self.station.name + lineId + RATPWay.aller.rawValue
     if let json = json {
     //            self.refreshState[refreshKey] = true
     
     let departuresJson = json["result"]["schedules"].arrayValue
     
     let destination = departuresJson[0]["destination"].stringValue
     
     var departures = [String]()
     for departureJson in departuresJson {
     departures.append(departureJson["message"].stringValue)
     
     }
     
     RATPHelper.getRATPTraffic(station: self.station.name, line: lineId) {
     json in
     if let json = json {
     let traffic = json["result"]["title"].stringValue
     self.stationSchedules.append(StationSchedule(lineCode: lineId, destination: destination, departures: departures, traffic: traffic))
     }
     
     }
     }
     self.refreshState[refreshKey] = false
     }
     
     
     RATPHelper.getRATPSchedule(station: self.station.name, line: lineId, way: .retour) {
     json in
     let refreshKey = self.station.name + lineId + RATPWay.retour.rawValue
     if let json = json {
     //            self.refreshState[refreshKey] = true
     
     let departuresJson = json["result"]["schedules"].arrayValue
     
     let destination = departuresJson[0]["destination"].stringValue
     
     var departures = [String]()
     for departureJson in departuresJson {
     departures.append(departureJson["message"].stringValue)
     //                print(departureJson["message"].stringValue)
     }
     
     RATPHelper.getRATPTraffic(station: self.station.name, line: lineId) {
     json in
     if let json = json {
     let traffic = json["result"]["title"].stringValue
     self.stationSchedules.append(StationSchedule(lineCode: lineId, destination: destination, departures: departures, traffic: traffic))
     }
     }
     }
     self.refreshState[refreshKey] = false
     }
     
     
     }
     */
    
    // MARK: - TABLEVIEW methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count : \(self.stationSchedules.count)")
        return self.stationSchedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        let reuseIdentifier = "StationScheduleCell"
        let reuseIdentifier = "StationScheduleCellAlternative"
        
        let scheduleCell = self.scheduleTableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? StationScheduleTableViewCell ?? StationScheduleTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
        
        scheduleCell.build(from: self.stationSchedules[indexPath.row])
        return scheduleCell
    }
    
}
