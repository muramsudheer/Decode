//
//  ViewController.swift
//  decode
//
//  Created by Mehul Ajith on 9/23/17.
//  Copyright © 2017 Mehul Ajith. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var languagePickOne: UIPickerView!
    @IBOutlet weak var languagePickTwo: UIPickerView!
    
    var languages = ["", "", "", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
    }


}

