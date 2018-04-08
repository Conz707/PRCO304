//
//  UserHomeModel.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 05/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

protocol LoadUserModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}

class UserHomeModel: NSObject, URLSessionDelegate {
    //properties
    weak var delegate: LoadUserModelProtocol!
    var emailLogin = ""
    var passwordLogin = ""
    
    
    func downloadItems() {
    
    var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/NewLogin.php")!)
    request.httpMethod = "POST"
    
        let postString = ("email=\(emailLogin)&password=\(passwordLogin)")
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
        let userArr = NSMutableArray()
        
        for i in 0 ..< jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            
            let user = UserModel()
            
            //the following ensures none of the JsonElement values are nil through optional binding
            if let userID = jsonElement["U_ID"] as? String,
                let firstName = jsonElement["FirstName"] as? String,
                let surname = jsonElement["Surname"] as? String,
                let email = jsonElement["Email"] as? String,
                let telephoneNumber = jsonElement["TelephoneNumber"] as? String,
                let password = jsonElement["Password"] as? String,
                let userType = jsonElement["UserType"] as? String
                
            {
                user.userID = userID
              //  user.firstName = firstName
            //    user.surname = surname
                user.email = email
           //     user.telephoneNumber = telephoneNumber
                user.password = password
                user.userType = userType
            }
            
         
            
            userArr.add(user)
            print("trying to print user")
            print(user)
            
        }
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate.itemsDownloaded(items: userArr)
        })
    }
}
