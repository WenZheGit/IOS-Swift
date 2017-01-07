//
//  FoundTableViewController.swift
//  LostAndFoundIOS
//
//  Created by Kevin on 18/05/2016.
//  Copyright © 2016 Vincent. All rights reserved.
//

import UIKit
import Firebase

class FoundTableViewController: UITableViewController {

    @IBOutlet var foundPropertyList: UITableView!
    var properties = [Property]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getFoundProperties()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return properties.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let property = properties[indexPath.row]
               
        if let cell = tableView.dequeueReusableCellWithIdentifier("FoundCell") as? FoundTableViewCell {
            cell.configureCell(property)
            return cell
        } else {
            return FoundTableViewCell()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "ViewDetails":
            let controller: FoundDetailsViewController = segue.destinationViewController as! FoundDetailsViewController
            let index: Int = foundPropertyList.indexPathForSelectedRow!.row
            controller.property = self.properties[index] as? Property
            break
        default:
            return
        }
    }
    
    func getFoundProperties()
    {
        BaseService.dataService.PROPERTY_REF.observeEventType(.Value, withBlock: { snapshot in
            self.properties = []
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
                    // Make property array for the tableView.
                    if let propertyDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let property = Property(key: key, dictionary: propertyDictionary)
                        // Items are returned chronologically, but it's more fun with the newest losts first.
                        if(property.type == "Found")
                        {
                            self.properties.insert(property, atIndex: 0)
                        }
                    }
                }
            }
            // Make sure that the tableView updates when there is new data.
            self.foundPropertyList.reloadData()
        })
    }
}
