//
//  StationDetailViewController.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 07/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import UIKit

class StationDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var stationNameLabel: UILabel!
    
    @IBOutlet weak var scheduleTableView: UITableView!
    
    var stationSchedules  = [StationSchedule]() {
        didSet {
            self.stationSchedules = self.stationSchedules.sorted(by: StationSchedule.sortSchedule)
            self.scheduleTableView.reloadData()
        }
    }
    
    // station given by the segue
    var station : Station!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scheduleTableView.delegate = self
        self.scheduleTableView.dataSource = self
        self.scheduleTableView.estimatedRowHeight = 68
        self.scheduleTableView.rowHeight = UITableViewAutomaticDimension
        
        self.scheduleTableView.setNeedsLayout()
        self.scheduleTableView.layoutIfNeeded()
        
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
        print(self.station.description)
        
        self.stationNameLabel.text = self.station.name
        
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
        
        var lines = station.lines?.allObjects as! [Line]
        lines = lines.sorted(by: Line.sortLine)
        for line in lines {
            buildSchedules(lineId: line.id)
        }
//        self.stationSchedules.sort(by: {$0.lineCode < $1.lineCode})
    }
    
    func buildSchedules(lineId : String) {
        print("Calcul de la ligne n° \(lineId)")
        RATPHelper.getRATPSchedule(station: self.station.name, line: lineId, way: .aller) {
            json in
            let departuresJson = json["result"]["schedules"].arrayValue
            
            let destination = departuresJson[0]["destination"].stringValue
            
            var departures = [String]()
            for departureJson in departuresJson {
                departures.append(departureJson["message"].stringValue)
            }
            
            self.stationSchedules.append(StationSchedule(lineCode: lineId, destination: destination, departures: departures))
        }
        RATPHelper.getRATPSchedule(station: self.station.name, line: lineId, way: .retour) {
            json in
            let departuresJson = json["result"]["schedules"].arrayValue
            
            let destination = departuresJson[0]["destination"].stringValue
            
            var departures = [String]()
            for departureJson in departuresJson {
                departures.append(departureJson["message"].stringValue)
                print(departureJson["message"].stringValue)
            }
            
            self.stationSchedules.append(StationSchedule(lineCode: lineId, destination: destination, departures: departures))
        }
        
        
    }
    
    // MARK: - TABLEVIEW methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stationSchedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = "StationScheduleCell"
        let scheduleCell = self.scheduleTableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? StationScheduleTableViewCell ?? StationScheduleTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
        
        scheduleCell.build(from: self.stationSchedules[indexPath.row])
        
        return scheduleCell
    }
    
    
}
