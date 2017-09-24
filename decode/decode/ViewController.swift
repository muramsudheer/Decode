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
    
    var selectedLang1 = "Spanish"
    var selectedLang2 = "Chinese"
    
    var languages = ["English", "Spanish", "French", "Arabic", "Portuguese", "Korean", "Russian", "German"]    // Select language
    let langCode = ["en", "es", "fr", "ar", "pt", "ko", "ru", "de"]
    
    var languages2 = ["English", "Spanish", "French", "Arabic", "Portuguese", "Korean", "Russian", "German"]    // Select language
    let langCode2 = ["en", "es", "fr", "ar", "pt", "ko", "ru", "de"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        languagePickOne.delegate = self
        languagePickOne.dataSource = self
        
        languagePickTwo.delegate = self
        languagePickTwo.dataSource = self
        
    }
    
    
    @IBOutlet weak var doneButton: UIButton!   // Done button

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if languagePickOne.tag == 0 {
            return languages[row]
        }
        
        else if languagePickTwo.tag == 1 {
            return languages2[row]
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return languages.count
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if pickerView.tag == 0 {
            selectedLang1 = langCode[row]
            UserDefaults.standard.set(selectedLang1, forKey: "selectedLang1")
        } else {
            self.selectedLang2 = self.langCode2[row]
            UserDefaults.standard.set(selectedLang2, forKey: "selectedLang2")
        }
        
    }

}

