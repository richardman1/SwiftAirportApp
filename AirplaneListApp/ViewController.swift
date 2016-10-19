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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredAirports.count
        }
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "airportCell", for: indexPath) as! airportCellView
        let airport: Airport
        if searchController.isActive && searchController.searchBar.text != "" {
            airport = filteredAirports[(indexPath as NSIndexPath).row]
        } else {
            airport = tableData[(indexPath as NSIndexPath).row]
        }
        cell.icaoLabel?.text = airport.icao
        cell.muniLabel?.text = airport.municipality
        return cell
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All"){
        filteredAirports = tableData.filter{ airport in
            return (airport.icao?.lowercased().contains(searchText.lowercased()))!
        }
        tableView.reloadData()
    }
    
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
