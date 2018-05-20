//
//  TeacherLandingPageViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 22/02/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class TeacherLandingPageViewController: UIViewController {
    
    
    @IBOutlet var tabBar: UITabBar!
    @IBOutlet var tabBarManager: UITabBarItem!
    let defaultValues = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(defaultValues.string(forKey: "UserRole") == "Teacher"){

        }
        



    // Do any additional setup after loading the view.
}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnEditAccount(_ sender: Any) {
        performSegue(withIdentifier: "editAccountSegue", sender: nil)
    }
}
