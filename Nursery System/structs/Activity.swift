//
//  Activity.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 27/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

struct Activity: Decodable {
    var A_ID: String?
    var S_ID: String?
    var Activity: String?
    var Observation: String?
    var Date: String?
    var ActivityPicture: String?
    
    init(         A_ID: String? = nil,
                  S_ID: String? = nil,
                  Activity: String? = nil,
                  Observation: String? = nil,
                  Date: String? = nil,
                  ActivityPicture: String? = nil){
        
        var A_ID: String?
        var S_ID: String?
        var Activity: String?
        var Observation: String?
        var Date: String?
        var ActivityPicture: String?
    }
    
    var description: String {
            return "\(A_ID)  \(S_ID)  \(Activity)   \(Observation)   \(Date) \(ActivityPicture) "
        
    }
}

