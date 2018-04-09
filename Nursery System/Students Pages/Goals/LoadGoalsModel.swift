//
//  LoadGoalsModel.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 09/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

protocol LoadGoalsProtocol: class {
    func itemsDownloaded(items: NSArray)

}

class LoadGoalsModel: NSObject, URLSessionDelegate {

    //properties
    weak var delegate: LoadGoalsProtocol!
    
    let urlPath: String = "https://shod-verses.000webhostapp.com/LoadYear1Goals.php"
    
    func downloadItems(){
        
        var success = true
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Failed to download data")
                success = false
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
        let goalsArr = NSMutableArray()
        
        for i in 0 ..< jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            
            let goals = GoalsModel()
            
            //the following ensures none of the JsonElement values are nil through optional binding
            if let goal1 = jsonElement["Goal1"] as? String,
                let goal1Completed = jsonElement["Goal1Completed"] as? String,
                let goal2 = jsonElement["Goal2"] as? String,
                let goal2Completed = jsonElement["Goal2Completed"] as? String,
                let goal3 = jsonElement["Goal3"] as? String,
                let goal3Completed = jsonElement["Goal3Completed"] as? String
                
            {
                goals.goal1 = goal1
                goals.goal1Completed = goal1Completed
                goals.goal2 = goal2
                goals.goal2Completed = goal2Completed
                goals.goal3 = goal3
                goals.goal3Completed = goal3Completed
                
            }
            
            goalsArr.add(goals)
            print("trying to print goals")
            print(goals)
            
        }
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate.itemsDownloaded(items: goalsArr)
        })
    }
    
}
