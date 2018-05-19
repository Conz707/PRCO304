//
//  TeacherLandingPageViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 22/02/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class TeacherLandingPageViewController: UIViewController {
    
    @IBOutlet var segmentedUserRole: UISegmentedControl!
    
    @IBOutlet var tabBarManager: UITabBarItem!
    let defaultValues = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(defaultValues.string(forKey: "UserRole") == "Teacher"){
            tabBarManager.isEnabled = false
        }
     
        // Do any additional setup after loading the view.
    }

    @IBAction func segmentUserRole(_ sender: Any) {
        switch (segmentedUserRole.selectedSegmentIndex){
        case 0:
            break
        case 1:
            break
        default:
            print("mems")
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
