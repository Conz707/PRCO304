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
    var parents = [Parent]()
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
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/CreateParentTeacherMeeting.php")!)
        request.httpMethod = "POST"
        let postString = ("S_ID=\(selectedStudent.S_ID!)&Parent_ID=\(selectedParentID)&Teacher_ID=\(U_ID)&Date=\(datePicker.date)")
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        
        let postRequest = utilities.postRequest(postString: postString, request: request, completion: { success, data in
            let alertController = UIAlertController(title: "Success", message: "Successfully created meeting", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Close Alert", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)

        })
            
        } else {
            let alertController = UIAlertController(title: "Error", message: "Ensure parent selected for meeting", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Close Alert", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
                    self.segmentChangeTable((Any).self)
    }
    
    @IBAction func segmentChangeTable(_ sender: Any) {
        
        activityIndicatorTableLoading.startAnimating()
        switch segmentedMeetings.selectedSegmentIndex{
        case 0:
            postString = "S_ID=\(selectedStudent.S_ID!)&querySelector=Upcoming"
            print(postString)
            print("111111")
        case 1:
            postString = "S_ID=\(selectedStudent.S_ID!)&querySelector=Completed"
            print(postString)
        case 2:
            postString = "S_ID=\(selectedStudent.S_ID!)&querySelector=All"
            print(postString)
        default:
            print("default")
            segmentedMeetings.selectedSegmentIndex = 0
        }
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/GetStudentMeetings.php")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        let postRequest = utilities.postRequest(postString: postString, request: request, completion: { success, data in
            do {
                self.meetings = try JSONDecoder().decode(Array<Meeting>.self, from: data)
                for eachMeeting in self.meetings {
                    print("\(eachMeeting.Date!)")
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
    
    func itemsDownloaded(items: NSArray){
        feedItems = items
        tblMeetings.reloadData()
        activityIndicatorTableLoading.stopAnimating()
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
        myCell.textLabel!.text = "Meeting on \(item.Date!)"
        return myCell
    }
    
  func getParentsDropdown(){
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/GetParentsDropdown.php")!)
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
    
    override func viewDidAppear(_ animated: Bool) {
        segmentChangeTable((Any).self)
                print("WTF \(selectedStudent.S_ID)")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print(selectedMeeting)
        
        selectedMeeting = feedItems[indexPath.row] as! Meeting
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/GetSelectedStudent.php")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        print(postString)
        let postRequest = utilities.postRequest(postString: postString, request: request, completion: { success, data in
            
            do {
                print(data)
                let student = try JSONDecoder().decode(Student.self, from: data)
                self.selectedStudent = student
                print(student.description)
                print(self.selectedStudent.description)
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
