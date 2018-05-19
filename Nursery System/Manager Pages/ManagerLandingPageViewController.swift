//
//  ManagerLandingPageViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 26/03/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class ManagerLandingPageViewController: UIViewController {
    
    @IBOutlet var tabBarTeacher: UITabBarItem!
    @IBOutlet var tabBarManager: UITabBarItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCreateStudent(_ sender: Any) {
    performSegue(withIdentifier: "createStudentSegue", sender: nil)
    }
    

}
