//
//  ViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 19/02/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit


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
    let testAccounts = ["con@hotmail.com", "con@hotmail.com1", "con@hotmail.com2"]
 
    

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorLogin.hidesWhenStopped = true
        txtEmail.delegate = self
        txtPassword.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) { //clear defaultValues and reenable text boxes
       
        txtPassword.isEnabled = true
        txtEmail.isEnabled = true
        btnLoginOutlet.isEnabled = true
        let dictionary = self.defaultValues.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            self.defaultValues.removeObject(forKey: key)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func verifyLogin(completion: @escaping (_ completeSuccess : Bool) -> ()){
        
        var completeSuccess = true
        
        let emailVar = txtEmail.text
        let passwordVar = txtPassword.text
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/NewLogin.php")!)
        request.httpMethod = "POST"
        let postString = ("Email=\(emailVar!)&Password=\(passwordVar!)")
        request.httpBody = postString.data(using: .utf8)
        
        utilities.postRequest(postString: postString, request: request, completion: { success, data, responseString  in
            do {
                if(responseString == "") || (responseString == "ERROR"){ //if failed login error
                        completeSuccess = false
                        self.present(utilities.normalAlertBox(alertTitle: "Error", messageString: "Incorrect Email or Password"), animated: true)
                    
                } else {    //else perform login and assign default values
                    let decoder = JSONDecoder()
                    let users = try decoder.decode(Array<User>.self, from: data)
                    
                    self.defaultValues.set(users.first?.U_ID, forKey: "UserU_ID")
                    self.defaultValues.set(users.first?.Email, forKey: "UserEmail")
                    self.defaultValues.set(users.first?.Password, forKey: "UserPassword")
                    self.defaultValues.set(users.first?.UserType, forKey: "UserRole")
                    

                }
            } catch let err {
                print("Err", err)
            }
        
        completion(completeSuccess)

        })
    }
    


    
    @IBAction func btnLogin(_ sender: Any) {
        
        if(testAccounts.contains(txtEmail.text!)){              //This lets test accounts skip the input validation
                startAuthentication()
            
        } else {
            if(!checkValidInputs()){                        //check for input validity
                self.present(utilities.normalAlertBox(alertTitle: "ERROR", messageString: "Invalid Characters Used"), animated: true)
            } else {
                startAuthentication()
            }
        }
    }

    func checkValidInputs() -> Bool{        //use utilities function to compare text to RegEx

        let checkEmail = utilities.checkInputValid(type: "Email", input: txtEmail.text!)
        let checkPassword = utilities.checkInputValid(type: "Password", input: txtPassword.text!)
        
        if(!checkEmail || !checkPassword)
        {
            return false
            
        } else {
            return true
            
        }

    }
    
    func startAuthentication(){     //begin authentication to check if user correct, and segue if so
        activityIndicatorLogin.startAnimating()
        txtPassword.isEnabled = false
        txtEmail.isEnabled = false
        btnLoginOutlet.isEnabled = false

            self.verifyLogin(completion: { success in
                        DispatchQueue.main.async {
                self.activityIndicatorLogin.stopAnimating()
                _ = self.defaultValues.string(forKey: "UserEmail")
                let checkUserRole = self.defaultValues.string(forKey: "UserRole")
                switch(checkUserRole){
                case "Teacher"?:
                    self.performSegue(withIdentifier: "segueGoTeacher", sender: self)
                case "Parent"?:
                    self.performSegue(withIdentifier: "segueGoParent", sender: self)
                case "Manager"?:
                    self.performSegue(withIdentifier: "segueGoManager", sender: self)
                default:

                    self.txtPassword.isEnabled = true
                    self.txtEmail.isEnabled = true
                    self.btnLoginOutlet.isEnabled = true
                
                     }
                }
            })
        }
    }

