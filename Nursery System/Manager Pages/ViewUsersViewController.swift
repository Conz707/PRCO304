//
//  ViewUsersViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 13/05/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class ViewUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicatorTableLoading: UIActivityIndicatorView!
    @IBOutlet weak var segmentUserType: UISegmentedControl!
    @IBOutlet weak var tblUsers: UITableView!
    var users = [User]()
    var postString = ""
    var feedItems : NSArray = NSArray()
    var filterUsers = [User]()
    var selectedUser : User = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorTableLoading.hidesWhenStopped = true
        activityIndicatorTableLoading.startAnimating()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        segmentedUsers((Any).self)
        selectedUser = User()
    }
    
    
    func itemsDownloaded(items: NSArray){
        feedItems = items
        filterUsers = items as! [User]
        self.tblUsers.reloadData()
        activityIndicatorTableLoading.stopAnimating()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return num of feed items
        
        return filterUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //retrieve cell
        let cellIdentifier: String = "BasicCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        
        
        //get student to show
        var item: User = filterUsers[indexPath.row] as! User
        
        
        print("trying to print item \(item.FirstName)")
        
        //get references to labels of cells
        myCell.textLabel!.text = ("\(item.FirstName!) \(item.Surname!)")
        
        return myCell
    }


func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {     //whenever user taps row
    //set selected user to var
    selectedUser = filterUsers[indexPath.row]
    //Manually call segue to detail view controller
    self.performSegue(withIdentifier: "UserSegue", sender: self)
}
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            filterUsers = users
            
            tblUsers.reloadData()
            return
            
        }
        filterUsers = users.filter({ user -> Bool in
            
                user.FirstName!.lowercased().contains(searchText.lowercased()) ||
                user.Surname!.lowercased().contains(searchText.lowercased()) ||
                user.FirstName!.lowercased().contains(searchText.lowercased())                                                            ||
                user.Email!.lowercased().contains(searchText.lowercased())
        })
        tblUsers.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedUsers(_ sender: Any) {
        switch segmentUserType.selectedSegmentIndex {
        case 0:
            postString = "DisplayUsers=All"
            print(postString)
        case 1:
            postString = "DisplayUsers=Teachers"
            print(postString)
        case 2:
            postString = "DisplayUsers=Parents"
            print(postString)
            
        default: break
        }
     
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/ManagerSidePHPFiles/GetUsers.php")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
      
        utilities.postRequest(postString: postString, request: request, completion: { success, data, responseString in
            do {
                self.users = try JSONDecoder().decode(Array<User>.self, from: data)
                for eachUser in self.users {
                    print("\(eachUser.FirstName)")
                }
                
            } catch {
                print(error)
                print("ERROR")
            }
            DispatchQueue.main.async {
                self.itemsDownloaded(items: self.users as NSArray)
                print("trying to print items downloaded \(self.users)")
            }
            
        })
        
        
    }
    
    func callDecode(){
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //get reference to destination view controller
        let userVC = segue.destination as! CreateOrEditUserViewController
        //set property to selected student so when view loads, it accesses the properties of feeditem obj
        userVC.selectedUser = selectedUser
        
        print("finding the list of activities")
    //    print(selectedStudent.description)
        
    }


}
