//
//  ViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 19/02/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit
import Alamofire



class ViewController: UIViewController, UITextFieldDelegate{

     var users = [User]()
    //Properties
    @IBOutlet var btnLoginOutlet: UIButton!
    @IBOutlet var activityIndicatorLogin: UIActivityIndicatorView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    var loginSuccess = false
    var roleString = ""
    let defaultValues = UserDefaults.standard //used to store user data?
    var responseSuccess = ""
    var postString = ""
 
    

    override func viewDidLoad() {
        super.viewDidLoad()
       activityIndicatorLogin.hidesWhenStopped = true
        txtEmail.delegate = self
        txtPassword.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        txtPassword.isEnabled = true
        txtEmail.isEnabled = true
        btnLoginOutlet.isEnabled = true
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

    
 
 
    
    func parseJSON(completion: @escaping (_ success : Bool) -> ()){
        var success = true
      
     let emailVar = txtEmail.text
        let passwordVar = txtPassword.text
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/NewLogin.php")!)
            request.httpMethod = "POST"
        
            let postString = ("Email=\(emailVar!)&Password=\(passwordVar!)")
            print(postString)
            request.httpBody = postString.data(using: .utf8)
        
        _ = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else { return }
                do {
                    let responseString = String(data: data, encoding: .utf8)!
                    print("response string \(responseString)")
                    self.responseSuccess = responseString
                    
                    if(self.responseSuccess == "") || (self.responseSuccess == "ERROR"){print("dont do anything?")} else {
                    let decoder = JSONDecoder()
                    let users = try decoder.decode(Array<User>.self, from: data)
                    print(users.first?.Email)
                  
                        
                        if(users.first?.Email != "" && users.first?.Active != "0"){
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
                    
                    print("attempting response string \(responseString)")
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

    
    @IBAction func btnLogin(_ sender: Any) {
        
        loginVerify()
        
        /*if(checkValidInputs()){
            print("valid input")
            
        } else {
            self.present(utilities.normalAlertBox(alertTitle: "Error", messageString: "Invalid characters entered"), animated: true)
            
        }
        */

        }

    func checkValidInputs() -> Bool{
        
   /*     let testEmailString = utilities.checkTextValid(checkString: txtEmail.text!)
        let testPasswordString = utilities.checkTextValid(checkString: txtPassword.text!)
        
        if(!testEmailString || !testPasswordString){
            print("\(testEmailString) \(testPasswordString)")
            return false
        } else {
            
            return true
        }
        
    }
   */
        let checkEmail = utilities.checkTextValid(checkString: txtEmail.text!)
        let checkPassword = utilities.checkTextValid(checkString: txtPassword.text!)
        if(!checkEmail || !checkPassword){
            return false
        } else {
              return true
        }

    }
    
    func loginVerify(){
        activityIndicatorLogin.startAnimating()
        txtPassword.isEnabled = false
        txtEmail.isEnabled = false
        btnLoginOutlet.isEnabled = false
        DispatchQueue.main.async {
            self.parseJSON(completion: { success in
                self.activityIndicatorLogin.stopAnimating()
                let checkUserEmail = self.defaultValues.string(forKey: "UserEmail")
                let checkUserRole = self.defaultValues.string(forKey: "UserRole")
                
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
                    
                    self.present(utilities.normalAlertBox(alertTitle: "Error", messageString: "Incorrect Email or Password"), animated: true)
                    
                    self.txtPassword.isEnabled = true
                    self.txtEmail.isEnabled = true
                    self.btnLoginOutlet.isEnabled = true
                    
                }
            })
            
        }
    }
}

