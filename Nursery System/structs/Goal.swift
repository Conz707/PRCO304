//
//  Goals.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 30/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

struct Goal: Decodable {

    var G_ID: String?
    var S_ID: String?
    var Goal: String?
    var Completed: String?
        
        init(
            G_ID: String? = nil,
            S_ID: String? = nil,
            Goal: String? = nil,
            Completed: String? = nil){
            
            var G_ID: String?
            var S_ID: String?
            var Goal: String?
            var Completed: String?
        }
        
        var description: String {
            return "\(G_ID)  \(S_ID)  \(Goal)   \(Completed) "
            
        }
    }
    


