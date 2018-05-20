//
//  ParentLandingPageViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 21/03/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit
import LBTAComponents

class MyChildrenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tblChildren: UITableView!
    let defaultValues = UserDefaults.standard
    var postString = ""
    var feedItems: NSArray = NSArray()
    var selectedStudent : Student = Student()
    var U_ID = ""
    var students = [Student]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return num of feed items
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //retrieve cell
        let cellIdentifier: String = "BasicCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        
        //get student to show
        let item: Student = feedItems[indexPath.row] as! Student
        
        
        utilities.getImages(URL_IMAGE: URL(string: (item.StudentPicture)!)!, completion: { success, image in
            
            //display the image
            DispatchQueue.main.async{
                myCell.textLabel!.text = item.FirstName! + " " + item.Surname!
                myCell.imageView?.image = image
            }
        })
        return myCell
    }
    

    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.tblChildren.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //set selected student to var
        selectedStudent = feedItems[indexPath.row] as! Student
        //Manually call segue to detail view controller
        self.performSegue(withIdentifier: "viewChild", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //get reference to destination view controller
        let studentVC = segue.destination as! StudentDetailsViewController
        //set property to selected student so when view loads, it accesses the properties of feeditem obj
        studentVC.selectedStudent = selectedStudent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        U_ID = defaultValues.string(forKey: "UserU_ID")!
        postString = "U_ID=\(U_ID)"
        print(postString)
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/ParentSidePHPFiles/GetMyChildren.php")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        utilities.postRequest(postString: postString, request: request, completion: { success, data, responseString in
            
            do {
                self.students = try JSONDecoder().decode(Array<Student>.self, from: data)
                for eachStudent in self.students {
                    print("\(eachStudent.description)")
                }
            } catch {
                print(error)
                print("ERROR")
            }
            DispatchQueue.main.async {
                self.itemsDownloaded(items: self.students as NSArray)
            }
            
        })

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
