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
    var id: String = ""
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
    var chosenGoal: Goal?
    
    
    init() {
        loadGoals()
        printGoals()
    }
    
    func loadGoals(){
        goals = []
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
                goal.id = NSUUID().UUIDString
                goal.title = record.valueForKey("title") as? String ?? ""
                goal.desc = record.valueForKey("desc") as? String ?? ""
                goal.dueDate = record.valueForKey("dueDate") as? NSDate? ?? nil
                goal.tags = record.valueForKey("tags") as? [String]? ?? nil
                goal.categoryId = record.valueForKey("categoryId") as? Int? ?? nil
                goal.timestamp = record.valueForKey("timestamp") as? NSDate? ?? nil
                goal.record = record;
                goals.append(goal)
            }
            
            loadChosenGoal()
            
        }catch {
            print("failed to get items")
        }
        
    }
    
    func getGoalByGoalId(goalId: String) -> Goal? {
        for goal in goals {
            if goal.id == goalId {
                return goal
            }
        }
        return nil
    }
    
    func loadChosenGoal() -> Goal?{
        let request = NSFetchRequest(entityName: "Settings")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(request)
            
            if results.count == 0 {
                // if goal doesn't exist add it.
                insertRandomChosenGoal()
                return nil
            }
            
            let record = results[0] as! NSManagedObject
            let goalId: String = record.valueForKey("chosenGoalId") as? String ?? ""
            chosenGoal = getGoalByGoalId(goalId)
            if chosenGoal == nil {
                insertRandomChosenGoal()
                return nil
            }
            return chosenGoal
            
        }catch {
            print("failed to get items")
        }
        return nil
  
    }
    
    func insertRandomChosenGoal(){
        let goal: Goal? = getRandomGoal()
        if let goal = goal {
            updateChosenGoal(goal)
        } else {
            chosenGoal = nil
        }
    }
    
    func updateChosenGoal(goal: Goal) {
        let settings = NSEntityDescription.insertNewObjectForEntityForName("Settings", inManagedObjectContext: context)
        
        settings.setValue(goal.id, forKey: "chosenGoalId")
        
        do {
            try context.save()
            chosenGoal = goal
        } catch {
            print("there was a problem updating settings")
        }

    }
    
    func addGoal(goal: Goal) {
        
        // updating record in database
        let newGoal = NSEntityDescription.insertNewObjectForEntityForName("Goals", inManagedObjectContext: context)
        
        newGoal.setValue(goal.title, forKey: "title")
        newGoal.setValue(goal.desc, forKey: "desc")
        newGoal.setValue(NSDate(), forKey: "timestamp")
        
        do {
            try context.save()
            loadGoals()
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
            print("Goal Title: \(goal.title) \(goal.timestamp)")
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
    
    func getChosenGoal() -> Goal? {
        if let chosen = chosenGoal {
            let goal: Goal? = getGoalByGoalId(chosen.id)
            // making sure goal exists
            if goal != nil {
                return chosenGoal
            } else  {
                // if it doesn exist insert random one
                insertRandomChosenGoal()
                return chosenGoal
            }
        } else {
            // if it doesn exist insert random one
            insertRandomChosenGoal()
            return chosenGoal
        }
    }
    
    func getGoalIndexByGoalId(goalId: String) -> Int? {
        
        for var index = 0; index < goals.count; ++index {
            if goals[index].id == goalId {
                return index
            }
        }
        return nil
    }
    
}


