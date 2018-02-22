//
//  ViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 19/02/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    //Properties
    
    @IBAction func loginBtn(_ sender: Any) {
      
        let emailVar = emailTxt.text
        let passwordVar = passwordTxt.text
        
        
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/Login.php")!)
        request.httpMethod = "POST"
        let postString = ("email=" + emailVar! + "&password=" + passwordVar!)
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
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            if (responseString == "success"){
                print("responsestring doing mad shit")
             } else {
                print("shit sucks")
            }
        }
        task.resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

