//
//  UserHomeModel.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 05/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class UserHomeModel: NSObject {
    //properties
    weak var delegate: HomeModelProtocol!
    
    let urlPath: String = "https://shod-verses.000webhostapp.com/NewLogin.php"
    
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
                user.firstName = firstName
                user.surname = surname
                user.email = email
                user.telephoneNumber = telephoneNumber
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
