//
//  Sessions.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 22/03/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//



import UIKit
import os.log

class Sessions: NSObject, NSCoding {
    
    struct userDetails {
        static let email = "email"
        static let u_id = "u_id"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(email, forKey: PropertyKey.email)
        aCoder.encode(u_id, forKey: PropertyKey.u_id)x
    }
    
    required init?(coder aDecoder: NSCoder) {
        <#code#>
    }
    
    
    

}
