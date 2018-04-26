//
//  Student.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 24/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class Student: Decodable {
    var S_ID: String?
    var FirstName: String?
    var Surname: String?
    var DateofBirth: String?
    var Mother: String?
    var Father: String?
    var Guardian: String?
    var KeyPerson: String?
    var StudentPicture: String?
    
    init(         S_ID: String? = nil,
                  FirstName: String?  = nil,
                  Surname: String?  = nil,
                  DateofBirth: String? = nil,
                  Mother: String? = nil,
                  Father: String? = nil,
                  Guardian: String? = nil,
                  KeyPerson: String? = nil,
                  StudentPicture: String? = nil){
        self.S_ID = S_ID
        self.FirstName = FirstName
        self.Surname = Surname
        self.StudentPicture = StudentPicture
        self.DateofBirth = DateofBirth
        self.Father = Father
        self.Mother = Mother
        self.Guardian = Guardian
        self.KeyPerson = KeyPerson
    }
    
    var description: String {
        return "\(S_ID), \(FirstName), \(Surname), \(StudentPicture), \(Mother), \(Father), \(Guardian), \(KeyPerson) \(DateofBirth)"
        
    }
}
