//
//  StudentsModel.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 28/02/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class StudentsModelA: NSObject {

        
        //properties
        var firstName: String?
        var surname: String?
        //do age variable var age: Age??????
        
        //empty constructor
        override init()
        {
            
        }
        
        
        //construct with first name and surname parameters
        
        init(firstName: String, surname: String)//keyPerson: String?)
        {
            self.firstName = firstName
            self.surname = surname

            
        }
        
        //print object current state
        
        override var description: String {
            return "FirstName: \(firstName), Surname: \(surname)"
        }
        
}
