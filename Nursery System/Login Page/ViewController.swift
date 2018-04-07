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

    
    @IBOutlet var activityIndicatorLogin: UIActivityIndicatorView!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    var loginSuccess = false
    var roleString = ""
    
 
    //Properties

    override func viewDidLoad() {
        super.viewDidLoad()
       activityIndicatorLogin.hidesWhenStopped = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        passwordTxt.isEnabled = true
        emailTxt.isEnabled = true
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func checkLogin(completion: @escaping (_ success: Bool) -> ()){

        let emailVar = emailTxt.text
        let passwordVar = passwordTxt.text
        var success = true
        
        if (emailVar?.isEmpty)! || (passwordVar?.isEmpty)! {
            let alertController = UIAlertController(title: "Error", message: "Email or Password field empty", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Close Alert", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            success = false
        } else {
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/NewLogin.php")!)
       
            request.httpMethod = "POST"
            
        let postString = ("email=" + emailVar! + "&password=" + passwordVar!)
            print(postString)
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
                self.parseJSON(data)
                
            self.roleString = responseString
                if (self.roleString == "Teacher"){
                    print("roleString  Teacher")
                    success = false
                } else if (self.roleString == "Parent"){
                    print("roleString Parent")
                    success = true
                } else if (self.roleString == "Manager"){
                    print("roleString Manager")
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
    }
    
    func parseJSON(_ data:Data){
        
        var jsonElement = NSDictionary()
        
        do {
       let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        let U_ID = jsonElement["U_ID"] as? String
        let email = jsonElement["Email"] as? String
        let password = jsonElement["Password"] as? String
        let userType = jsonElement["UserType"] as? String
        print("uid=\(U_ID) email=\(email) password=\(password) usertype=\(userType)")
    }
    
    
    
    @IBAction func loginBtn(_ sender: Any) {
        
        activityIndicatorLogin.startAnimating()
        passwordTxt.isEnabled = false
        emailTxt.isEnabled = false
        
        DispatchQueue.main.async {
            self.checkLogin(completion: { success in
                    if(self.roleString == "Teacher"){
                    self.performSegue(withIdentifier: "segueGoTeacher", sender: self)
                    self.activityIndicatorLogin.stopAnimating()
                } else if (self.roleString == "Parent") {
                    self.performSegue(withIdentifier: "segueGoParent", sender: self)
                    self.activityIndicatorLogin.stopAnimating()
                } else if (self.roleString == "Manager") {
                    self.performSegue(withIdentifier: "segueGoManager", sender: self)
                    self.activityIndicatorLogin.stopAnimating()
                    } else {
                    let alertController = UIAlertController(title: "Error", message: "Incorrect Email or Password", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Close Alert", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    self.passwordTxt.isEnabled = true
                    self.emailTxt.isEnabled = true
                        self.activityIndicatorLogin.stopAnimating()
                }
            })
        }
    }
}

