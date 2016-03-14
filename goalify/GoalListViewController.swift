//
//  GoalListViewController.swift
//  goalify
//
//  Created by Pedramrazi, Mahdi on 3/6/16.
//  Copyright © 2016 Mexo Inc. All rights reserved.
//

import UIKit

//var selectedGoalIndex = 0;
class GoalListViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var goalListTable: UITableView!
    // link it from the cell
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }
    
    // reload data everytime the view appears
    override func viewDidAppear(animated: Bool) {
//        goalListTable.reload
       goalListTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return goalHelper.goals.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = goalHelper.goals[indexPath.row].title
        
        return cell
        
    }
    
    // Edit item in the table
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        // check for swipe to the left
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            goalHelper.goals.removeAtIndex(indexPath.row)
            
            goalListTable.reloadData()
        }
        
    }
    
    
    // onSelect
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedGoalIndex = indexPath.row
        return indexPath
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
