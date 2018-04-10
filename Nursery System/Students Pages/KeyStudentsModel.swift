//
//  KeyStudentsModel.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 10/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit
import Foundation

protocol KeyStudentsModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}

class KeyStudentsModel: NSObject, URLSessionDelegate {
        
        //properties
        weak var delegate: KeyStudentsModelProtocol!
        let defaultValues = UserDefaults.standard

        
        func downloadItems() {
            
            var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/KeyStudents.php")!)
            request.httpMethod = "POST"
            
            let U_ID = defaultValues.string(forKey: "UserU_ID")
            
            let postString = ("User_ID=\(U_ID!)")
            print(postString)
            request.httpBody = postString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    
                }
                
                var responseString = String(data: data, encoding: .utf8)!
                print("responseString for table loading etc etc= \(responseString)")
                self.parseJSON(data)
                
            }
            task.resume()
            
    }
        
        func parseJSON(_ data:Data) {
            
            var jsonResult = NSArray()
            
            do{
                jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            } catch let error as NSError {
                print(error)
            }
            
            var jsonElement = NSDictionary()
            let studentArr = NSMutableArray()
            
            for i in 0 ..< jsonResult.count{
                jsonElement = jsonResult[i] as! NSDictionary
                
                let student = StudentsModel()
                
                //the following ensures none of the JsonElement values are nil through optional binding
                if let studentID = jsonElement["S_ID"] as? String,
                    let firstName = jsonElement["FirstName"] as? String,
                    let surname = jsonElement["Surname"] as? String,
                    let displayPicture = jsonElement["StudentPicture"] as? String,
                    let dateOfBirth = jsonElement["DateofBirth"] as? String
                    
                {
                    student.studentID = studentID
                    student.firstName = firstName
                    student.surname = surname
                    student.displayPicture = displayPicture
                    student.dateOfBirth = dateOfBirth
                }
                
                if let mother = jsonElement["Mother"] as? String {  //these elements might be returned nil, changed to empty string, probably a better method - ask nick? (NIL COALESCING OPERATORS??)
                    student.mother = mother
                } else {
                    student.mother = ""
                }
                if let father = jsonElement["Father"] as? String
                {
                    student.father = father
                } else {
                    student.father = ""
                }
                if let guardian = jsonElement["Guardian"] as? String
                {
                    student.guardian = guardian
                } else {
                    student.guardian = ""
                }
                
                if let keyPerson = jsonElement["KeyPerson"] as? String
                {
                    student.keyPerson = keyPerson
                }
                
                studentArr.add(student)
                print("trying to print student")
                print(student)
                
            }
            DispatchQueue.main.async(execute: { () -> Void in
                self.delegate.itemsDownloaded(items: studentArr)
            })
        }
    }
