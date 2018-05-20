//
//  CreateUserViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 26/03/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class CreateOrEditUserViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    
    
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
    var addOrEdit = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        txtSurname.autocapitalizationType = .words
        txtFirstName.autocapitalizationType = .words
        
        
        if(selectedUser.FirstName != nil){  //if user then prep for editing
            txtEmail.text = selectedUser.Email
            txtSurname.text = selectedUser.Surname
            txtTelephoneNumber.text = selectedUser.TelephoneNumber
            txtFirstName.text = selectedUser.FirstName
            txtDropdown.text = selectedUser.UserType
            btnEditUserOutlet.isHidden = false
            btnCancelOutlet.isHidden = false
            

        } else {        //else if no user prep for creating
            
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
    
    @IBAction func btnEditUser(_ sender: Any) {     //enable text fields
        txtEmail.isEnabled = true
        txtSurname.isEnabled  = true
        txtPassword.isEnabled  = true
        txtTelephoneNumber.isEnabled  = true
        txtFirstName.isEnabled = true
        btnCancelOutlet.isEnabled = true
    }
    
    @IBAction func btnCancel(_ sender: Any) {       //reset view
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {        //when select from picker, fill text box and hide picker
        
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
        
        if((txtFirstName.text?.isEmpty)! || (txtSurname.text?.isEmpty)! || (txtEmail.text?.isEmpty)! || (txtTelephoneNumber.text?.isEmpty)! || (txtPassword.text?.isEmpty)! || (txtDropdown.text?.isEmpty)!){
        let alert = utilities.normalAlertBox(alertTitle: "ERROR", messageString: "Ensure all fields filled in")
            self.present(alert, animated: true, completion: nil)
        } else {
            if(checkValidInputs()){     //ensure input valid
                if(selectedUser.FirstName != nil){ //if  selecter used then edit
                    editUser()
                } else {
                    addUser()         //if no selected user then add
                }
 
            } else {
                let alert = utilities.normalAlertBox(alertTitle: "ERROR", messageString: "Ensure all inputs correct format")
                
            self.present(alert, animated: true, completion: nil)
            }
        }

        }
    
    func addUser(){     //ran if user not selected then adds to db
        
        let firstName = txtFirstName.text
        let surname = txtSurname.text
        let email = txtEmail.text
        let telephoneNumber = txtTelephoneNumber.text
        let password = txtPassword.text
        let userType = txtDropdown.text


            postString = "AddOrEdit=Add&FirstName=\(firstName!)&Surname=\(surname!)&Email=\(email!)&TelephoneNumber=\(telephoneNumber!)&Password=\(password!)&UserType=\(userType!)"
                addOrEdit = "added"
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/ManagerSidePHPFiles/AddOrEditUser.php")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        utilities.postRequest(postString: postString, request: request) { success, data, responseString in
            if(responseString == "ERROR"){      //if error then email already exists within database
                let alert = utilities.normalAlertBox(alertTitle: "ERROR", messageString: "User with this email already registered.")
                
                self.present(alert, animated: true, completion: nil)
            } else {
                
                let alert = utilities.normalAlertBox(alertTitle: "Success", messageString: "Successfully \(self.addOrEdit) User")
                self.present(alert, animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }

    }
    
    func editUser(){         //ran if user  selected then edits in db
        
        let firstName = txtFirstName.text
        let surname = txtSurname.text
        let email = txtEmail.text
        let telephoneNumber = txtTelephoneNumber.text
        let password = txtPassword.text
        let userType = txtDropdown.text
        
        
            postString = "AddOrEdit=Edit&U_ID=\(selectedUser.U_ID!)&FirstName=\(firstName!)&Surname=\(surname!)&Email=\(email!)&TelephoneNumber=\(telephoneNumber!)&Password=\(password!)&UserType=\(userType!)"
            addOrEdit = "edited"

        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/ManagerSidePHPFiles/AddOrEditUser.php")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        utilities.postRequest(postString: postString, request: request) { success, data, responseString in
            if(responseString == "ERROR"){      //if error then email already exists within database
                let alert = utilities.normalAlertBox(alertTitle: "ERROR", messageString: "User with this email already registered.")
                
                self.present(alert, animated: true, completion: nil)
            } else {
                
                let alert = utilities.normalAlertBox(alertTitle: "Success", messageString: "Successfully \(self.addOrEdit) User")
                self.present(alert, animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func checkValidInputs() -> Bool{        //use utilities function to compare text to RegEx
        
        let checkEmail = utilities.checkInputValid(type: "Email", input: txtEmail.text!)
        let checkFirstName = utilities.checkInputValid(type: "Name", input: txtFirstName.text!)
        let checkSurname = utilities.checkInputValid(type: "Name", input: txtSurname.text!)
        let checkTelNum = utilities.checkInputValid(type: "TelNum", input: txtTelephoneNumber.text!)
        let checkPassword = utilities.checkInputValid(type: "Password", input: txtPassword.text!)
        
        if(!checkSurname || !checkEmail || !checkFirstName || !checkTelNum || !checkPassword)
        {
            return false
        } else {
            return true
            
        }
        
    }

}
