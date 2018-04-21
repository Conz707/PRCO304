//
//  ParentTeacherMeetingViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 10/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class ParentTeacherMeetingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    @IBOutlet var txtDropdwon: UITextField!
    @IBOutlet var lblStudent: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var pickerDropdown: UIPickerView!
    var selectedStudent : StudentsModel = StudentsModel()
    let defaultValues = UserDefaults.standard
    var U_ID = ""
    var parentValues: [AnyObject] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblStudent.text = "\(selectedStudent.firstName!) \(selectedStudent.surname!)"
        datePicker.minimumDate = datePicker.date
        U_ID = defaultValues.string(forKey: "UserU_ID")!

        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.parentValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let titleRow = (parentValues[row] as? String)!
        
        return titleRow
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (parentValues.count > 0 && parentValues.count >= row){
            self.txtDropdwon.text = self.parentValues[row] as? String
            self.pickerDropdown.isHidden = true
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (txtDropdwon == self.pickerDropdown){    //ask nick about this
            self.pickerDropdown.isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnAddMeeting(_ sender: Any) {
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/CreateParentTeacherMeeting.php")!)
        request.httpMethod = "POST"
        let postString = ("S_ID=\(selectedStudent.studentID!)&Parent_ID=2&Teacher_ID=\(U_ID)&Date=\(datePicker.date)")
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        
        postRequest(postString: postString, request: request, completion: { success in
            print("finished record insert??")
        })
    }
    
    
    @IBAction func parentTapped(_ sender: Any) {

        guard let title = (sender as AnyObject).currentTitle, let parent = Parents(rawValue: title!) else {
            return
        }
        
        switch parent {
        case .mother:
            print("mother")
        case .father:
            print("father")
        default:
            print("kys")
        }
    }
    
    enum Parents: String {
        case mother = "Mother"
        case father = "Father"
    }
    
    func getParentsDropdown(){
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/GetParentsDropdown.php")!)
        request.httpMethod = "POST"
        let postString = ("S_ID=\(selectedStudent.studentID!)&Parent_ID=2&Teacher_ID=\(U_ID)&Date=\(datePicker.date)")
        print(postString)
        request.httpBody = postString.data(using: .utf8)
    }

    func postRequest(postString: String, request: URLRequest, completion: @escaping (_ success : Bool) -> ()){
        var success = true
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                success = false
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            var responseString = String(data: data, encoding: .utf8)!
            print("responseString <br /> = \(responseString)")
            
            DispatchQueue.main.async{
                completion(success)
            }
        }
        task.resume()
        print(success)
    }
    
}
