//
//  GoalListTableViewController
//  goalify
//
//  Created by Pedramrazi, Mahdi on 3/6/16.
//  Copyright © 2016 Mexo Inc. All rights reserved.
//

import UIKit


var selectedGoalIndex = 0;

class GoalListTableViewController: UITableViewController {
    
    
    @IBAction func showMainMenu(sender: AnyObject) {
        performSegueWithIdentifier("homeScreen", sender: self)
    }
    
    @IBOutlet var goalListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationStyle()
        setTableViewStyle()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    // reload data everytime the view appears
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        goalListTableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavigationStyle() {
        if let navController = navigationController {
            let navbar = navController.navigationBar;
            navbar.backgroundImageForBarMetrics(UIBarMetrics.Default)
            navbar.setBackgroundImage(UIImage(named: "bg-navigation"), forBarPosition: UIBarPosition.Top, barMetrics: UIBarMetrics.Default)
            navbar.translucent = true
            navbar.tintColor = UIColor.whiteColor()
            navbar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            navbar.barStyle = UIBarStyle.BlackTranslucent
        }
        self.title = "My Goals"
    }
    
    func setTableViewStyle() {
        /* #ececec */
        self.goalListTableView.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1.0)
        self.goalListTableView.separatorColor = UIColor.clearColor()

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
       return goalHelper.totalGoals()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel?.font =  UIFont.systemFontOfSize(17.0)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        guard let goal = goalHelper.getGoalByIndex(indexPath.section) else {
            return cell
        }
        cell.textLabel?.text = goal.title
        

        return cell
    }
    


    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // check for swipe to the left
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            // delete record
            goalHelper.deleteGoalByIndex(indexPath.section)

            // delete visual row
           // goalListTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

            goalListTableView.reloadData()
            
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        selectedGoalIndex = indexPath.section
        return indexPath
    }
    
    // before segue happens
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "homeScreen" || segue.identifier == "addGoal" {
            
            var animate = false
            // hide the navigation bar in home screen
           
            if segue.identifier == "addGoal" {
                animate = true
                if let destination = segue.destinationViewController as? AddGoalViewController {
                    destination.source = "listview"
                }
            }
            navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: animate)
            
            
        } else if segue.identifier == "showGoalDetail" {
            
            if let destination = segue.destinationViewController as? GoalDetailViewController {
                destination.goalIndex = goalListTableView.indexPathForSelectedRow?.section
            }
            
        }
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // support conditional editing of the table view.
    /*
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
