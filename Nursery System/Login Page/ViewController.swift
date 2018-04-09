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
                    print(users.first?.Email)
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
    
                }
        }
}

