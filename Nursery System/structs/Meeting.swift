//
//  Meeting.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 23/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

struct Meeting: Decodable {
    
    let M_ID : String?
    let Teacher_ID : String?
    let Parent_ID : String?
    let S_ID : String?
    let Date : String?
    let Notes : String?
    let Completed: String?
   
    init(M_ID : String? = nil,
         Teacher_ID : String? = nil,
         Parent_ID : String? = nil,
         S_ID : String? = nil,
         Date : String? = nil,
         Notes : String? = nil,
         Completed : String? = nil){
        
        self.M_ID = M_ID
        self.Teacher_ID = Teacher_ID
        self.Parent_ID = Parent_ID
        self.S_ID = S_ID
        self.Date = Date
        self.Notes = Notes
        self.Completed = Completed
    }

}
