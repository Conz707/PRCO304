//
//  CreateUserViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 26/03/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet var pickerUserType: UIPickerView!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtTelephoneNumber: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtSurname: UITextField!
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet weak var txtDropdown: UITextField!
    
    @IBOutlet weak var btnCancelOutlet: UIButton!
    @IBOutlet weak var btnEditUserOutlet: UIButton!
    var selectedUser : User = User()
    var postString = ""
    var typesOfUser = ["Parent", "Teacher"]
    var pickerData: [String] = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        txtSurname.autocapitalizationType = .words
        txtFirstName.autocapitalizationType = .words
        
        
        if(selectedUser.FirstName != nil){  //if user then prep for editing
            print("user selected \(selectedUser.FirstName)")
            txtEmail.text = selectedUser.Email
            txtSurname.text = selectedUser.Surname
            txtTelephoneNumber.text = selectedUser.TelephoneNumber
            txtFirstName.text = selectedUser.FirstName
            txtDropdown.text = selectedUser.UserType
            btnEditUserOutlet.isHidden = false
            btnCancelOutlet.isHidden = false
            

                        print("found selected user")
        } else {        //else if no user prep for creating
            
            print("no selected user")
            txtEmail.isEnabled = true
            txtSurname.isEnabled  = true
            txtPassword.isEnabled  = true
            txtTelephoneNumber.isEnabled  = true
            txtFirstName.isEnabled  = true
            txtDropdown.isEnabled = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnEditUser(_ sender: Any) {
        txtEmail.isEnabled = true
        txtSurname.isEnabled  = true
        txtPassword.isEnabled  = true
        txtTelephoneNumber.isEnabled  = true
        txtFirstName.isEnabled = true
        btnCancelOutlet.isEnabled = true
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        viewDidLoad()
        
        
        txtEmail.isEnabled = false
        txtSurname.isEnabled  = false
        txtPassword.isEnabled  = false
        txtTelephoneNumber.isEnabled  = false
        txtFirstName.isEnabled  = false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typesOfUser.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return typesOfUser[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
            self.txtDropdown.text = typesOfUser[row]
            self.pickerUserType.isHidden = true
 
    }
    


func textFieldDidBeginEditing(_ textField: UITextField) {
    if (textField == self.txtDropdown){
        self.pickerUserType.isHidden = false
        self.view.endEditing(true)
    }
}
    
    
    @IBAction func btnSave(_ sender: Any) {
        
       
        let firstName = txtFirstName.text
        let surname = txtSurname.text
        let email = txtEmail.text
        let telephoneNumber = txtTelephoneNumber.text
        let password = txtPassword.text
        let userType = txtDropdown.text
        
        if(selectedUser.FirstName != nil){    //if  selecter used then edit
            postString = "AddOrEdit=Edit&U_ID=\(selectedUser.U_ID!)&FirstName=\(firstName!)&Surname=\(surname!)&Email=\(email!)&TelephoneNumber=\(telephoneNumber!)&Password=\(password!)&UserType=\(userType!)"

        } else {                    //if no selected user then add
            postString = "AddOrEdit=Add&FirstName=\(firstName!)&Surname=\(surname!)&Email=\(email!)&TelephoneNumber=\(telephoneNumber!)&Password=\(password!)&UserType=\(userType!)"
            print(postString)

        }
       
      
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/ManagerSidePHPFiles/AddOrEditUser.php")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        print(postString)
        
        utilities.postRequest(postString: postString, request: request) { success, data in
        }

        
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
        
}
