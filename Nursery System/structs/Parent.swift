//
//  Parent.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 23/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

struct Parent: Decodable {
    
    let U_ID : String?
    let FirstName : String?
    let Surname : String?
    let Email : String?
    let TelephoneNumber : String?
    let Password : String?
    let UserType: String?
    
    init(U_ID : String? = nil,
         FirstName : String? = nil,
         Surname : String? = nil,
         Email : String? = nil,
         TelephoneNumber : String? = nil,
         Password : String? = nil,
         UserType : String? = nil){
        
        self.U_ID = U_ID
        self.FirstName = FirstName
        self.Surname = Surname
        self.Email = Email
        self.TelephoneNumber = TelephoneNumber
        self.Password = Password
        self.UserType = UserType
    }
    
}
