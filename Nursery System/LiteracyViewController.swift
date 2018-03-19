//
//  LiteracyViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 08/03/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class LiteracyViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   

    var selectedStudent : StudentsModel?
    
    @IBOutlet weak var readingLevelPicker: UIPickerView!
    @IBOutlet weak var writingLevelPicker: UIPickerView!
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.readingLevelPicker.delegate = self
        self.readingLevelPicker.dataSource = self
        
        self.writingLevelPicker.delegate = self
        self.writingLevelPicker.dataSource = self
        
        //input data into the array
        pickerData = ["Emerging", "On Track", "Exceeding"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    
    //row titles
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    //picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //change colour of label background and text depending on selected row
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
