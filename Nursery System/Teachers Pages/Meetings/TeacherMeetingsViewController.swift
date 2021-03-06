//
//  MeetingsViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 23/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit


class TeacherMeetingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet var activityIndicatorTableLoading: UIActivityIndicatorView!
    @IBOutlet var segmentedMeetings: UISegmentedControl!
    @IBOutlet var tblMeetings: UITableView!
    var defaultValues = UserDefaults.standard
    var userID = ""
    var postString = ""
    var feedItems: NSArray = NSArray()
    var meetings = [Meeting]()
  //  var selectedMeeting : Meeting = Meeting()
    var selectedStudent : Student = Student()
    var selectedMeeting : Meeting = Meeting()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userID = defaultValues.string(forKey: "UserU_ID")!
 
        activityIndicatorTableLoading.hidesWhenStopped = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
               segmentChangeTable((Any).self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        myCell.textLabel!.text = "Meeting on  \(item.Date!)"
        return myCell
    }
    
    @IBAction func segmentChangeTable(_ sender: Any) {      //change the sql query to pull data in grouping
    activityIndicatorTableLoading.startAnimating()
        switch segmentedMeetings.selectedSegmentIndex{
        case 0:
            postString = "U_ID=\(userID)&querySelector=Upcoming"
        case 1:
            postString = "U_ID=\(userID)&querySelector=Completed"
        case 2:
            postString = "U_ID=\(userID)&querySelector=All"
        default:
            segmentedMeetings.selectedSegmentIndex = 1
        }
        
        decodeMeetings(postString: postString)
        

    }
    
    func decodeMeetings(postString: String){        //get all meetings for the teacher
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/GetMyMeetings.php")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        utilities.postRequest(postString: postString, request: request, completion: { success, data, responseString in
            do {
                self.meetings = try JSONDecoder().decode(Array<Meeting>.self, from: data)
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                self.itemsDownloaded(items: self.meetings as NSArray)
            }
            
        })
    }
    
    func itemsDownloaded(items: NSArray){
        feedItems = items
        activityIndicatorTableLoading.stopAnimating()
        tblMeetings.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {         //set selected meeting to the row selected and select the student that is assigned to that meeting
        
        
        
        selectedMeeting = feedItems[indexPath.row] as! Meeting
        getSelectedStudent()
    //
    }
    
    func getSelectedStudent(){          //get selected student to pass in to the meeting details
    
        
        postString = "S_ID=\(selectedMeeting.S_ID!)"
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/GetSelectedStudent.php")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        utilities.postRequest(postString: postString, request: request, completion: { success, data, responseString in
            
            do {
                let student = try JSONDecoder().decode(Student.self, from: data)
                self.selectedStudent = student
                DispatchQueue.main.async{
                    self.performSegue(withIdentifier: "meetingDetailsSegue", sender: Any?.self)
                }
            } catch {
                print(error)
                
            }
            
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let meetingDetailsVC = segue.destination as! MeetingDetailsViewController
       
        meetingDetailsVC.selectedStudent = selectedStudent
        meetingDetailsVC.selectedMeeting = selectedMeeting

    }
    
    

}
