
//
//  AgeGroupBViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 28/02/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class AgeGroupBViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HomeModelBProtocol {

    var feedItems: NSArray = NSArray()
    var selectedStudent : StudentsModel = StudentsModel()
    let urlPath: String = "https://shod-verses.000webhostapp.com/AgeGroupB.php"
    
    @IBOutlet weak var tblAgeGroupB: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblAgeGroupB.delegate = self
        self.tblAgeGroupB.dataSource = self
        
        let homeModel = HomeModelB()
        homeModel.delegate = self
        homeModel.downloadItems()
        
        
        // Do any additional setup after loading the view.
    }
    
    func itemsDownloaded(items: NSArray){
        feedItems = items
        self.tblAgeGroupB.reloadData()
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
        myCell.textLabel!.text = item.firstName! + " " + item.surname!
        
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {     //whenever user taps row
        //set selected student to var
        selectedStudent = feedItems[indexPath.row] as! StudentsModel
        //Manually call segue to detail view controller
        self.performSegue(withIdentifier: "AgeBSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //get reference to destination view controller
        let studentVC = segue.destination as! StudentDetailsViewController
        //set property to selected student so when view loads, it accesses the properties of feeditem obj
        studentVC.selectedStudent = selectedStudent
        
        
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
