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
            getBookmarks()
    }
    
    func itemsDownloaded(items: NSArray){
        feedItems = items
        self.tblBookmarks.reloadData()
        activityIndicatorTableLoading.stopAnimating()
    }
    
    
    func getBookmarks(){        //get bookmarked activities for the table
        let U_ID = defaultValues.string(forKey: "UserU_ID")
        postString = "U_ID=\(U_ID!)"
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/ParentSidePHPFiles/GetMyBookmarks.php")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
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
    
    func getSelectedStudent(){      // get selected student for segue

        postString = "S_ID=\(selectedActivity.S_ID!)"
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/GetSelectedStudent.php")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        utilities.postRequest(postString: postString, request: request, completion: { success, data, responseString in

            do {
                print(data)
                let student = try JSONDecoder().decode(Student.self, from: data)
                self.selectedStudent = student
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

    }


    
}
