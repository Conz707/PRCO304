//
//  GoalsModel.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 09/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class GoalsModel: NSObject {
    //properties
    var goal1: String?
    var goal1Completed: String?
    var goal2: String?
    var goal2Completed: String?
    var goal3: String?
    var goal3Completed: String?

    override init (){
        
    }
    
    init(
     goal1: String,
     goal1Completed: String,
     goal2: String,
     goal2Completed: String,
     goal3: String,
     goal3Completed: String)
    {
        self.goal1 = goal1
        self.goal1Completed = goal1Completed
        self.goal2 = goal2
        self.goal2Completed = goal2Completed
        self.goal3 = goal3
        self.goal3Completed = goal3Completed
    }
    
    override var description: String {
        return "goal1 \(goal1)"
    }
}
