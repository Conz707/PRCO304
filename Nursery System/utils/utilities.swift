//
//  utils.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 27/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class utilities{

    static func postRequest(postString: String, request: URLRequest, completion: @escaping(_ success : Bool, _ data: Data) -> ()){
        print("using utilities")
        var success = true
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                success = false
            }
            
            var responseString = String(data: data, encoding: .utf8)!
            print("responseString = \(responseString)")
            completion(success, data)
        }
        task.resume()
    }
    
    static func formatDateToString(dateString: String) -> String{
        
        var myDate = Date()
        
        //Convert String to Date for formatting
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        myDate = dateFormatter.date(from: dateString)!
        print("original date is \(dateString)")
        
        //Convert date back to String
        dateFormatter.dateFormat = "MMMM dd, YYYY"
        let newDateString = dateFormatter.string(from: myDate)
        print("new date string is \(newDateString)")
        
        return newDateString
    }
    
    static func formatStringToDate(dateString: String) -> Date{
        
        var newDate = Date()
        print(dateString)

        //Convert String to Date for formatting
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        newDate = dateFormatter.date(from: dateString)!
        print("original date is \(dateString)")
        
        return newDate
        
    }
    
}


