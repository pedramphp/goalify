//
//  GoalDetailViewController.swift
//  goalify
//
//  Created by Pedramrazi, Mahdi on 3/6/16.
//  Copyright © 2016 Mexo Inc. All rights reserved.
//

import UIKit

class GoalDetailViewController: UIViewController {
    
    var goalIndex: Int!
    var goal: Goal?
    
    @IBOutlet weak var descText: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var line: UIImageView!
    
    @IBOutlet weak var box: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewStyles()
        updateView()
        // Do any additional setup after loading the view.
    }
    
    
    // disable orientation
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        updateView()

    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setViewStyles() {
        // set background color
        view.layer.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1.0).CGColor /* #ececec */
        box.layer.borderWidth = 1
        box.layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0).CGColor /* #cccccc */
        
        // bottom shadow
        box.layer.shadowColor = UIColor.grayColor().CGColor
        box.layer.shadowOffset = CGSizeMake(0, 1.0)
        box.layer.shadowRadius = 0.4
        box.layer.shadowOpacity = 0.2
        
        //line - create 1px border
        line.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1.0) /* #ececec */
        
        
        
        self.navigationController?.navigationBar.topItem?.title = "Close"
        let edit = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "editTapped")
        self.navigationItem.rightBarButtonItems = [edit]
        
        //self.navigationController?.navigationBar.topItem?.leftBarButtonItem?.style = UIBarButtonItemStyle.Plain
        //self.navigationController?.navigationBar.topItem?.hidesBackButton = true
        //self.navigationController?.navigationBar.topItem?.backBarButtonItem = nil
        
        // self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Close", style: .Plain, target: nil, action: "navigate")
    }
    
    func editTapped() {
        performSegueWithIdentifier("showEditFlow", sender: self)
    }
    
    func updateView() {
        let index = goalIndex ?? 0
        
        goal = goalHelper.getGoalByIndex(index)
        
        if let goal = goal {
            
            titleLabel.text = goal.title
            self.title = goal.title
            
            if goal.desc == ""{
                descText.hidden = true
                descLabel.hidden = true
            } else  {
                descText.text = goal.desc
            }
            
        }
    }
    
    // before segue happens
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showEditFlow" {
            if let destination = segue.destinationViewController as? AddGoalViewController {
                destination.mode = "EDIT"
                destination.goalIndex = goalIndex
                // hide the default navigation bar
                navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: true)
                
            }
        }
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
