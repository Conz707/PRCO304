//
//  TeacherLandingPageViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 22/02/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class TeacherLandingPageViewController: UIViewController {
let defaultValues = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        let checkUserEmail = self.defaultValues.string(forKey: "UserEmail")
        print("IS THIS SHIT WORKING? YEET \(checkUserEmail)")
        // Do any additional setup after loading the view.
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
