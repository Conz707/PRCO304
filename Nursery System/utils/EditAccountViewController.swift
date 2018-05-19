//
//  AccountDetailsViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 05/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class EditAccountViewController: UIViewController {

    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtReEnterPassword: UITextField!
    @IBOutlet var txtNewPassword: UITextField!
    let defaultValues = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changePassword(_ sender: Any) {
        
        if((txtNewPassword.text?.isEmpty)! || (txtReEnterPassword.text?.isEmpty)! || (txtPassword.text?.isEmpty)!){     ////check fields entered
            let alert = utilities.normalAlertBox(alertTitle: "ERROR", messageString: "Ensure all fields filled in")
            self.present(alert, animated: true, completion: nil)
            
        } else if (txtPassword.text != txtReEnterPassword.text){            //check password and reenter password match
                let alert = utilities.normalAlertBox(alertTitle: "ERROR", messageString: "Passwords do not match")
                self.present(alert, animated: true, completion: nil)
            
        } else if (checkValidInputs()){
            //check valid password inputs
            let email = defaultValues.string(forKey: "UserEmail")
            let postString = "Email=\(email!)&Password=\(txtPassword.text!)&NewPassword=\(txtNewPassword.text!)"
            var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/PasswordChange.php")!)
            request.httpMethod = "POST"
            request.httpBody = postString.data(using: .utf8)
            
            utilities.postRequest(postString: postString, request: request, completion: { success, data, responseString in
           
                if(responseString != "Success"){        //if response != success then password doesnt match database
                    let alert = utilities.normalAlertBox(alertTitle: "ERROR", messageString: "Password incorrect.")
                    self.present(alert, animated: true, completion: nil)
                } else {        //else success then change users password
                    let alert = utilities.normalAlertBox(alertTitle: "Success", messageString: "Password has been changed successfully.")
                        self.present(alert, animated: true, completion: nil)
                }
            })
        } else {
            let alert = utilities.normalAlertBox(alertTitle: "ERROR", messageString: "Invalid password. Ensure it is 6-18 characters and alphanumeric ")
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    
    func checkValidInputs() -> Bool{        //use utilities function to compare text to RegEx
        
        let checkPassword = utilities.checkInputValid(type: "Password", input: txtPassword.text!)
        let checkReEnterPassword = utilities.checkInputValid(type: "Password", input: txtReEnterPassword.text!)
        let checkNewPassword = utilities.checkInputValid(type: "Password", input: txtNewPassword.text!)
        
        if(!checkPassword || !checkReEnterPassword || !checkNewPassword){

             return false
        } else {
            return true
        }
        
    }
}
 
