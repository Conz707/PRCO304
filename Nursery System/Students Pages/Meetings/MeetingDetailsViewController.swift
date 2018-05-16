//
//  ReviewMeetingViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 24/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class MeetingDetailsViewController: UIViewController {

    
    
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var btnCompletedOutlet: UIButton!
    @IBOutlet var txtNotes: UITextView!
    @IBOutlet var lblParentName: UILabel!
    @IBOutlet var lblStudentName: UILabel!
    var selectedStudent : Student = Student()
    var parents = [User]()
    var selectedMeeting : Meeting = Meeting()
    var postString = ""
    var defaultValues = UserDefaults.standard
    var completed = false
    
    @IBOutlet var btnCancelOutlet: UIButton!
    @IBOutlet var btnSaveOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if(defaultValues.string(forKey: "UserRole") == "Parent"){
            btnSaveOutlet.isHidden = true
            btnCancelOutlet.isHidden = true
        } else {
            btnSaveOutlet.isHidden = false
            btnCancelOutlet.isHidden = false
        }
        
        getParent()
        
        print(selectedStudent.description)
         lblStudentName.text = "\(selectedStudent.FirstName!) \(selectedStudent.Surname!)"
        print("\(selectedMeeting.M_ID!) \(selectedStudent.FirstName!)")
        lblDate.text = selectedMeeting.Date
        self.txtNotes.text = (self.selectedMeeting.Notes!)
        print(selectedMeeting.Notes)
        print(selectedMeeting.Notes!)
        checkCompleted { success in
            if(self.completed == true){
                self.btnCompletedOutlet.setImage(UIImage(named: "checked box"), for: .normal)
            } else {
                self.btnCompletedOutlet.setImage(UIImage(named: "unchecked box"), for: .normal)
            }
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCompleted(_ sender: Any) {
        if(completed == true){
            btnCompletedOutlet.setImage(UIImage(named: "unchecked box"), for: .normal)
            completed = false
        } else {
            btnCompletedOutlet.setImage(UIImage(named: "checked box"), for: .normal)
            completed = true
        }
    }

    
    @IBAction func btnCancelMeeting(_ sender: Any) {
deleteAlert()
    }
    
    
    @IBAction func btnSaveMeeting(_ sender: Any) {
saveAlert()
    }
   
    func cancelMeeting(){
    var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/CancelMeeting.php")!)
    request.httpMethod = "POST"
    postString = ("M_ID=\(selectedMeeting.M_ID)")
    
    request.httpBody = postString.data(using: .utf8)
    
    postRequest(postString: postString, request: request, completion: { success in
    })
}
    
    func deleteAlert(){
        let alert = UIAlertController(title: "Confirm Cancel Meeting - This action can NOT be undone.", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            //delete activity
            self.cancelMeeting()
            
            let alertDeleteSuccess = UIAlertController(title: "Successfully deleted meeting", message: nil, preferredStyle: .actionSheet)
            
            //return view
            alertDeleteSuccess.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            
            if let popoverController = alertDeleteSuccess.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            self.present(alertDeleteSuccess, animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveAlert(){
        let alert = UIAlertController(title: "Are you sure you would like to save meeting notes?", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            //delete activity
            self.saveMeetingNotes()
            
            let alertDeleteSuccess = UIAlertController(title: "Successfully saved meeting", message: nil, preferredStyle: .actionSheet)
            
            //return view
            alertDeleteSuccess.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            
            if let popoverController = alertDeleteSuccess.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            self.present(alertDeleteSuccess, animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func saveMeetingNotes(){
        
        var meetingCompleted = 0
        
        if(completed == true){
            meetingCompleted = 1
        }
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/SaveMeetingDetails.php")!)
        postString = "M_ID=\(selectedMeeting.M_ID!)&Notes=\(txtNotes.text!)&Completed=\(meetingCompleted)"
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        utilities.postRequest(postString: postString, request: request, completion: { success, data, responseString in
            
            do {
                let parent = try JSONDecoder().decode(User.self, from: data)
                print("parent firstname \(parent.FirstName)")
                DispatchQueue.main.async{
                    self.lblParentName.text = "\(parent.FirstName!) \(parent.Surname!)"
                }
            } catch {
                print(error)
                print("ERROR")
            }
            
        })
    }
    
    
    func getParent(){
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/GetMeetingParent.php")!)
        postString = "U_ID=\(selectedMeeting.Parent_ID!)"
        print("memes \(postString)")
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        utilities.postRequest(postString: postString, request: request, completion: { success, data, responseString in
            
            do {
                let parent = try JSONDecoder().decode(User.self, from: data)
                print("parent firstname \(parent.FirstName)")
                DispatchQueue.main.async{
                    self.lblParentName.text = "\(parent.FirstName!) \(parent.Surname!)"
                }
            } catch {
                print(error)
                print("ERROR")
            }
            
        })
    }

    
    func checkCompleted(completion: @escaping (_ success : Bool) -> ()){

        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/CheckCompleted.php")!)
        request.httpMethod = "POST"
        
        let postString = ("M_ID=\(selectedMeeting.M_ID!)")
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        
        postRequest(postString: postString, request: request, completion: { success in
            completion(success)
        })
        
    }
    
    func postRequest(postString: String, request: URLRequest, completion: @escaping (_ success : Bool) -> ()){  //extends postrequest but dk how to do that using utilities
        print(postString, request)
        var success = true
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                success = false
            }
            
            var responseString = String(data: data, encoding: .utf8)!
            print("responseString = \(responseString)")
            if(responseString == "true"){
                self.completed = true
            } else {
                self.completed = false
            }
            DispatchQueue.main.async{
                completion(success)
            }
        }
        task.resume()
        print("no here")
    }

}
