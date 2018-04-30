//
//  Y1GoalsViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 09/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//NEEDS BIG CLEANUP
//MAKE THIS CONFORM TO SELECTED STUDENT TO SEND THE ID

import UIKit


class GoalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tblGoals: UITableView!
    @IBOutlet var activityIndicatorTableLoading: UIActivityIndicatorView!
    
    var goals = [Goal]()
    var selectedGoal : Goal = Goal()
    var feedItems: NSArray = NSArray()
    var postString = ""
    var selectedStudent : Student = Student()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/GetStudentGoals.php")!)
        postString = "querySelector=All&S_ID=\(selectedStudent.S_ID!)"
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        let postRequest = utilities.postRequest(postString: postString, request: request, completion: { success, data in
            do {
                self.goals = try JSONDecoder().decode(Array<Goal>.self, from: data)
                for eachGoal in self.goals {
                    print("\(eachGoal.description)")
                }
            } catch {
                print(error)
                print("ERROR")
            }
            DispatchQueue.main.async {
                self.itemsDownloaded(items: self.goals as NSArray)
                print("trying to print items downloaded \(self.goals)")
            }
            
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //retrieve cell
        let cellIdentifier: String = "BasicCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        //get activity to show
        let item: Goal = self.feedItems[indexPath.row] as! Goal
        
        myCell.textLabel!.text = "\(item.Goal)"
        
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {     //whenever user taps row
        //set selected student to var
        selectedGoal = feedItems[indexPath.row] as! Goal
        //Manually call segue to detail view controller
        self.performSegue(withIdentifier: "goalDetails", sender: self)
    }
    
    func itemsDownloaded(items: NSArray){
        feedItems = items
        self.tblGoals.reloadData()
        activityIndicatorTableLoading.stopAnimating()
    }
    
/*    func itemsDownloaded(items: NSArray)
    {
      
    }
    

    @IBOutlet var lblGoal1: UILabel!
    @IBOutlet var lblGoal2: UILabel!
    @IBOutlet var lblGoal3: UILabel!
    
    @IBOutlet var Goal3Checkbox: UIButton!
    @IBOutlet var Goal2Checkbox: UIButton!
    @IBOutlet var Goal1Checkbox: UIButton!
    var goals = [Goals]()
    var goal1Completed = false
    var goal1 = ""
    var goal2Completed = false
    var goal2 = ""
    var goal3Completed = false
    var goal3 = ""
    var customgoal1Completed = false
    var customgoal2Completed = false
    var customgoal3Completed = false
    var feedItems : NSArray = NSArray()
    var tapped = false
    var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/AgeGroupAGoals.php")!)
    var studentsGoals : GoalsModel = GoalsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let loadGoalsModel = LoadGoalsModel()
        loadGoalsModel.downloadItems()
        loadGoalsModel.delegate = self
        
        checkGoals(completion: { success in
            self.lblGoal1.text = self.goal1
            self.lblGoal2.text = self.goal2
            self.lblGoal3.text = self.goal3
            //CLEAN THIS UP
            print("attempting")
            print(self.goal1Completed)
            print(self.goal1Completed)
            print(self.goal1Completed)
            print(self.goal1Completed)
            print(self.goal1Completed)
          
            if(self.goal1Completed == true){
                self.Goal1Checkbox.setImage(UIImage(named: "checked box"), for: .normal)
                self.goal1Completed = true
                
            } else {
                self.Goal1Checkbox.setImage(UIImage(named: "unchecked box"), for: .normal)
                self.goal1Completed = false
            }
            
            if(self.goal2Completed == true){
                self.Goal2Checkbox.setImage(UIImage(named: "checked box"), for: .normal)
                self.goal2Completed = true
                
            } else {
                self.Goal2Checkbox.setImage(UIImage(named: "unchecked box"), for: .normal)
                self.goal2Completed = false
            }
            
            if(self.goal3Completed == true){
                self.Goal3Checkbox.setImage(UIImage(named: "checked box"), for: .normal)
                self.goal3Completed = true
                
            } else {
                self.Goal3Checkbox.setImage(UIImage(named: "unchecked box"), for: .normal)
                self.goal3Completed = false
            }
            print(self.goal2)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkGoals(completion: @escaping (_ success : Bool) -> ()){
        var success = true
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/LoadAgeGroupAGoals.php")!)
        request.httpMethod = "POST"
        
        let postString = ("S_ID=257")
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        
        _ = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data else { return }
            do {
                let responseString = String(data: data, encoding: .utf8)!
                print("response string \(responseString)")
                
                let decoder = JSONDecoder()
                let goals = try decoder.decode(Array<Goals>.self, from: data)
                self.goal1 = (goals.first?.Goal1)!
                self.goal2 = (goals.first?.Goal2)!
                self.goal3 = (goals.first?.Goal3)!
                if(goals.first?.Goal1Completed == "1"){
                    self.goal1Completed = true
                } else {
                    self.goal1Completed = false
                }
                
                if(goals.first?.Goal2Completed == "1"){
                    self.goal2Completed = true
                } else {
                    self.goal2Completed = false
                }
                
                if(goals.first?.Goal3Completed == "1"){
                    self.goal3Completed = true
                } else {
                    self.goal3Completed = false
                }

                print(self.goal2)
            } catch let err {
                print("Err", err)
                success = false
            }
            DispatchQueue.main.async {
                completion(success)
            }
        }.resume()
        print(success)
    }
    
    
    @IBAction func btnCheckbox1(_ sender: Any) {
        
        if(goal1Completed == false){
            Goal1Checkbox.setImage(UIImage(named: "checked box"), for: .normal)
            goal1Completed = true
          
        } else {
            Goal1Checkbox.setImage(UIImage(named: "unchecked box"), for: .normal)
            goal1Completed = false
        }
        updateGoals()
        
    
    }
    
    @IBAction func btnCheckbox2(_ sender: Any) {
        
        
        if(goal2Completed == false){
            Goal2Checkbox.setImage(UIImage(named: "checked box"), for: .normal)
            goal2Completed = true
        } else {
            Goal2Checkbox.setImage(UIImage(named: "unchecked box"), for: .normal)
            goal2Completed = false
        }
        updateGoals()
    }
    
    @IBAction func btnCheckbox3(_ sender: Any) {
        
        if(goal3Completed == false){
            Goal3Checkbox.setImage(UIImage(named: "checked box"), for: .normal)
            goal3Completed = true
        } else {
            Goal3Checkbox.setImage(UIImage(named: "unchecked box"), for: .normal)
            goal3Completed = false
        }
        updateGoals()
    }
    
    func updateGoals(){
        
        let postString = ("Goal1Completed=\(goal1Completed)&Goal2Completed=\(goal2Completed)&Goal3Completed=\(goal3Completed)&")
        print(postString)
        
        request.httpMethod = "POST"
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
            
        }
        task.resume()
        
    }
    */
    

}

