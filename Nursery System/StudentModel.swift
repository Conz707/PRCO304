//
//  StaffModel.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 20/02/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import Foundation

class StaffModel: NSObject {

//properties
    var firstName: String?
    var surname: String?
    //do age variable var age: Age??????
    var mother: String?
    var father: String?
    var guardian: String?
    var keyPerson: String?

//empty constructor
override init()
{
    
}


//construct with first name and surname parameters

    init(firstName: String, surname: String, mother: String?, father: String?, guardian: String?, keyPerson: String?)
{
    self.firstName = firstName
    self.surname = surname
    self.mother = mother
    self.father = father
    self.guardian = guardian
    self.keyPerson = keyPerson
    
}

//print object current state

override var description: String {
    return "First Name: \(firstName), Surname: \(surname), Mother: \(mother), Father: \(father), Guardian: \(guardian), Key Person: \(keyPerson)"
}

}
