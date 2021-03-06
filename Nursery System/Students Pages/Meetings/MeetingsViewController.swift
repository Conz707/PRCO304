//
//  ParentTeacherMeetingViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 10/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit



class MeetingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var activityIndicatorTableLoading: UIActivityIndicatorView!
    @IBOutlet var txtDropdown: UITextField!
    @IBOutlet var lblStudent: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var pickerDropdown: UIPickerView!
    @IBOutlet var tblMeetings: UITableView!
    @IBOutlet var segmentedMeetings: UISegmentedControl!
    
    var feedItems: NSArray = NSArray()
    var selectedStudent : Student = Student()
    var selectedMeeting : Meeting = Meeting()
    let defaultValues = UserDefaults.standard
    var U_ID = ""
    var parents = [User]()
    var meetings = [Meeting]()
    var selectedParentID = ""
    var postString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblStudent.text = "\(selectedStudent.FirstName!) \(selectedStudent.Surname!)"
        datePicker.minimumDate = datePicker.date
        U_ID = defaultValues.string(forKey: "UserU_ID")!
        getParentsDropdown()
        activityIndicatorTableLoading.hidesWhenStopped = true
        let minDate = Date()
        datePicker.minimumDate = minDate

        // Do any additional setup after loading the view.
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.parents.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "\(parents[row].FirstName!) \(parents[row].Surname!)"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {                //change text to picked item from picker view and hide picker
        if (parents.count > 0 && parents.count >= row){
            self.txtDropdown.text = "\(parents[row].FirstName!) \(parents[row].Surname!) "
            selectedParentID = parents[row].U_ID!
            self.pickerDropdown.isHidden = true
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {           //when text field tapped dont show keyboard and unhide picker view
        if (textField == self.txtDropdown){    //ask nick about this
            self.pickerDropdown.isHidden = false
            self.view.endEditing(true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnAddMeeting(_ sender: Any) {
        if(txtDropdown.text?.isEmpty == false){         //ensure parent selected for meeting
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/CreateParentTeacherMeeting.php")!)
        request.httpMethod = "POST"
        let postString = ("S_ID=\(selectedStudent.S_ID!)&Parent_ID=\(selectedParentID)&Teacher_ID=\(U_ID)&Date=\(datePicker.date)")
        request.httpBody = postString.data(using: .utf8)
        
        utilities.postRequest(postString: postString, request: request, completion: { success, data, responseString in
            DispatchQueue.main.async{

                self.present(utilities.normalAlertBox(alertTitle: "Success", messageString: "Successfully created meeting"), animated: true)
                self.segmentChangeTable((Any).self)             //reload table with new data

            }
        })
            
        } else {
            
        self.present(utilities.normalAlertBox(alertTitle: "Error", messageString: "Ensure parent selected for meeting"), animated: true)
                    self.segmentChangeTable((Any).self)
        }
    }
    
    @IBAction func segmentChangeTable(_ sender: Any) {      //change SQL query
        
        activityIndicatorTableLoading.startAnimating()
        switch segmentedMeetings.selectedSegmentIndex{
        case 0:
            postString = "S_ID=\(selectedStudent.S_ID!)&querySelector=Upcoming"
        case 1:
            postString = "S_ID=\(selectedStudent.S_ID!)&querySelector=Completed"
        case 2:
            postString = "S_ID=\(selectedStudent.S_ID!)&querySelector=All"
        default:
            segmentedMeetings.selectedSegmentIndex = 0
        }
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/GetStudentMeetings.php")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        utilities.postRequest(postString: postString, request: request, completion: { success, data, responseString in      //fill meetings array with users meetings
            do {
                self.meetings = try JSONDecoder().decode(Array<Meeting>.self, from: data)
                for eachMeeting in self.meetings {
                    print("\(eachMeeting.Date!)")
                }
            } catch {
                print(error)
                print("ERROR")
            }
            DispatchQueue.main.async {          //display meetings from array
                self.itemsDownloaded(items: self.meetings as NSArray)
                print("trying to print items downloaded \(self.meetings)")
            }
            
        })
    }
    
    func itemsDownloaded(items: NSArray){
        feedItems = items
        tblMeetings.reloadData()
        activityIndicatorTableLoading.stopAnimating()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {            //prepare and display table
        //retrieve cell
        let cellIdentifier: String = "BasicCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        //get activity to show
        let item: Meeting = self.feedItems[indexPath.row] as! Meeting
        print("items!!!! \(item)")
        myCell.textLabel!.text = "Meeting on \(item.Date!)"
        return myCell
    }
    
  func getParentsDropdown(){                //get the parents of a selected student for the picker
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/GetParentsDropdown.php")!)
        request.httpMethod = "POST"
        let postString = ("S_ID=\(selectedStudent.S_ID!)")
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        
        utilities.postRequest(postString: postString, request: request, completion: { success, data, responseString in      //add parents to an array
        do {
            self.parents = try JSONDecoder().decode(Array<User>.self, from: data)
            print(self.parents)
            for eachParent in self.parents {
                print("\(eachParent.FirstName!) \(eachParent.Surname!)")
            }
        } catch {
            print(error)
            print("ERROR")
        }
        DispatchQueue.main.async {
            self.pickerDropdown.reloadComponent(0)          //reload picker once data retrieved
        }

        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        segmentChangeTable((Any).self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {     //find which student is assigned in meeting and prepare for segue

        print(selectedMeeting)
        
        selectedMeeting = feedItems[indexPath.row] as! Meeting
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/GetSelectedStudent.php")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        print(postString)
        utilities.postRequest(postString: postString, request: request, completion: { success, data, responseString in
            
            do {
                print(data)
                let student = try JSONDecoder().decode(Student.self, from: data)
                self.selectedStudent = student
                DispatchQueue.main.async{
                    self.performSegue(withIdentifier: "meetingDetailsSegue", sender: Any?.self)
                }
            } catch {
                print(error)
                print("ERROR")
                
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let meetingDetailsVC = segue.destination as! MeetingDetailsViewController
        
        meetingDetailsVC.selectedMeeting = selectedMeeting
        meetingDetailsVC.selectedStudent = selectedStudent  
        print(selectedMeeting)
    }

    
}
