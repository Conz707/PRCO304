//
//  ParentTeacherMeetingViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 10/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit



class ParentTeacherMeetingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var txtDropdown: UITextField!
    @IBOutlet var lblStudent: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var pickerDropdown: UIPickerView!
    @IBOutlet var tblMeetings: UITableView!
    
    var feedItems: NSArray = NSArray()
    var selectedStudent : Student = Student()
    let defaultValues = UserDefaults.standard
    var U_ID = ""
    var parents = [Parent]()
    var meetings = [Meeting]()
    var selectedParentID = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblStudent.text = "\(selectedStudent.FirstName!) \(selectedStudent.Surname!)"
        datePicker.minimumDate = datePicker.date
        U_ID = defaultValues.string(forKey: "UserU_ID")!
        getMeetings()
        getParentsDropdown()

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

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (parents.count > 0 && parents.count >= row){
            self.txtDropdown.text = "\(parents[row].FirstName!) \(parents[row].Surname!) " as? String
            selectedParentID = parents[row].U_ID!
            self.pickerDropdown.isHidden = true
            print("text box should display \(self.parents[row])")
            print("selected parent id \(self.parents[row].U_ID)")
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.txtDropdown){    //ask nick about this
           print("working")
            self.pickerDropdown.isHidden = false
            self.view.endEditing(true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnAddMeeting(_ sender: Any) {
        if(txtDropdown.text?.isEmpty == false){
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/CreateParentTeacherMeeting.php")!)
        request.httpMethod = "POST"
        let postString = ("S_ID=\(selectedStudent.S_ID!)&Parent_ID=\(selectedParentID)&Teacher_ID=\(U_ID)&Date=\(datePicker.date)")
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        
        let postRequest = utilities.postRequest(postString: postString, request: request, completion: { success, data in
            print("finished record insert??")
            self.getMeetings()
        })
            
        } else {
            print("NEED AN ERROR HERE")
        }
    }
    
    func itemsDownloaded(items: NSArray){
        feedItems = items
        tblMeetings.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //retrieve cell
        let cellIdentifier: String = "BasicCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        //get activity to show
        let item: Meeting = self.feedItems[indexPath.row] as! Meeting
        print("items!!!! \(item)")
        myCell.textLabel!.text = "Meeting on     \(item.Date!)"
        return myCell
    }
    
    func getMeetings(){
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/GetStudentMeetings.php")!)
        request.httpMethod = "POST"
        let postString = ("S_ID=\(selectedStudent.S_ID!)")
        print(postString)
        request.httpBody = postString.data(using: .utf8)

        let postRequest = utilities.postRequest(postString: postString, request: request, completion: { success, data  in
            do {
                self.meetings = try JSONDecoder().decode(Array<Meeting>.self, from: data)
                for eachMeeting in self.meetings {
                    print("\(eachMeeting.Date)")
                }
            } catch {
                print(error)
                print("ERROR")
            }
            DispatchQueue.main.async {
                self.itemsDownloaded(items: self.meetings as NSArray)
                print("trying to print items downloaded \(self.meetings)")
            }

        })
    }
    
  func getParentsDropdown(){
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/GetParentsDropdown.php")!)
        request.httpMethod = "POST"
        let postString = ("S_ID=\(selectedStudent.S_ID!)")
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        
        let postRequest = utilities.postRequest(postString: postString, request: request, completion: { success, data in
        do {
            self.parents = try JSONDecoder().decode(Array<Parent>.self, from: data)
            print(self.parents)
            for eachParent in self.parents {
                print("\(eachParent.FirstName!) \(eachParent.Surname!)")
            }
        } catch {
            print(error)
            print("ERROR")
        }
        DispatchQueue.main.async {
            self.pickerDropdown.reloadComponent(0)
        }

        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "meetingDetailsSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let meetingDetailsVC = segue.destination as! MeetingDetailsViewController
        
        //     meetingDetailsVC.selectedMeeting = selectedMeeting!
    }

    
}
