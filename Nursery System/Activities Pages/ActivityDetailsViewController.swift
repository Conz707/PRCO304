//
//  ActivityDetailsViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 19/03/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit
import Alamofire

class ActivityDetailsViewController: UIViewController {

    var selectedActivity : ActivitiesModel?
    
    @IBOutlet var activityObservations: UITextView!
    @IBOutlet var activityTitle: UILabel!
    @IBOutlet var imgActivity: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
activityTitle.text = selectedActivity?.activity
activityObservations.text = selectedActivity?.observation
        
        
        let URL_IMAGE = URL(string: (selectedActivity?.activityPicture)!)
        print(URL_IMAGE!)
        let session = URLSession(configuration: .default)
        
        //create a dataTask
        let getImageFromUrl = session.dataTask(with: URL_IMAGE!) { data, response, error in
            
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
                        print("image", image)
                        print(URL_IMAGE!)
                        //display the image
                        DispatchQueue.main.async{
                        self.imgActivity.image = image
                        }
                    } else {
                        print("image corrupted")
                    }
                } else {
                    print("No server response")
                }
            }
        }
        getImageFromUrl.resume()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
