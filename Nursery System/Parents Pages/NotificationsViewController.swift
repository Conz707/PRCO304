//
//  NotificationsViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 12/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var activityIndicatorTableLoading: UIActivityIndicatorView!
    @IBOutlet var tblNotifications: UITableView!
    var feedItems: NSArray = NSArray()
    var selectedActivity : Activity = Activity()
    var selectedStudent : Student = Student()
    let defaultValues = UserDefaults.standard
    var activities = [Activity]()
    var U_ID = ""
    var postString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorTableLoading.startAnimating()
        activityIndicatorTableLoading.hidesWhenStopped = true
        U_ID = defaultValues.string(forKey: "UserU_ID")!

        
        getActivities()
    }
    
    override func viewDidAppear(_ animated: Bool) {     //after viewing a notification it will disappear from list so reload the activities
       
        getActivities()
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
        let item: Activity = self.feedItems[indexPath.row] as! Activity
        
    
        utilities.getImages(URL_IMAGE: URL(string: (item.ActivityPicture)!)!, completion: { success, image in
           
            //display the image
            DispatchQueue.main.async{
                myCell.textLabel!.text = "New Activity: \(item.Activity!)"
                myCell.imageView!.clipsToBounds = true
                myCell.imageView?.image = image
                
            }
        })
        
        return myCell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //set selected activity to var
        selectedActivity = feedItems[indexPath.row] as! Activity
        
        
        markNotificationRead()
        getSelectedStudent()
        
    }
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        tblNotifications.reloadData()
        activityIndicatorTableLoading.stopAnimating()
        
    }
    

    func getActivities(){      //get any unviewed activities and display in table
        
        postString = ("U_ID=\(U_ID)")
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/ParentSidePHPFiles/GetMyNotifications.php")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        utilities.postRequest(postString: postString, request: request, completion: { success, data, responseString in
            
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
    }
    
    func getSelectedStudent(){      //get student for segue
        postString = "S_ID=\(selectedActivity.S_ID!)"
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/GetSelectedStudent.php")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        print(postString)
        
        utilities.postRequest(postString: postString, request: request, completion: { success, data, responseString in
            
            do {
                print(data)
                let student = try JSONDecoder().decode(Student.self, from: data)
                self.selectedStudent = student
                print(student.description)
                print(self.selectedStudent.description)
                DispatchQueue.main.async{
                    self.performSegue(withIdentifier: "viewActivity", sender: Any?.self)
                }
            } catch {
                print(error)
                print("ERROR")
            }
            
        })
    }
    
    func markNotificationRead(){        //when clicking on an activity, mark it as read within the database
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/ParentSidePHPFiles/SetNotificationRead.php")!)
        request.httpMethod = "POST"
        let postString = ("A_ID=\(selectedActivity.A_ID!)&U_ID=\(U_ID)")
        request.httpBody = postString.data(using: .utf8)
        
        utilities.postRequest(postString: postString, request: request, completion: { success, data, responseString in
            
        })
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let viewActivityVC = segue.destination as! ActivityDetailsViewController
        viewActivityVC.selectedActivity = selectedActivity
        viewActivityVC.selectedStudent = selectedStudent
    }
    
}

