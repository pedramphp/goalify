//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


struct Goal {
    let title: String
    let description: String? = nil
    let dueDate: String? = nil
    let tags: [String]? = nil
    let category: String? = nil
}

class GoalHelper {
    
    var goals: [Goal] = []
    
    func addGoal(goal: Goal) {
        
        goals.append(goal)
        
    }
    
}

Goal(title: "hi")


var tt = [1,2,3,4];

tt.removeAtIndex(2)
tt
tt.insert(0, atIndex: 2)

NSUUID().UUIDString

