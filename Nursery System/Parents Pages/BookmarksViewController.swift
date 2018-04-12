//
//  BookmarksViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 12/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class BookmarksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LoadBookmarksModelProtocol {
    


    @IBOutlet var tblBookmarks: UITableView!
    var feedItems: NSArray = NSArray()
    var selectedActivity : ActivitiesModel = ActivitiesModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        self.tblBookmarks.dataSource = self
        self.tblBookmarks.delegate = self
        let loadBookmarksModel = LoadBookmarksModel()
        loadBookmarksModel.downloadItems()
        loadBookmarksModel.delegate = self
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
        let item: ActivitiesModel = self.feedItems[indexPath.row] as! ActivitiesModel
        
        print("attempting to attach activity to table")
        
        let URL_IMAGE = URL(string: (item.activityPicture)!)
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
                            myCell.textLabel!.text = item.activity
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
        selectedActivity = feedItems[indexPath.row] as! ActivitiesModel
        //manually call segue to detail view controller
        self.performSegue(withIdentifier: "viewActivity", sender: self)
    }
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        tblBookmarks.reloadData()
        navigationController?.navigationBar.isHidden = false //stops backing too fast crashing application
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let viewActivityVC = segue.destination as! ActivityDetailsViewController
        viewActivityVC.selectedActivity = selectedActivity
    }

}
