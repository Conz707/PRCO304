//
//  LoadActivitiesModel.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 14/03/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

protocol LoadActivitiesModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}

class LoadActivitiesModel: NSObject, URLSessionDelegate {

    //properties
    weak var delegate: LoadActivitiesModelProtocol!
    var selectedStudent : Student?
    

    
    func downloadItems() {
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/LoadActivities.php")!)
         request.httpMethod = "POST"
        
      let S_ID = selectedStudent?.S_ID
        
        let postString = ("Student_ID=\(S_ID!)")
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
        let activityArr = NSMutableArray()
        
        for i in 0 ..< jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            
            let activities = ActivitiesModel()
            
            //the following ensures none of the JsonElement values are nil through optional binding
            if let activityID = jsonElement["A_ID"] as? String,
                let studentID = jsonElement["S_ID"] as? String,
                let activity = jsonElement["Activity"] as? String,
                let observation = jsonElement["Observation"] as? String,
                let activityDate = jsonElement["Date"] as? String,
                let activityPicture = jsonElement["ActivityPicture"] as? String
                
            {
                activities.activityID = activityID
                activities.studentID = studentID
                activities.activity = activity
                activities.observation = observation
                activities.activityDate = activityDate
                activities.activityPicture = activityPicture
            }
            
            activityArr.add(activities)
            print("trying to print activities")
            print(activities)
            
        }
        DispatchQueue.main.async(execute: { () -> Void in
        self.delegate.itemsDownloaded(items: activityArr)
            print("trying to print items downloaded \(activityArr)")
        })
    }
}

