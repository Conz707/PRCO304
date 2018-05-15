//
//  BookmarksViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 12/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class BookmarksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet var activityIndicatorTableLoading: UIActivityIndicatorView!
    @IBOutlet var tblBookmarks: UITableView!
    var feedItems: NSArray = NSArray()
    var selectedActivity : Activity = Activity()
    var selectedStudent : Student = Student()
    var activities = [Activity]()
    var postString = ""
    var defaultValues = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        activityIndicatorTableLoading.hidesWhenStopped = true
        let U_ID = defaultValues.string(forKey: "UserU_ID")
        postString = "U_ID=\(U_ID!)"
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/ParentSidePHPFiles/GetMyBookmarks.php")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
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
    }
    
    func itemsDownloaded(items: NSArray){
        feedItems = items
        self.tblBookmarks.reloadData()
        activityIndicatorTableLoading.stopAnimating()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //set selected activity to var
        selectedActivity = feedItems[indexPath.row] as! Activity
        //manually call segue to detail view controller
        getSelectedStudent()
        
    }
    
    func getSelectedStudent(){

        postString = "S_ID=\(selectedActivity.S_ID!)"
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/GetSelectedStudent.php")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        print(postString)
        
        utilities.postRequest(postString: postString, request: request, completion: { success, data in

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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let viewActivityVC = segue.destination as! ActivityDetailsViewController
        viewActivityVC.selectedActivity = selectedActivity
        viewActivityVC.selectedStudent = selectedStudent
        print(selectedStudent.description)
    }


    
}
