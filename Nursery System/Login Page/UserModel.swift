//
//  UserModel.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 05/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    
    //properties
    var userID: String?
    var firstName: String?
    var surname: String?
    var email: String?
    var telephoneNumber: String?
    var password: String?
    var userType: String?
    
    //empty constructor
    override init()
    {
        
    }

    init(
    userID: String,
    firstName: String,
    surname: String,
    email: String,
    telephoneNumber: String,
    password: String,
    userType: String
    )
    {
        self.userID = userID
        self.firstName = firstName
        self.surname = surname
        self.email = email
        self.telephoneNumber = telephoneNumber
        self.password = password
        self.userType = userType
        
        
    }
    
    //print object current state
    
    override var description: String {
return "\(email)\(password)\(userType)"
    }
    
}
