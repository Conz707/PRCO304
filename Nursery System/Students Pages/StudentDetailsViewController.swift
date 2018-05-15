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
        

        print("oioi \(selectedStudent.description)")
        
        let formatStringToDate = (utilities.formatStringToDate(dateString: selectedStudent.DateofBirth!))
        
        print("original date string \(selectedStudent.DateofBirth!)")
        print("new Date() \(formatStringToDate)")
        
        
        let ageGroupA = (Calendar.current.date(byAdding: .month, value: -18, to: Date()))!
        let ageGroupB = (Calendar.current.date(byAdding: .month, value: -36, to: Date()))!
        let ageGroupC = (Calendar.current.date(byAdding: .month, value: -48, to: Date()))!
        
        
        if(formatStringToDate >= ageGroupA){
            ageGroup = "A"
        } else if (formatStringToDate < ageGroupA && formatStringToDate >= ageGroupB) {
            ageGroup = "B"
        } else {
            ageGroup = "C"
        }
        
        tblActivities.contentInset = UIEdgeInsetsMake(0, 15, 0, 0)
        DispatchQueue.main.async {
            self.getParentLabels(completion: { success in
                self.lblMother.text = self.responseArr[0]
                self.lblFather.text = self.responseArr[1]
                self.lblGuardian.text = self.responseArr[2]
                self.lblKeyPerson.text = self.responseArr[3]
            })
        }
        
        getActivities()
        getImage()
        activityIndicatorTableLoading.hidesWhenStopped = true
        

        lblName.text = (selectedStudent.FirstName)! + " " + (selectedStudent.Surname)!
        
        let formatDate = utilities.formatDateToString(dateString: selectedStudent.DateofBirth!)
        lblDateOfBirth.text = formatDate
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        getActivities()
        
        let checkUserRole = defaultValues.string(forKey: "UserRole")
        print(checkUserRole)
        if(checkUserRole! == "Parent"){ //only for parents -- manager and teacher should bth see it
            btnAddActivity.isHidden = true
        } else if (checkUserRole == "Manager"){
            btnEditStudentOutlet.isHidden = false
            } else{
            btnAddActivity.isHidden = false
            
        }
        
        activityIndicatorTableLoading.startAnimating()

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func itemsDownloaded(items: NSArray){
        feedItems = items
        if (items.count > 0){
        tblActivities.reloadData()
        activityIndicatorTableLoading.stopAnimating()
        } else {
        activityIndicatorTableLoading.stopAnimating()
        print("PUT A 0 ACTIVITY RESULTS ON TABLE")
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return num of feed items
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //retrieve cell
        let cellIdentifier: String = "BasicCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        //get activity to show
        let item: Activity = self.feedItems[indexPath.row] as! Activity
        
        print("attempting to attach activity to table")
        
        let URL_IMAGE = URL(string: (item.ActivityPicture)!)
        let session = URLSession(configuration: .default)
        
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
    
    
     func getParentLabels(completion: @escaping (_ success : Bool) -> ()){
        
        var success = true
        
        let mother = selectedStudent.Mother
        let father = selectedStudent.Father
        let guardian = selectedStudent.Guardian
        let keyPerson = selectedStudent.KeyPerson
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/GetParentsDetails.php")!)
        
        request.httpMethod = "POST"
        
        let postString = ("Mother=\(mother ?? "")&Father=\(father ?? "")&Guardian=\(guardian ?? "")&KeyPerson=\(keyPerson ?? "")")
        print(postString)
        
        request.httpBody = postString.data(using: .utf8)
        
        postRequest(postString: postString, request: request, completion: { success, data in
            completion(success)
        })
        
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
    
    
    func getActivities(){
        
        postString = "S_ID=\(selectedStudent.S_ID!)"
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/GetActivities.php")!)
        
        
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        print("poststring \(postString)")
        
        utilities.postRequest(postString: postString, request: request, completion: { success, data in
            

            do {
                self.activities = try JSONDecoder().decode(Array<Activity>.self, from: data)
                for eachActivity in self.activities {
                    print("\(eachActivity.description)")
                }
            } catch {
                print(error)
                print("ERROR")
            }
            DispatchQueue.main.async {
                self.itemsDownloaded(items: self.activities as NSArray)
                print("trying to print items downloaded \(self.activities)")
            }
            
        })
        print(postRequest)
    }
    
    func getImage(){
        let session = URLSession(configuration: .default)
        
        utilities.getImages(URL_IMAGE: URL(string: (selectedStudent.StudentPicture)!)!, completion: { success, image in
            
            //display the image
            DispatchQueue.main.async{
                self.imgStudent.image = image
            }
        })
    }
    
    func postRequest(postString: String, request: URLRequest, completion: @escaping (_ success : Bool,_ data: Data) -> ()){
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
            self.responseArr = (responseString.split(separator: ";") as NSArray) as! [String]
            print("responseString <br /> = \(responseString)")
            
            DispatchQueue.main.async{
                completion(success, data)
            }
        }
        task.resume()
        print(success)
    }
    
    
    
}
