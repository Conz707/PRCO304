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
    
    static func getImages(URL_IMAGE: URL, completion: @escaping (_ success : Bool, _ image : UIImage) -> ()){
        print("attempting to attach activity to table")
        
        var success = true
        
        let session = URLSession(configuration: .default)
        
        //create a dataTask
        let getImageFromUrl = session.dataTask(with: URL_IMAGE) { data, response, error in
            
            //if error
            if let e = error {
                //display message
                print("Error occurred: \(e)")
            } else {
                if (response as? HTTPURLResponse) != nil {
                    
                    //check response contains image
                    if let imageData = data {
                        
                        //get image
                        let image = UIImage(data: imageData)
                        
                        //complete - return image
                        completion(success, image!)
                        
                    } else {
                        print("image corrupted")
                        success = false
                    }
                } else {
                    print("No server response")
                    success = false
                }
            }
            
        }
        getImageFromUrl.resume()
    

    }
    
    static func checkInputValid(type:String, input: String) -> Bool {
        var textRegEx = ""
        
        switch(type){
        case "Email":
            textRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
            print("switch email")
            
        case "Password":
            textRegEx = "[a-z0-9_-]{6,18}" // password entry must be 6 - 18 digits - make sure alert represents this
            
            print("switch Password")
        case "Text":
            textRegEx = "[a-zA-Z0-9,.!? @]"
            
            print("switch Text")
        case "TelNum":
            textRegEx = "[0]+[0-9]{1,10}"   //ensure telnum starts with 0 and 11 digits total
            
            print("switch TelNum")
        default:
            
            print("switch default")
        }
        
        let testIfValid = NSPredicate(format: "SELF MATCHES %@", textRegEx)
        return testIfValid.evaluate(with: input)
        
    }
    

    
    
    static func normalAlertBox(alertTitle: String,messageString: String) -> UIAlertController{   //call alert box with custom title and message
        let alertController = UIAlertController(title: "Error", message: messageString, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Close Alert", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
       return alertController
        
    }
    
    static func actionAlertBox(){
        
    }

}


