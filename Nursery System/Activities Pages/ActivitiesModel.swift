//
//  ActivitiesModel.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 14/03/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class ActivitiesModel: NSObject {

        
        
        //properties
        var activityID: String?
        var studentID: String?
        var activity: String?
        var observation: String?
    var activityPicture: String?

    
        
        //empty constructor
        override init()
        {
            
        }
    
        
    init(activityID: String, studentID: String, activity: String, observation: String, activityPicture: String)
        {
            self.activityID = activityID
            self.studentID = studentID
            self.activity = activity
            self.observation = observation
            self.activityPicture = activityPicture
        }
        
        //print object current state
        
        override var description: String {
            return "Activity: \(activity)"
        }
    
    
}
