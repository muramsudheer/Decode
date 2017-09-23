//
//  ViewController.swift
//  decode
//
//  Created by Mehul Ajith on 9/23/17.
//  Copyright © 2017 Mehul Ajith. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var languagePickOne: UIPickerView!   // Foreign language
    @IBOutlet weak var languagePickTwo: UIPickerView!   // Your language
    
    var languages = ["Spanish", "Arabic", "Chinese"]    // Select language
    
    var languages2 = ["Spanish", "Arabic", "Chinese"]    // Select language
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        languagePickOne.delegate = self
        
        languagePickOne.dataSource = self
        
    }
    
    
    @IBOutlet weak var doneButton: UIButton!   // Done button

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return languages[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return languages.count
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let languageVal = [languages[row]] as [String]
        print(languageVal)
        UserDefaults.standard.set(languageVal, forKey: "languageVal")
    }

}

