//
//  AddGoalViewController.swift
//  goalify
//
//  Created by Pedramrazi, Mahdi on 3/6/16.
//  Copyright © 2016 Mexo Inc. All rights reserved.
//

import UIKit


//https://www.ralfebert.de/snippets/ios/swift-uicolor-picker/


class AddGoalViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var goalNavigationBar: UINavigationBar!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var titleField: UITextField!

    @IBOutlet weak var descField: UITextView!
    @IBOutlet weak var descImage: UIImageView!
    
    var mode: String = "ADD"
    var source: String?
    
    var goalIndex: Int?
    var goal: Goal?
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    // disable orientation
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewStyles()
        
        titleField.autocorrectionType = UITextAutocorrectionType.No
        descField.autocorrectionType = UITextAutocorrectionType.No
        
        loadContent()
        let text = titleField.text ?? nil
        if text != nil && text != ""
        {
            doneButton.enabled = true
        } else {
            doneButton.enabled = false
        }
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(sender: AnyObject) {
        

        
        if let title = titleField.text,
                desc = descField.text
            where title != "" {
                
            if mode == "EDIT" {
                goal?.title = title
                goal?.desc = desc
                
                goalHelper.editGoal(goal!, index: goalIndex ?? 0)
                
                popView()
                
            } else  {
                var goal = Goal()
                goal.title = title
                goal.desc = desc
                
                goalHelper.addGoal(goal)
                transitionToListView()
            }
            
            
            titleField.text = ""
            descField.text = ""
           // goalHelper.printGoals()
        }
                
    }
    
    func loadContent() {
        if mode == "EDIT" {
            let index = goalIndex ?? 0
            goal = goalHelper.getGoalByIndex(index)
            
            if let goal = goal {
                
                titleField.text = goal.title
                descField.text = goal.desc
                descField.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0) /* #333333 */
            }
            goalNavigationBar.topItem?.title = "Edit"
        }
    }
    
    func setViewStyles() {
        // set background color
        view.layer.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1.0).CGColor /* #ececec */
        
        setNavigationStyles()
        setTextInpuStyles(titleImage)
        setTextInpuStyles(descImage)
        descField.text = "Add some note here to describe your goal"
        descField.textColor = UIColor.lightGrayColor()

    }
    
    func setNavigationStyles(){
        // navigation background.
        goalNavigationBar.backgroundImageForBarMetrics(UIBarMetrics.Default)
        goalNavigationBar.setBackgroundImage(UIImage(named: "bg-navigation"), forBarPosition: UIBarPosition.Top, barMetrics: UIBarMetrics.Default)
        goalNavigationBar.translucent = true
        goalNavigationBar.tintColor = UIColor.whiteColor()
        goalNavigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    func setTextInpuStyles(imageView: UIImageView) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0).CGColor /* #cccccc */
        
        border.frame = CGRect(
            x: -1,
            y: 0,
            width:  imageView.frame.size.width + 2,
            height: imageView.frame.size.height)
        
        border.borderWidth = width
        imageView.layer.addSublayer(border)
        imageView.layer.masksToBounds = true
        imageView.layer.backgroundColor = UIColor.whiteColor().CGColor
        imageView.layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0).CGColor/* #cccccc */
        
    }
    
    
    func transitionToListView(){
        if let source = source where source == "listview" {
            popView()
        } else {
            performSegueWithIdentifier("goalAdded", sender: self)
        }
    }
    
    // when return button has been pressed close keybord
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    // close keyboard when touching the screen
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    
    }
    
    @IBAction func editChanged(sender: AnyObject) {
       
            if let text = titleField.text where text != ""{
                doneButton.enabled = true
            }else {
                doneButton.enabled = false
            }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0) /* #333333 */
        }
    }
    
    
    func popView() {
        self.dismissViewControllerAnimated(true, completion: nil)

        /* if the segue is push then use the below code
        navigationController?.popViewControllerAnimated(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
        */
    }
    
    
    @IBAction func cancel(sender: AnyObject) {

        if mode == "EDIT" {
            popView()
        } else {
            if let source = source where source == "listview" {
                popView()
            } else {
                performSegueWithIdentifier("backToMain", sender: self)
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
