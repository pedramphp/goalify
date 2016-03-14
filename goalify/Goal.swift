//
//  Goal.swift
//  goalify
//
//  Created by Pedramrazi, Mahdi on 3/6/16.
//  Copyright © 2016 Mexo Inc. All rights reserved.
//

import Foundation
import CoreData
import UIKit

var appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
var context: NSManagedObjectContext = appDel.managedObjectContext


struct Goal {
    var title: String = ""
    var desc: String = ""
    var dueDate: NSDate? = nil
    var tags: [String]? = nil
    var categoryId: Int? = nil
    var timestamp: NSDate? = nil
    var record: NSManagedObject? = nil
    
}

class GoalHelper {
    
    var goals: [Goal] = []
    
    init() {
        loadGoals()
    }
    
    func loadGoals(){
        let request = NSFetchRequest(entityName: "Goals")
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(request)
            
            if results.count == 0 {
                return
            }
            
            for record: NSManagedObject in results as! [NSManagedObject]{
                
                var goal = Goal()
                goal.title = record.valueForKey("title") as? String ?? ""
                goal.desc = record.valueForKey("desc") as? String ?? ""
                goal.dueDate = record.valueForKey("dueDate") as? NSDate? ?? nil
                goal.tags = record.valueForKey("tags") as? [String]? ?? nil
                goal.categoryId = record.valueForKey("categoryId") as? Int? ?? nil
                goal.timestamp = record.valueForKey("timestamp") as? NSDate? ?? nil
                goal.record = record;
                goals.append(goal)
            }
            
        }catch {
            print("failed to get items")
        }
        
    }
    
    func addGoal(goal: Goal) {
        
        goals.append(goal)
        
        // updating record in database
        let newGoal = NSEntityDescription.insertNewObjectForEntityForName("Goals", inManagedObjectContext: context)
        
        newGoal.setValue(goal.title, forKey: "title")
        newGoal.setValue(goal.desc, forKey: "desc")
        
        
        do {
            try context.save()
        } catch {
            print("there was a problem adding a goal")
        }
        
    }
    
    func editGoal(goal: Goal, index: Int) {
        
        guard let record = goal.record else  {
            return
        }
        
        record.setValue(goal.title, forKey: "title")
        record.setValue(goal.desc, forKey: "desc")
        record.setValue(goal.dueDate, forKey: "dueDate")
        record.setValue(goal.tags, forKey: "tags")
        record.setValue(goal.categoryId, forKey: "categoryId")
        do {
            print("saved in db")
            // update in DB
            try context.save()
            goals.insert(goal, atIndex: index)
            goals.removeAtIndex(index + 1)
            printGoals()

        } catch {
            print("there was a problem saving record")
        }
        
    }
    
    func deleteGoalByIndex(index: Int) {
        
        guard let goal = getGoalByIndex(index),
              let record = goal.record  else {
            
            return
        }
        
        // delete from DB
        context.deleteObject(record)
        
        do {
            // update in DB
            try context.save()
        } catch {
            print("there was a problem saving record deleted")
        }
        
        // remove from array
        goals.removeAtIndex(index)
    
        
    }
    
    func getGoalByIndex(index: Int) -> Goal?{
        return goals[index] ?? nil
    }
    
    func totalGoals() -> Int {
        return goals.count
    }
    
    func printGoals() {
        
        for goal in goals {
            print("Goal Title: " + goal.title)
            
        }
    }
    
    func getRandomGoal() -> Goal?{
        let goalCount: Int = totalGoals()
        if goalCount == 0 {
            return nil
        }
        
        let randomIndex = (arc4random_uniform(UInt32(goalCount - 1)) + 0)
        
        return getGoalByIndex(Int(randomIndex))
    }
    
}


