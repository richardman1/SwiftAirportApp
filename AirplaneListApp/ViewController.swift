//
//  ViewController.swift
//  AirplaneListApp
///Users/twoerdem/Downloads/track-3-sqlite/track-3-sqlite/Bridging-Header.h
//  Created by Thomas Woerdeman on 15/09/16.
//  Copyright © 2016 FraTho. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!

    var tableData = [Airport]();
    var filteredAirports = [Airport]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let adbh = AirplaneDatabaseHelper();
        self.tableData = adbh.getInfoWithISOCountry("NL")!;
        
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredAirports.count
        }
        return tableData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("airportCell", forIndexPath: indexPath) as! airportCellView
        let airport: Airport
        if searchController.active && searchController.searchBar.text != "" {
            airport = filteredAirports[indexPath.row]
        } else {
            airport = tableData[indexPath.row]
        }
        cell.icaoLabel?.text = airport.icao
        cell.muniLabel?.text = airport.municipality
        return cell
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All"){
        filteredAirports = tableData.filter{ airport in
            return (airport.icao?.lowercaseString.containsString(searchText.lowercaseString))!
        }
        tableView.reloadData()
    }
    
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}