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
    
    let urlPath: String = "https://shod-verses.000webhostapp.com/LoadActivities.php"
    
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
        let activityArr = NSMutableArray()
        
        for i in 0 ..< jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            
            let activities = ActivitiesModel()
            
            //the following ensures none of the JsonElement values are nil through optional binding
            if let activityID = jsonElement["A_ID"] as? String,
                let studentID = jsonElement["S_ID"] as? String,
                let activity = jsonElement["Activity"] as? String,
                let observation = jsonElement["Observation"] as? String,
                let activityPicture = jsonElement["ActivityPicture"] as? String
                
            {
                activities.activityID = activityID
                activities.studentID = studentID
                activities.activity = activity
                activities.observation = observation
                activities.activityPicture = activityPicture
            }
            
            activityArr.add(activities)
            print("trying to print activities")
            print(activities)
            
        }
        DispatchQueue.main.async(execute: { () -> Void in
        self.delegate.itemsDownloaded(items: activityArr)
        })
    }
}

