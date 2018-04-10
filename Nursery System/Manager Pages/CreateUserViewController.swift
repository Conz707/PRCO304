//
//  CreateUserViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 26/03/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class CreateUserViewController: UIViewController {

    @IBOutlet var pickerUserType: UIPickerView!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtTelephoneNumber: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtSurname: UITextField!
    @IBOutlet var txtFirstName: UITextField!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func FinalizeCreation(_ sender: Any) {
        
       
        
        
        var firstName = txtFirstName.text
        var surname = txtSurname.text
        var email = txtEmail.text
        var telephoneNumber = txtTelephoneNumber.text
        var password = txtPassword.text
        var userType = "Teacher"
        
        
        
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/CreateUser.php")!)
        
        request.httpMethod = "POST"
        
        let postString = "FirstName=\(firstName!)&Surname=\(surname!)&Email=\(email!)&TelephoneNumber=\(telephoneNumber!)&Password=\(password!)&UserType=\(userType)"
        
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
            
            var responseString = String(data: data, encoding: .utf8)!
            print("responseString = \(responseString)")
            
        }
        task.resume()
    }
        
}
