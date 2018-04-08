//
//  ViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 19/02/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit
import Alamofire

struct User: Codable {
    let U_ID: String?
    let Email: String?
    let Password: String?
    let UserType: String?
    
}



class ViewController: UIViewController{

     var users = [User]()
    //Properties
    @IBOutlet var activityIndicatorLogin: UIActivityIndicatorView!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    var loginSuccess = false
    var roleString = ""
    let loginRequest = "https://shod-verses.000webhostapp.com/NewLogin.php" //loginRequest as Alamofire has a request function
    let defaultValues = UserDefaults.standard //used to store user data?
    var responseSuccess = ""
 
    

    override func viewDidLoad() {
        super.viewDidLoad()
       activityIndicatorLogin.hidesWhenStopped = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        passwordTxt.isEnabled = true
        emailTxt.isEnabled = true
        let dictionary = self.defaultValues.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            self.defaultValues.removeObject(forKey: key)
        }
        let checkUserEmail = self.defaultValues.string(forKey: "UserEmail")
        let checkUserRole = self.defaultValues.string(forKey: "UserRole")
        
        
        print(checkUserEmail)
        print(checkUserRole)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func checkLogin(completion: @escaping (_ success: Bool) -> ()){
   //NICK    let emailVar = emailTxt.text
       /* let passwordVar = passwordTxt.text
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
            
        let postString = ("Email=\(emailVar!)&Password=\(passwordVar!)")
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
                print("blahblahblah \(User.self)")
                self.parseJSON(data)
                print(data)
        /*    self.roleString = responseString
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
 
            */
            DispatchQueue.main.async {
                   completion(success)
            }
                
               
        }
        task.resume()
        print(success)
        }*/
 }
    
    func testParseJson(completion: @escaping (_ success : Bool) -> ()){
        var success = true
        let emailVar = emailTxt.text
        let passwordVar = passwordTxt.text
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/NewLogin.php")!)
            request.httpMethod = "POST"
        
            let postString = ("Email=\(emailVar!)&Password=\(passwordVar!)")
            print(postString)
            request.httpBody = postString.data(using: .utf8)
        
        _ = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else { return }
                do {
                    let responseString = String(data: data, encoding: .utf8)!
                    print("new response string \(responseString)")
                    self.responseSuccess = responseString
                    
                    if(self.responseSuccess == "") || (self.responseSuccess == "ERROR"){print("dont do anything?")} else {
                    let decoder = JSONDecoder()
                    let users = try decoder.decode(Array<User>.self, from: data)

                    if(users.first?.Email != ""){
                    self.defaultValues.set(users.first?.U_ID, forKey: "UserU_ID")
                    self.defaultValues.set(users.first?.Email, forKey: "UserEmail")
                    self.defaultValues.set(users.first?.Password, forKey: "UserPassword")
                    self.defaultValues.set(users.first?.UserType, forKey: "UserRole")
                    } else {
                        let dictionary = self.defaultValues.dictionaryRepresentation()
                        dictionary.keys.forEach { key in
                            self.defaultValues.removeObject(forKey: key)
                            }
                        }
                    }
                } catch let err {
                    print("Err", err)
                    success = false
                }
            
            DispatchQueue.main.async {
                completion(success)
            }
                }.resume()
            print(success)
        }
        
    
 func parseJSON(_ data:Data){
    
 //   let newData = try JSONDecoder.decode(User.self, from: data)

    }
    /*
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
   */

    
    
    @IBAction func loginBtn(_ sender: Any) {
        
        activityIndicatorLogin.startAnimating()
        passwordTxt.isEnabled = false
        emailTxt.isEnabled = false
 DispatchQueue.main.async {
    self.testParseJson(completion: { success in
        self.activityIndicatorLogin.stopAnimating()
        let checkUserEmail = self.defaultValues.string(forKey: "UserEmail")
        let checkUserRole = self.defaultValues.string(forKey: "UserRole")
        
        print(checkUserEmail)
        print(checkUserRole)
        
        
        
        switch(checkUserRole){
        case "Teacher"?:
            print("Teacher")
            self.performSegue(withIdentifier: "segueGoTeacher", sender: self)
        case "Parent"?:
            print("Parent")
            self.performSegue(withIdentifier: "segueGoParent", sender: self)
        case "Manager"?:
            print("Manager")
            self.performSegue(withIdentifier: "segueGoManager", sender: self)
        default:
            print("ERROR")
            let alertController = UIAlertController(title: "Error", message: "Incorrect Email or Password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Close Alert", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            self.passwordTxt.isEnabled = true
            self.emailTxt.isEnabled = true
            
        }
        
    })
     //               if(self.roleString == "Teacher"){
                

    /*
 
 

     
                    let alertController = UIAlertController(title: "Error", message: "Incorrect Email or Password", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Close Alert", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    self.passwordTxt.isEnabled = true
                    self.emailTxt.isEnabled = true
                        self.activityIndicatorLogin.stopAnimating()*/
                
                }
        }
}

