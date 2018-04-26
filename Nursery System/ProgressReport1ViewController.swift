//
//  ProgressReport1ViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 12/03/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

//better way to add borders than repeated views?

class ProgressReport1ViewController: UIViewController {

    @IBOutlet var viewChildDetails: UIView!
    @IBOutlet var viewParentGuardianDetails: UIView!
    @IBOutlet var viewReportDetails: UIView!
  
    @IBOutlet var viewEffectiveLearning: UIView!
    @IBOutlet var txtEffectiveLearning: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewChildDetails.layer.borderColor = UIColor.gray.cgColor
        viewChildDetails.layer.borderWidth = 1
        viewParentGuardianDetails.layer.borderColor = UIColor.gray.cgColor
        viewParentGuardianDetails.layer.borderWidth = 1
        viewEffectiveLearning.layer.borderColor = UIColor.gray.cgColor
        viewEffectiveLearning.layer.borderWidth = 1
       // txtEffectiveLearning.layer.borderColor = UIColor.gray.cgColor
      //  txtEffectiveLearning.layer.borderWidth = 1
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
