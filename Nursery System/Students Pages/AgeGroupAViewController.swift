//
//  AgeGroupAViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 28/02/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//
import Foundation
import UIKit

class AgeGroupAViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HomeModelProtocol {

    var feedItems: NSArray = NSArray()
    var selectedStudent : StudentsModel = StudentsModel()
    @IBOutlet weak var tblAgeGroupA: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblAgeGroupA.delegate = self
        self.tblAgeGroupA.dataSource = self
        
        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.downloadItems()
        
    }
    
    func itemsDownloaded(items: NSArray){
        feedItems = items
        self.tblAgeGroupA.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       //return num of feed items
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //retrieve cell
        let cellIdentifier: String = "BasicCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        
        //get student to show
        let item: StudentsModel = feedItems[indexPath.row] as! StudentsModel
        //get references to labels of cells
        
        let URL_IMAGE = URL(string: (item.displayPicture)!)
        print(URL_IMAGE)
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
                        print("image", image)
                        print(URL_IMAGE)
                        //display the image
                        DispatchQueue.main.async{
                            myCell.textLabel!.text = item.firstName! + " " + item.surname!
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {     //whenever user taps row
        //set selected student to var
        selectedStudent = feedItems[indexPath.row] as! StudentsModel
        //Manually call segue to detail view controller
        self.performSegue(withIdentifier: "AgeASegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //get reference to destination view controller
        let studentVC = segue.destination as! StudentDetailsViewController
        //set property to selected student so when view loads, it accesses the properties of feeditem obj
        studentVC.selectedStudent = selectedStudent
        
        print("finding the list of activities")
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/LoadActivities.php")!)
        
        request.httpMethod = "POST"
        
        let postString = ("a=257")
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                
            }
            
            var responseString = String(data: data, encoding: .utf8)!
            print("responseString = \(responseString)")
            print("doing this shit")
            print("doing this shit")
            print("doing this shit")
            print("doing this shit")
            print("doing this shit")
            
        }
        task.resume()
        print("found them")
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
