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
var randomGoal = goalHelper.getRandomGoal()

class ViewController: UIViewController/*, UITextFieldDelegate */{
    
    @IBOutlet weak var addGoal: UIButton!
    
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var noGoalLabel: UILabel!
    
    @IBOutlet weak var grayBox: UIImageView!
    @IBOutlet weak var goalOfDayLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    
    @IBOutlet weak var viewAllGoals: UIButton!
    
    override func viewWillAppear(animated: Bool) {
       // self.navigationController?.navigationBar.hidden = true
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addStarStyles()
        addAddGoalButtonStyles()
        addGrayBoxStyles()
        
        //goalHelper.printGoals()
        randomGoal = randomGoal ?? nil
        // try to reassgin
        if goalHelper.totalGoals() > 0{
            if randomGoal == nil{
                randomGoal = goalHelper.getRandomGoal();
            }
        } else  {
            randomGoal = nil
        }
        
        renderView()

      //  self.textField.delegate = self;
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

