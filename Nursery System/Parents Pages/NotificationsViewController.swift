//
//  NotificationsViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 12/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

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
        
        U_ID = defaultValues.string(forKey: "UserU_ID")!
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/ParentSidePHPFiles/GetMyNotifications.php")!)
        request.httpMethod = "POST"
        
        postString = ("U_ID=\(U_ID)")
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        
        let postRequest = utilities.postRequest(postString: postString, request: request, completion: { success, data in
            
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
    
    override func viewDidAppear(_ animated: Bool) {
       

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
        
        print("attempting to attach activity to table")
        
        let URL_IMAGE = URL(string: (item.ActivityPicture)!)
        let session = URLSession(configuration: .default)
        
        //create a dataTask
        let getImageFromUrl = session.dataTask(with: URL_IMAGE!) { data, response, error in
            
            //if error
            if let e = error {
                //display message
                print("Error occurred: \(e)")
            } else {
                if (response as? HTTPURLResponse) != nil {
                    
                    //check response contains image
                    if let imageData = data {
                        
                        //get image
                        let image = UIImage(data: imageData)
                        //display the image
                        DispatchQueue.main.async{
                            myCell.textLabel!.text = "New Activity: \(item.Activity!)"
                            myCell.imageView!.clipsToBounds = true
                            myCell.imageView?.image = image
                            
                        }
                    } else {
                        print("image corrupted")
                    }
                } else {
                    print("No server response")
                }
            }
        }
        getImageFromUrl.resume()
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //set selected activity to var
        selectedActivity = feedItems[indexPath.row] as! Activity
        
        
        markNotificationRead()
        getSelectedStudent()
        
        //manually call segue to detail view controller
        self.performSegue(withIdentifier: "viewActivity", sender: self)
    }
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        tblNotifications.reloadData()
        
    }
    
    func getSelectedStudent(){
        postString = "S_ID=\(selectedActivity.S_ID)"
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/ParentSidePHPFiles/GetSelectedStudent.php")!)
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
                    self.performSegue(withIdentifier: "viewActivity", sender: Any?.self)
                }
            } catch {
                print(error)
                print("ERROR")
                
            }
            
        })
    }
    
    func markNotificationRead(){
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/SetNotificationRead.php")!)
        request.httpMethod = "POST"
        let postString = ("A_ID=\(selectedActivity.A_ID!)&U_ID=\(U_ID)")
        request.httpBody = postString.data(using: .utf8)
        
        let postRequest = utilities.postRequest(postString: postString, request: request, completion: { success, data in
            
        })
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let viewActivityVC = segue.destination as! ActivityDetailsViewController
        viewActivityVC.selectedActivity = selectedActivity
        viewActivityVC.selectedStudent = selectedStudent
    }
    
}

