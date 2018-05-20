//
//  PasswordRecoveryViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 19/05/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class PasswordRecoveryViewController: UIViewController {

    @IBOutlet var txtSurname: UITextField!
    @IBOutlet var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSendPasswordRecovery(_ sender: Any) {
        if((txtEmail.text?.isEmpty)! || (txtSurname.text?.isEmpty)!){           //ensure fields arent empty
           let alert = utilities.normalAlertBox(alertTitle: "ERROR", messageString: "Ensure both fields are filled in")
            self.present(alert, animated: true, completion: nil)
        } else {
            if(checkValidInputs()){
                
                let postString = ("Email=\(txtEmail.text!)&Surname=\(txtSurname.text!)")      //ensure fields are valid input
                var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/PasswordRecovery.php")!)
                request.httpMethod = "POST"
                request.httpBody = postString.data(using: .utf8)
                utilities.postRequest(postString: postString, request: request, completion: { success, data, responseString in
                    if(responseString != "Success"){
                        let alert = utilities.normalAlertBox(alertTitle: "ERROR", messageString: "Details incorrect")       //if error then incorrect details
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = utilities.normalAlertBox(alertTitle: "Success", messageString: "A new password has been emailed to you")       //if success alert to check emails
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            } else {
                let alert = utilities.normalAlertBox(alertTitle: "ERROR", messageString: "Invalid characters")
                self.present(alert, animated: true, completion: nil)
            }
            
            
        }
    }
    
    
    func checkValidInputs() -> Bool{        //use utilities function to compare text to RegEx
        
        let checkEmail = utilities.checkInputValid(type: "Email", input: txtEmail.text!)
        
        let checkSurname = utilities.checkInputValid(type: "Name", input: txtSurname.text!)
        
        if(!checkSurname || !checkEmail)
        {
            return false
        } else {
            return true
            
        }
        
    }


}
