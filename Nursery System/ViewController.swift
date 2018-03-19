//
//  ViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 19/02/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController{
    
    
    let main = DispatchQueue.main
    let background = DispatchQueue.global()

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    var loginSuccess = false
    var roleString = ""
 
    //Properties

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func checkLogin(completion: @escaping (_ success: Bool) -> ()){
      
        
        var success = true
        
        let emailVar = emailTxt.text
        let passwordVar = passwordTxt.text
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/Login2.php")!)
        request.httpMethod = "POST"
        let postString = ("email=" + emailVar! + "&password=" + passwordVar!)
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                success = false
                print(success)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                
            }
            
            var responseString = String(data: data, encoding: .utf8)!
            print("responseString = \(responseString)")
            self.roleString = responseString
            if (self.roleString == "Teacher"){
                print("roleString  Teacher")
                success = false
            } else if (self.roleString == "Parent"){
                print("roleString Parent")
                success = true
            } else{
                print("roleString Failure")
            }
            
            DispatchQueue.main.async {
                   completion(success)
            }
            
            
        }
        task.resume()
        print(success)
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        DispatchQueue.main.async {
            self.checkLogin(completion: { success in
                if(self.roleString == "Teacher"){
                self.performSegue(withIdentifier: "segueGoTeacher", sender: self)
                } else if (self.roleString == "Parent") {
                    self.performSegue(withIdentifier: "segueGoParent", sender: self)
                } else {
                    
                }
            } )
            
        }
       // self.performSegue(withIdentifier: "segueGo", sender: self)
        
    }
}

