//
//  ViewController.swift
//  goalify
//
//  Created by Pedramrazi, Mahdi on 3/6/16.
//  Copyright © 2016 Mexo Inc. All rights reserved.
//

import UIKit
import CoreData

var goalHelper = GoalHelper()
var randomGoal: Goal?

class ViewController: UIViewController/*, UITextFieldDelegate */{
    
    @IBOutlet weak var addGoal: UIButton!
    
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var noGoalLabel: UILabel!
    
    @IBOutlet weak var grayBox: UIImageView!
    @IBOutlet weak var goalOfDayLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    
    @IBOutlet weak var viewAllGoals: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
    }
    
    // disable orientation
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationStyle()
        
        randomGoal = goalHelper.getChosenGoal()
        
        addStarStyles()
        addAddGoalButtonStyles()
        addGrayBoxStyles()
        grayBox.userInteractionEnabled = true
        grayBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onGrayBoxTap"))
        
        renderView()

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
    
    func onGrayBoxTap() {
         performSegueWithIdentifier("showDetail", sender: self)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addStarStyles(){
        starLabel.font = UIFont(name: "mygoals", size: 95)
        starLabel.text = "\u{e903}"
    }
    
    func addAddGoalButtonStyles(){
        // backgrounc color and border
        addGoal.backgroundColor = UIColor.clearColor()
        addGoal.layer.cornerRadius = 25
        addGoal.layer.borderWidth = 1
        addGoal.layer.borderColor = UIColor.whiteColor().CGColor
        
        // add icon next to text in the button
        let buttonStringAttributed = NSMutableAttributedString(string: "\u{e902} Add a Goal")
        buttonStringAttributed.addAttribute(NSFontAttributeName, value: UIFont(name: "mygoals", size: 20)!, range: NSRange(location: 0,length: 1))
        
        addGoal.titleLabel?.numberOfLines = 1
        addGoal.setAttributedTitle(buttonStringAttributed, forState: .Normal)
    }
    
    func addGrayBoxStyles() {
        grayBox.layer.cornerRadius = 10
        
    }
    
    func renderView(){

        
        if let randomGoal = randomGoal {
            grayBox.hidden = false
            goalOfDayLabel.hidden = false
            goalLabel.hidden = false
            viewAllGoals.hidden = false
            goalLabel.text = "\"\(randomGoal.title)\""
            
            starLabel.hidden = true
            noGoalLabel.hidden = true
        } else {
            noGoalLabel.hidden = false
            starLabel.hidden = false
            
            grayBox.hidden = true
            goalOfDayLabel.hidden = true
            goalLabel.hidden = true
            noGoalLabel.text = "You have no goal yet"
            viewAllGoals.hidden = true
            
        }
    }
    
    // before segue happens
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "showDetail" {
            if let destination = segue.destinationViewController as? GoalDetailViewController {
                navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: false)
                destination.goalIndex = goalHelper.getGoalIndexByGoalId((randomGoal?.id)!)
                destination.showMainMenu = true
            }
        }
        
    }

    
    /*
    
    // when return button has been pressed close keybord
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }

    // close keyboard when touching the screen
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    */
    

}

