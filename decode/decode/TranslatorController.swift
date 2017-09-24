//
//  TranslatorController.swift
//  decode
//
//  Created by Mehul Ajith on 9/23/17.
//  Copyright © 2017 Mehul Ajith. All rights reserved.
//

import UIKit
import Speech
import AVFoundation
import SwiftyJSON

class TranslatorController: UIViewController, SFSpeechRecognizerDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var outputText: UILabel!
    @IBOutlet weak var `return`: UIButton!
    @IBOutlet weak var tabView: UIView!
    
    let langControl = ["en_US", "es", "fr_FR", "ar", "pt_PT", "ko_KR", "ru_RU", "de_DE"]
    var selectedItemArrayNumber = 0;
    var selectedItemArray = "en_US";
    
    var selectedLanguage = "en_US"
    var selectedLanguage2 = "en_US"
    
    let session = URLSession.shared
    var googleAPIKey = "AIzaSyBQva5NmnTqXfmRW4fIFqKIzvLYCz2pGjA"
    var googleURL: URL {
        return URL(string: "https://language.googleapis.com/v1/documents:analyzeEntities?key=\(googleAPIKey)")!
    }
    
    let translator = Translator(subscriptionKey: "43936858599b473babbe5ac2ecab16fb")
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: UserDefaults.standard.string(forKey: "selectedLang1")!))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedItemArrayNumber = UserDefaults.standard.integer(forKey: "arrayVal")
        selectedItemArray = langControl[selectedItemArrayNumber];

        
//        selectedLanguage = UserDefaults.standard.string(forKey: "selectedLang1")!
//        selectedLanguage2 = UserDefaults.standard.string(forKey: "selectedLang2")!
        
        self.recordButton.layer.masksToBounds = false
        self.recordButton.layer.shadowColor = UIColor(red:0.54, green:0.54, blue:0.54, alpha:1.0).cgColor
        self.recordButton.layer.shadowOpacity = 0.6
        self.recordButton.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.recordButton.layer.shadowRadius = 20
        
        self.recordButton.layer.shouldRasterize = true
        
        self.tabView.layer.masksToBounds = false
        self.tabView.layer.shadowColor = UIColor(red:0.54, green:0.54, blue:0.54, alpha:1.0).cgColor
        self.tabView.layer.shadowOpacity = 0.4
        self.tabView.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.tabView.layer.shadowRadius = 20
        
        self.tabView.layer.shouldRasterize = true
        
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.recordButton.isEnabled = isButtonEnabled
            }
        }

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func microphoneTapped(_ sender: UIButton) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
        } else {
            startRecording()
        }
    }
    
    func startRecording() {
        
        if recognitionTask != nil {  //1
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()  //2
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()  //3
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }  //4
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        } //5
        
        recognitionRequest.shouldReportPartialResults = true  //6
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in  //7
            
            var isFinal = false  //8
            
            if result != nil {
                
                self.outputText.text = result?.bestTranscription.formattedString  //9
                
                self.createRequest()
                
                self.translator.translate(input: (result?.bestTranscription.formattedString)!, to: UserDefaults.standard.string(forKey: "selectedLang2")!) { (result) in
                    switch result {
                    case .success(let translation):
                        self.outputText.text = translation
                    case .failure(let error):
                        self.outputText.text = "There seems to be an error"
                    }
                }
                
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {  //10
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)  //11
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()  //12
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        outputText.text = "Say something"
        
    }
    
    @IBAction func speakText(_ sender: UIButton) {
        let aud = outputText.text
        let utterance = AVSpeechUtterance(string: aud!)
        utterance.voice = AVSpeechSynthesisVoice(language: "en_US")
        
        utterance.rate = 0.35
        
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        
    }
    
    
    func createRequest() {
        // Create our request URL
        
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest = [
            "requests": [
                ["encodingType": "UTF8",
                 "document": [
                    "type": "PLAIN_TEXT",
                    "content": outputText.text
                    ]
                ]
            ]
            
        ]
        let jsonObject = JSON(jsonDictionary: jsonRequest)
        //let jsonObject = JSONSerialization.jsonObject(with: jsonRequest, options: []) as? [String : Any]
        
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return
        }
        
        request.httpBody = data
        print(data)
        
    }

    
    
    

}
