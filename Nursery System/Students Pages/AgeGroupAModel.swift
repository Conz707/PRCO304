//
//  HomeModel.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 20/02/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import Foundation

protocol AgeGroupAProtocol: class {
    func itemsDownloaded(items: NSArray)
}

class AgeGroupAModel: NSObject, URLSessionDelegate {
    
    //properties
    weak var delegate: AgeGroupAProtocol!
    
    let urlPath: String = "https://shod-verses.000webhostapp.com/AgeGroupA.php"
    
    func downloadItems() {
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)

        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Failed to download data")
            } else {
                print("Data downloaded")
                print("CAN I PRINT THIS?")
                self.parseJSON(data!)
            }
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

