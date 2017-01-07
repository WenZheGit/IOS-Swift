//
//  LostTableViewController.swift
//  LostAndFoundIOS
//
//  Created by Kevin on 5/05/2016.
//  Copyright © 2016 Vincent. All rights reserved.
//

import UIKit
import Firebase

class LostTableViewController: UITableViewController {

    @IBOutlet var lostPropertyList: UITableView!
   
    var properties = [Property]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getLostProperties()
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
        // We are using a custom cell.
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("LostCell") as? PropertyTableViewCell {
            cell.configureCell(property)
            return cell
        } else {
            return PropertyTableViewCell()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "AddProperty":
            let controller: AddPropertyViewController = segue.destinationViewController as! AddPropertyViewController
            break
        case "ViewDetails":
            let controller: ViewPropertyViewController = segue.destinationViewController as! ViewPropertyViewController
            //controller.delegate = self
            let index: Int = lostPropertyList.indexPathForSelectedRow!.row
            controller.property = self.properties[index] as? Property
            break
        default:
            return
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool { // Return false if you do not want the specified item to be editable.
        return true
    }
    
    @IBAction func loggoutButtonTapped(sender: AnyObject) {
        var refreshAlert = UIAlertController(title: "Alert", message: "Are you sure to log out?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            BaseService.dataService.CURRENT_USER_REF.unauth()
            NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
            
            let loginPage = self.storyboard?.instantiateViewControllerWithIdentifier("loginView") as! LoginViewController
            let loginPageNav = UINavigationController(rootViewController: loginPage)
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController = loginPageNav
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            self.dismissViewControllerAnimated(true, completion: nil);
        }))
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    func getLostProperties()
    {
        BaseService.dataService.PROPERTY_REF.observeEventType(.Value, withBlock: { snapshot in
            self.properties = []
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
                    // Make lost array for the tableView.
                    if let lostDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let property = Property(key: key, dictionary: lostDictionary)
                        if(property.type == "Lost")
                        {
                            self.properties.insert(property, atIndex: 0)
                        }
                    }
                }
            }
            // Be sure that the tableView updates when there is new data.
            self.lostPropertyList.reloadData()
        })
    }
}
