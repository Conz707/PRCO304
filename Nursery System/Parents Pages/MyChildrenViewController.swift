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
        
        let URL_IMAGE = URL(string: (item.StudentPicture)!)
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
                        myCell.textLabel!.text = item.FirstName! + " " + item.Surname!
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
        //get references to labels of cells
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
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/GetMyChildren.php")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        postRequest(postString: postString, request: request, completion: { success, data in
            
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
                print("trying to print items downloaded \(self.students)")
            }
            
        })

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func postRequest(postString: String, request: URLRequest, completion: @escaping(_ success : Bool, _ data: Data) -> ()){
        
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
