//
//  StudentDetailsViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 06/03/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//
import Foundation
import UIKit


class StudentDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnEditStudentOutlet: UIButton!
    @IBOutlet var btnAddActivity: UIButton!
    @IBOutlet var activityIndicatorTableLoading: UIActivityIndicatorView!
    @IBOutlet var lblDateOfBirth: UILabel!
    @IBOutlet var imgStudent: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMother: UILabel!
    @IBOutlet weak var lblKeyPerson: UILabel!
    @IBOutlet weak var lblGuardian: UILabel!
    @IBOutlet weak var lblFather: UILabel!
    @IBOutlet var tblActivities: UITableView!
    var selectedActivity : Activity = Activity()
    var activities = [Activity]()
    let defaultValues = UserDefaults.standard
    var selectedStudent : Student!
    var feedItems: NSArray = NSArray()
    var responseMother = ""
    var responseArr: [String] = []
    var postString = ""
    var ageGroup = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorTableLoading.hidesWhenStopped = true
        
        setStudentAgeGroup()
        getParentLabels()
        decodeActivities()
        getStudentImage()
        
        

        lblName.text = (selectedStudent.FirstName)! + " " + (selectedStudent.Surname)!
        let formatDate = utilities.formatDateToString(dateString: selectedStudent.DateofBirth!)
        lblDateOfBirth.text = formatDate
        
    }
    
    override func viewDidAppear(_ animated: Bool) { //when reentering view, reload activities - for after adding an activity
        
        decodeActivities()
        
        let checkUserRole = defaultValues.string(forKey: "UserRole")
        if(checkUserRole! == "Parent"){ //only for parents -- manager and teacher should bth see it
            btnAddActivity.isHidden = true
        } else if (checkUserRole == "Manager"){
            btnEditStudentOutlet.isHidden = false
            btnAddActivity.isHidden = false
            } else{
            btnAddActivity.isHidden = false
            
        }
        
        activityIndicatorTableLoading.startAnimating()

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func itemsDownloaded(items: NSArray){ //once items downloaded, reload table and stop animation
        feedItems = items
        tblActivities.reloadData()
        activityIndicatorTableLoading.stopAnimating()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return num of feed items
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {    //getting table cell images and info from URL using utility function
        //retrieve cell
        let cellIdentifier: String = "BasicCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        //get activity to show
        let item: Activity = self.feedItems[indexPath.row] as! Activity
        
        
        utilities.getImages(URL_IMAGE: URL(string: (item.ActivityPicture)!)!, completion: { success, image in
            
            //display the image
            DispatchQueue.main.async{
                myCell.textLabel!.text = item.Activity!
                myCell.imageView!.clipsToBounds = true
                myCell.imageView?.image = image
                
            }
        })
        
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {     //whenever user taps row
        //set selected activity to var
        selectedActivity = feedItems[indexPath.row] as! Activity
        //manually call segue to detail view controller
        self.performSegue(withIdentifier: "viewActivity", sender: self)
    }
    
    @IBAction func btnParentTeacherMeetings(_ sender: Any) {
        
        //manually call segue to detail view controller
        self.performSegue(withIdentifier: "createParentTeacherMeeting", sender: self)
        
    }
    
    
     func getParentLabels(){  //get labels for displaying parents
        
        var success = true
        
        let mother = selectedStudent.Mother
        let father = selectedStudent.Father
        let guardian = selectedStudent.Guardian
        let keyPerson = selectedStudent.KeyPerson
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/GetParentsDetails.php")!)
        
        request.httpMethod = "POST"
        
        let postString = ("Mother=\(mother ?? "")&Father=\(father ?? "")&Guardian=\(guardian ?? "")&KeyPerson=\(keyPerson ?? "")")          //prevents nil values by returning an empty string, prevents php issues
        print(postString)
        
        request.httpBody = postString.data(using: .utf8)
        
        utilities.postRequest(postString: postString, request: request, completion: { success, data, responseString in
            
            self.responseArr = (responseString.split(separator: ";") as NSArray) as! [String]   //splits response string into an array for displaying names of parents and key person
            DispatchQueue.main.async{
                self.lblMother.text = self.responseArr[0]
                self.lblFather.text = self.responseArr[1]
                self.lblGuardian.text = self.responseArr[2]
                self.lblKeyPerson.text = self.responseArr[3]
            }
        })
    }
 

    
    func setStudentAgeGroup(){  //set student age group, used for things such as displaying relevant goals
        
        let formatStringToDate = (utilities.formatStringToDate(dateString: selectedStudent.DateofBirth!))
        
        let ageGroupA = (Calendar.current.date(byAdding: .month, value: -18, to: Date()))!
        let ageGroupB = (Calendar.current.date(byAdding: .month, value: -36, to: Date()))!
        
        
        if(formatStringToDate >= ageGroupA){
            ageGroup = "A"
        } else if (formatStringToDate < ageGroupA && formatStringToDate >= ageGroupB) {
            ageGroup = "B"
        } else {
            ageGroup = "C"
        }
    }
    
    func decodeActivities(){       //decode student's activities into struct
        
        postString = "S_ID=\(selectedStudent.S_ID!)"
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/GetActivities.php")!)
        
        
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        print("poststring \(postString)")
        
        utilities.postRequest(postString: postString, request: request, completion: { success, data, responseString in
            

            do {
                self.activities = try JSONDecoder().decode(Array<Activity>.self, from: data)
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                self.itemsDownloaded(items: self.activities as NSArray)
            }
            
        })
    }
    
    func getStudentImage(){     //perform utility function to get student image from FTP server
        
        utilities.getImages(URL_IMAGE: URL(string: (selectedStudent.StudentPicture)!)!, completion: { success, image in
            
            //display the image
            DispatchQueue.main.async{
                self.imgStudent.image = image
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //preparing selected activities and students
        
        switch(segue.identifier!){
        case "viewActivity":
            //get reference to destination view controller
            
            let viewActivityVC = segue.destination as! ActivityDetailsViewController
            //set property to selected activity so when view loads, it accesses the properties of feeditem obj
            
            viewActivityVC.selectedActivity = selectedActivity
            viewActivityVC.selectedStudent = selectedStudent!
            viewActivityVC.ageGroup = ageGroup
            
            break
            
        case "createActivity":
            //get reference to destination view controller
            
            let createActivityVC = segue.destination as! CreateActivityViewController
            //set property to selected student so when view loads, it accesses the properties of feeditem obj ??
            createActivityVC.selectedStudent = selectedStudent
            createActivityVC.ageGroup = ageGroup
            break
        case "meetingsSegue":
            let meetingVC = segue.destination as! MeetingsViewController
            meetingVC.selectedStudent = selectedStudent
            break
        case "goalsSegue":
            let goalsVC = segue.destination as! GoalsViewController
            goalsVC.selectedStudent = selectedStudent
            goalsVC.ageGroup = ageGroup
            break
        case "editSegue":
            let editStudentVC = segue.destination as! CreateOrEditStudentViewController
            editStudentVC.selectedStudent = selectedStudent
            break
        default:
            break
            
        }
        
    }
    
}
