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
    var parents = [Parent]()
    var selectedMeeting : Meeting = Meeting()
    var postString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        getParent()
        
        print(selectedStudent.description)
         lblStudentName.text = "\(selectedStudent.FirstName!) \(selectedStudent.Surname!)"
        //lblParentName.text = "\(selectedMeeting?.Parent_ID)"
        print("\(selectedMeeting.M_ID!) \(selectedStudent.FirstName!)")
        lblDate.text = selectedMeeting.Date
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCompleted(_ sender: Any) {
        //alert Confirm you want to mark this meeting as completed?
    }
    
    func getParent(){
    
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/GetMeetingParent.php")!)
        postString = "U_ID=\(selectedMeeting.Parent_ID!)"
        print("memes \(postString)")
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        let postRequest = utilities.postRequest(postString: postString, request: request, completion: { success, data in
            
            do {
            let parent = try JSONDecoder().decode(Parent.self, from: data)
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

    
}
