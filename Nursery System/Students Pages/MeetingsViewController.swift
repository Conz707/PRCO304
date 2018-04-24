//
//  MeetingsViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 23/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit


class MeetingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

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
        segmentChangeTable((Any).self)
        activityIndicatorTableLoading.hidesWhenStopped = true
        // Do any additional setup after loading the view.
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
        print("items!!!! \(item)")
        myCell.textLabel!.text = "Meeting on  \(item.Date!)"
        return myCell
    }
    
    @IBAction func segmentChangeTable(_ sender: Any) {
    activityIndicatorTableLoading.startAnimating()
        if(segmentedMeetings.selectedSegmentIndex == 0){

            postString = "U_ID=\(userID)&querySelector=Upcoming"

            
        } else if(segmentedMeetings.selectedSegmentIndex == 1){
            postString = "U_ID=\(userID)&querySelector=Completed"
            
        } else if(segmentedMeetings.selectedSegmentIndex == 2){
                postString = "U_ID=\(userID)&querySelector=All"
        }
       var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/GetMyMeetings.php")!)
        request.httpMethod = "POST"
                request.httpBody = postString.data(using: .utf8)
        postRequest(postString: postString, request: request, completion: { success, data in
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
                   activityIndicatorTableLoading.stopAnimating()
        tblMeetings.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        selectedMeeting = feedItems[indexPath.row] as! Meeting

            postString = "S_ID=\(selectedMeeting.S_ID!)"
            var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/GetSelectedStudent.php")!)
            request.httpMethod = "POST"
            request.httpBody = postString.data(using: .utf8)
            print(postString)
            postRequest(postString: postString, request: request, completion: { success, data in
                
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
    //
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let meetingDetailsVC = segue.destination as! MeetingDetailsViewController
       
        meetingDetailsVC.selectedStudent = selectedStudent
        meetingDetailsVC.selectedMeeting = selectedMeeting

    }
    
    
    
    func postRequest(postString: String, request: URLRequest, completion: @escaping (_ success : Bool, _ data: Data) -> ()){
        
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
            completion(success, data)
        }
        task.resume()
    }
}
