//
//  ParentLandingPageViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 21/03/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit
import LBTAComponents

class MyChildrenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewChildrenModelProtocol {
    
    let defaultValues = UserDefaults.standard
    
    var feedItems: NSArray = NSArray()
    var selectedStudent : StudentsModel = StudentsModel()
    @IBOutlet var tblChildren: UITableView!
    
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
        
        let URL_IMAGE = URL(string: (item.displayPicture)!)
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
        //get references to labels of cells
        return myCell
    }
    

    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.tblChildren.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //set selected student to var
        selectedStudent = feedItems[indexPath.row] as! StudentsModel
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

        self.tblChildren.delegate = self
        self.tblChildren.dataSource = self
        
        let viewChildrenModel = ViewChildrenModel()
        viewChildrenModel.delegate = self
        viewChildrenModel.downloadItems()
        

        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
