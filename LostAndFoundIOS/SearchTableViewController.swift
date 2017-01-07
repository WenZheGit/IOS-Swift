//
//  SearchTableViewController.swift
//  LostAndFoundIOS
//
//  Created by Kevin on 17/05/2016.
//  Copyright © 2016 Vincent. All rights reserved.
//

import UIKit
import Firebase

class SearchTableViewController: UITableViewController, UISearchResultsUpdating{
    
    @IBOutlet var searchTable: UITableView!
    
    var properties = [Property]()
    var filterProperties = [Property]()
    var titles = [String]()
    var filterTitles = [String]()
    var resultsController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //StackOverflow -- search function in swift
        self.resultsController = UISearchController(searchResultsController: nil)
        self.resultsController.searchResultsUpdater = self
        
        self.resultsController.dimsBackgroundDuringPresentation = false
        self.resultsController.searchBar.sizeToFit()
        
        self.searchTable.tableHeaderView = resultsController.searchBar
      
        BaseService.dataService.PROPERTY_REF.observeEventType(.Value, withBlock: { snapshot in
            self.properties = []
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
                    // Make property array for the tableView.
                    if let propertyDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let property = Property(key: key, dictionary: propertyDictionary)
                        self.properties.insert(property, atIndex: 0)
                    }
                }
            }
            
            // Be sure that the tableView updates when there is new data.
            self.searchTable.reloadData()
        })
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(resultsController.active)
        {
            return filterProperties.count
        }
        else
        {
            return properties.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchCell") as? SearchTableViewCell
        if(resultsController.active)
        {
             cell!.configureCell(filterProperties[indexPath.row])
        }
        else
        {
            cell!.configureCell(properties[indexPath.row])
        }
        return cell!
    }
    
    //StackOverflow
    func filterContentForSearchText(searchText: String) {
        filterProperties = properties.filter { property in
            return property.title.lowercaseString.containsString(searchText.lowercaseString)
        }
        self.searchTable.reloadData()
    }
    
    //StackOverflow
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    //StackOverflow
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "ViewDetails":
            let controller: SearchDetailsViewController = segue.destinationViewController as! SearchDetailsViewController
            
            if(resultsController.active)
            {
                let index: Int = searchTable.indexPathForSelectedRow!.row
                controller.property = self.filterProperties[index] as? Property
            }
            else
            {
                let index: Int = searchTable.indexPathForSelectedRow!.row
                controller.property = self.properties[index] as? Property
            }
            break
        default:
            return
        }
    }
    
}
