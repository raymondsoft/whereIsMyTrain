//
//  StationListViewController.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 06/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import UIKit
import CoreData

class StationListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    var stations = [Station]() {
        didSet {
            self.stationsTableView.reloadData()
        }
    }
    
    var filteredStations = [Station]()
    
    var searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var stationsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Liste"
        
        
        self.stationsTableView.delegate = self
        self.stationsTableView.dataSource = self
        initializeSearchController()
        
        self.searchController.searchBar.barTintColor = UIColor.lightGray
        self.view.backgroundColor = UIColor.lightGray
        
        self.stationsTableView.rowHeight = UITableViewAutomaticDimension
        self.stationsTableView.estimatedRowHeight = 80
        self.stationsTableView.setNeedsLayout()
        self.stationsTableView.layoutIfNeeded()
        // Do any additional setup after loading the view.
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let stationsRequest : NSFetchRequest<Station> =  Station.fetchRequest()
        stationsRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        //        stationsRequest.sortDescriptors?.append(NSSortDescriptor(key: "name", ascending: true))
        do {
            self.stations = try context.fetch(stationsRequest)
        } catch {
            print("Error while getting Stations From CoreData")
        }
        

    }

    func initializeSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.stationsTableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchBar.scopeButtonTitles = [
            StationScope.name.rawValue ,
            StationScope.line.rawValue ,
            StationScope.address.rawValue
        ]
        self.searchController.searchBar.delegate = self
    }
    
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? StationDetailViewController {
            let selectedStationIndex = self.stationsTableView.indexPathForSelectedRow
            let stationToPass : Station
            if self.searchController.isActive && self.searchController.searchBar.text != "" {
                stationToPass = filteredStations[selectedStationIndex!.row]
            } else {
                stationToPass = stations[selectedStationIndex!.row]
            }
            destinationVC.station = stationToPass
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        self.navigationController?.setToolbarHidden(true, animated: true)
        
            }
    
    // MARK: - TABLEVIEW delegate & datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("nb stations : \(self.stations.count)")
        
        if self.searchController.isActive && self.searchController.searchBar.text != "" {
            return filteredStations.count
        } else {
            return self.stations.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var reuseIdentifier = "StationCellOdd"
        if(indexPath.row % 2 == 0){ reuseIdentifier = "StationCellEven" }
        
        let stationCell = self.stationsTableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? StationTableViewCell ?? StationTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
        
        if self.searchController.isActive && self.searchController.searchBar.text != "" {
            stationCell.build(from: filteredStations[indexPath.row])
        } else {
            stationCell.build(from: stations[indexPath.row])
        }
        
        
        return stationCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "listToDetailStation", sender: self)
    }
    

    // MARK: - SEARCH methods
    
    func filterStationsForSearchText(searchText: String, scope: String = StationScope.name.rawValue){
        filteredStations = self.stations.filter { station in
            
            let searchTerm = searchText.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            
            switch scope {
            case StationScope.name.rawValue :
//                print("NAME")
                let stationName = station.name.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
                return stationName.contains(searchTerm)
            case StationScope.line.rawValue :
//                print("LINE")
                let lines = station.lines?.allObjects as! [Line]
//                return lines.contains(where:
//                    {$0.id.lowercased().contains(searchTerm)}
                    return lines.contains(where:
                    {$0.id.lowercased() == (searchTerm)}
                )
            case StationScope.address.rawValue :
//                print("ADDRESS")
                let stationAddress = station.address.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
                return stationAddress.contains(searchTerm)
                
            default :
//                print("DEFAULT")
                // by default, we search the name of the station
                let stationName = station.name.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
                return stationName.contains(searchTerm)
            }
            
        }
        self.stationsTableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterStationsForSearchText(searchText: self.searchController.searchBar.text!, scope: scope)
    }
    
}


extension StationListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.filterStationsForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

enum StationScope : String {
    case name = "name"
    case line = "line"
    case address = "address"
}
