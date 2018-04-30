//
//  ParentsHomepageViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 12/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class ParentsHomepageViewController: UIViewController {

    @IBOutlet var imgMeeting: UIImageView!
    @IBOutlet var imgNotification: UIImageView!
    @IBOutlet var lblNumNotifications: UILabel!
    let defaultValues = UserDefaults.standard
    var numNotifications = ""
    
    @IBOutlet var lblNumMeetings: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        imgNotification.isHidden = true;
        lblNumNotifications.isHidden = true;
        DispatchQueue.main.async{
            self.getNotifications { success in
                if(self.numNotifications != "0"){
                    self.self.lblNumNotifications.text = self.numNotifications
                    self.imgNotification.isHidden = false;
                    self.lblNumNotifications.isHidden = false;
            print(self.numNotifications)
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getNotifications(completion: @escaping (_ success : Bool) ->()){
        var success = true
        let U_ID = defaultValues.string(forKey: "UserU_ID")
        
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/ParentSidePHPFiles/GetNumberOfNotifications.php")!)
        
        request.httpMethod = "POST"
        
        let postString = ("U_ID=\(U_ID!)")
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
                success = false
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                
            }
            
            var responseString = String(data: data, encoding: .utf8)!
            print("responseString = \(responseString)")
            self.numNotifications = responseString
            
            DispatchQueue.main.async{
                completion(success)
            }
            
        }
        task.resume()
    }

}
