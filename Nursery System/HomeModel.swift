//
//  HomeModelA.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 20/02/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import Foundation

protocol HomeModelAProtocol: class {
    func itemsDownloaded(items: NSArray)
}

class HomeModelA: NSObject, URLSessionDelegate {
    
    //properties
    weak var delegate: HomeModelAProtocol!
    
    let urlPath: String = "https://shod-verses.000webhostapp.com/AgeGroupA.php"
    
    func downloadItems() {
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)

        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Failed to download data")
            } else {
                print("Data downloaded")
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
        
            let student = StudentsModelA()
            
            //the following ensures none of the JsonElement values are nil through optional binding
            if let firstName = jsonElement["FirstName"] as? String,
                let surname = jsonElement["Surname"] as? String
            {
                student.firstName = firstName
                student.surname = surname

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

