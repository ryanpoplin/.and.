//
//  DetailViewController.swift
//  AACcess
//
//  Created by Byrdann Fox on 2/11/15.
//  Copyright (c) 2015 ExcepApps, Inc. All rights reserved.
//

// ...
import UIKit
import CoreData
import AVFoundation
import QuartzCore
import JavaScriptCore

// ...
public var textViewData: String! = ""

// ...
class DetailViewController: UIViewController, UITextViewDelegate, AVSpeechSynthesizerDelegate {
    
    // ...
    internal let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    // ...
    internal var speechPaused: Bool = false
    
    // ...
    internal var synthesizer: AVSpeechSynthesizer!
    
    // '!' == unwrapped optional
    
    // create a variable to hold the a reference to a UITextView
    var textView: UITextView!
    
    // create a variable to hold a reference to a UIButton
    var clearTextButton: UIButton!
    
    // create a variable to hold a reference to a UIButton
    var speakAndPauseButton: UIButton!
    
    // ...
    override func viewDidLoad() {
        
        // ...
        super.viewDidLoad()
        
        // ...
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        // make the 'ViewController' class' view have a white background color
        view.backgroundColor = UIColor.whiteColor()
        
        // Do any additional setup after loading the view.
        
        /* textView */
        
        // the 'frame' arguments
        textView = UITextView(frame: CGRect(x: 20, y: 60, width: 660, height: 240))
        
        // ...
        textView.font = UIFont.systemFontOfSize(45)
        
        // red for testing
        textView.backgroundColor = UIColor.redColor()
        
        // add textView to the 'ViewController' view as a subview
        self.view.addSubview(textView)
        
        // ...
        self.textView.delegate = self
        
        // ...
        self.automaticallyAdjustsScrollViewInsets = false
        
        // ...
        textView.becomeFirstResponder()
        
        /* clearTextButton */
        
        // ...
        clearTextButton = UIButton.buttonWithType(.System) as? UIButton
        
        // ...
        clearTextButton.frame = CGRect(x: 240, y: 312, width: 100, height: 50)
        
        // ...
        clearTextButton.backgroundColor = UIColor.lightGrayColor()
        
        // ...
        clearTextButton.exclusiveTouch = true
        
        // ...
        clearTextButton.layer.cornerRadius = 5
        
        // ...
        clearTextButton.setTitle("Clear", forState: .Normal)
        
        // ...
        clearTextButton.addTarget(self, action: "clearTextButtonIsPressed:", forControlEvents: .TouchDown)
        
        // ...
        clearTextButton.titleLabel!.font = UIFont.systemFontOfSize(20)
        
        // ...
        view.addSubview(clearTextButton)
        
        /* speakAndPauseButton */
        
        // ...
        speakAndPauseButton = UIButton.buttonWithType(.System) as? UIButton
        
        // ...
        speakAndPauseButton.frame = CGRect(x: 360, y: 312, width: 100, height: 50)
        
        // ...
        speakAndPauseButton.backgroundColor = UIColor.lightGrayColor()
        
        // ...
        speakAndPauseButton.exclusiveTouch = true
        
        // ...
        speakAndPauseButton.layer.cornerRadius = 5
        
        // ...
        speakAndPauseButton.setTitle("Speak", forState: .Normal)
        
        // ...
        speakAndPauseButton.addTarget(self, action: "speakAndPauseButtonIsPressed:", forControlEvents: .TouchDown)
        
        // ...
        speakAndPauseButton.titleLabel!.font = UIFont.systemFontOfSize(20)
        
        // ...
        view.addSubview(speakAndPauseButton)
        
        // ...
        if textView.text == "" {
            
            // ...
            speakAndPauseButton.enabled = false
            
        }
        
        /* Speech Synthesizer */
        
        // ...
        self.synthesizer = AVSpeechSynthesizer()
        
        // ...
        self.synthesizer.delegate = self
        
        // ...
        speechPaused = false
        
    }
    
    // ...
    func textViewDidChange(textView: UITextView) {
        
        // ...
        var textString: NSString = textView.text
        
        // ...
        var charSet: NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        
        // ...
        var trimmedString: NSString = textString.stringByTrimmingCharactersInSet(charSet)
        
        // ...
        textViewData = String(trimmedString)
        
        // ...
        if trimmedString.length == 0 {
            
            // ...
            speakAndPauseButton.enabled = false
            
        } else {
            
            // ...
            speakAndPauseButton.enabled = true
            
        }
        
    }
    
    // ...
    func clearTextButtonIsPressed(sender: UIButton) {
     
        // ...
        textView?.text = nil
        
        // ...
        speakAndPauseButton.enabled = false
        
        // ...
        self.synthesizer.stopSpeakingAtBoundary(.Immediate)
        
        // ...
        textViewData = ""
        
        // ...
        self.automaticallyAdjustsScrollViewInsets = false
        
    }
    
    // ...
    func speakAndPauseButtonIsPressed(sender: UIButton) {
     
        // ...
        var textString:NSString = textView.text
        
        // ...
        var charSet:NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        
        // ...
        var trimmedString:NSString = textString.stringByTrimmingCharactersInSet(charSet)
        
        // ...
        if trimmedString.length == 0 {
            
            // ...
            
        } else {
            
            // ...
            if speechPaused == false {
                
                // ...
                speakAndPauseButton.setTitle("Pause", forState: .Normal)
                // ...
                self.synthesizer.continueSpeaking()
                // ...
                speechPaused = true
                
            } else {
                
                // ...
                speakAndPauseButton.setTitle("Speak", forState: .Normal)
                // ...
                speechPaused = false
                // ...
                self.synthesizer.pauseSpeakingAtBoundary(.Immediate)
                
            }
            
            // ...
            if self.synthesizer.speaking == false {
                
                // ...
                var text:String = textView!.text
                // ...
                var utterance:AVSpeechUtterance = AVSpeechUtterance(string:text)
                // ...
                utterance.rate = 0.02
                // ...
                self.synthesizer.speakUtterance(utterance)
                
            }
            
        }
        
    }
    
    // ...
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didFinishSpeechUtterance utterance: AVSpeechUtterance!) {
        
        // ...
        speakAndPauseButton.setTitle("Speak", forState: .Normal)
        
        // ...
        speechPaused = false
        
        // ...
        var sentenceText: String = textView.text
        
        // analyzeText(sentenceText)
        
    }
    
    // ...
    override func didReceiveMemoryWarning() {
        
        // ...
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    
    }

}