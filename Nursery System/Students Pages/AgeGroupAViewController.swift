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
        myCell.textLabel!.text = item.firstName! + " " + item.surname!
        
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
