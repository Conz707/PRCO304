//
//  StudentsModel.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 28/02/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class StudentsModel: NSObject, Decodable {

        
        //properties
    var studentID: String?
    var firstName: String?
    var surname: String?
    var displayPicture: String?
    var dateOfBirth: String?
    var mother: String?
    var father: String?
    var guardian: String?
    var keyPerson: String?
        
        //empty constructor
        override init()
        {
            
        }

        
    init(
         studentID: String,
         firstName: String,
         surname: String,
         dateOfBirth: String,
         mother: String,
         father: String,
         guardian: String,
         keyPerson: String,
         displayPicture: String)
        {
            self.studentID = studentID
            self.firstName = firstName
            self.surname = surname
            self.displayPicture = displayPicture
            self.dateOfBirth = dateOfBirth
            self.mother = mother
            self.father = father
            self.guardian = guardian
            self.keyPerson = keyPerson
       
            
        }
        
        //print object current state
        
        override var description: String {
            return "FirstName: \(firstName), Surname: \(surname), studentID: \(studentID), dateOfBirth: \(dateOfBirth), Mother =\(mother), Key Person = \(keyPerson)"
            
        }
        
}

 
