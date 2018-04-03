//
//  StudentsModel.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 28/02/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class StudentsModel: NSObject {

        
        //properties
    var studentID: String?
    var firstName: String?
    var surname: String?
    var displayPicture: String?
    var dateOfBirth: String?
   // var mother: String?
  //  var father: String?
  //  var guardian: String?
    //  var dateOfBirth: Date?
 //   var mother: String?
 //  var father: String?
  //  var guardian: String?
 //   var keyPerson: String?
 
        //do age variable var age: Age??????
        
        //empty constructor
        override init()
        {
            
        }
        
        
        //construct with first name and surname parameters
        
    init(studentID: String, firstName: String, surname: String, dateOfBirth: String, displayPicture: String, displayPictureImg: UIImage )//, mother: String)//, father: String, guardian: String  )//dateOfBirth: Date) //mother: String, father: String, guardian: String, keyPerson: String)
        {
            self.studentID = studentID
            self.firstName = firstName
            self.surname = surname
            self.displayPicture = displayPicture
            self.dateOfBirth = dateOfBirth
     //       self.mother = mother
        //    self.father = father
        //    self.guardian = guardian

        //    self.dateOfBirth = dateOfBirth
          //  self.mother = mother
          //  self.father = father
          //  self.guardian = guardian
          //  self.keyPerson = keyPerson
       
            
        }
        
        //print object current state
        
        override var description: String {
            return "FirstName: \(firstName), Surname: \(surname), studentID: \(studentID), dateOfBirth: \(dateOfBirth)"
            
        }
        
}

 
