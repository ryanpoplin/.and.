//
//  DetailViewController.swift
//  AACcess
//
//  Created by Byrdann Fox on 2/11/15.
//  Copyright (c) 2015 ExcepApps, Inc. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import QuartzCore
import JavaScriptCore

// configure the classes to communicate without public variables/constants, etc...
public var textViewData: String!
public var textViewRef: UITextView!
public var speakAndPauseButton: UIButton!

class DetailViewController: UIViewController, UITextViewDelegate, AVSpeechSynthesizerDelegate {
    
    internal let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    internal var speechPaused: Bool = false
    
    internal var synthesizer: AVSpeechSynthesizer!
    
    var textView: UITextView!
    
    var clearTextButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        view.backgroundColor = UIColor.whiteColor()
        
        /* textView */
        
        textView = UITextView(frame: CGRect(x: 20, y: 80, width: 660, height: 220))
        
        textView.font = UIFont.systemFontOfSize(45)
        
        textView.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(textView)
        
        self.textView.delegate = self
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        textView.becomeFirstResponder()
        
        textViewRef = textView
        
        /* clearTextButton */
        
        clearTextButton = UIButton.buttonWithType(.System) as? UIButton
        
        clearTextButton.frame = CGRect(x: 240, y: 312, width: 100, height: 50)
        
        clearTextButton.backgroundColor = UIColor.lightGrayColor()
        
        clearTextButton.exclusiveTouch = true
        
        clearTextButton.layer.cornerRadius = 5
        
        clearTextButton.setTitle("Clear", forState: .Normal)
        
        clearTextButton.addTarget(self, action: "clearTextButtonIsPressed:", forControlEvents: .TouchDown)
        
        clearTextButton.titleLabel!.font = UIFont.systemFontOfSize(20)
        
        view.addSubview(clearTextButton)
        
        /* speakAndPauseButton */
        
        speakAndPauseButton = UIButton.buttonWithType(.System) as? UIButton
        
        speakAndPauseButton.frame = CGRect(x: 360, y: 312, width: 100, height: 50)
        
        speakAndPauseButton.backgroundColor = UIColor.lightGrayColor()
        
        speakAndPauseButton.exclusiveTouch = true
        
        speakAndPauseButton.layer.cornerRadius = 5
        
        speakAndPauseButton.setTitle("Speak", forState: .Normal)
        
        speakAndPauseButton.addTarget(self, action: "speakAndPauseButtonIsPressed:", forControlEvents: .TouchDown)
        
        speakAndPauseButton.titleLabel!.font = UIFont.systemFontOfSize(20)
        
        view.addSubview(speakAndPauseButton)
        
        if textView.text == "" {
            
            speakAndPauseButton.enabled = false
            
        }
        
        /* Speech Synthesizer */
        
        self.synthesizer = AVSpeechSynthesizer()
        
        self.synthesizer.delegate = self
        
        speechPaused = false
        
    }
    
    func textViewDidChange(textView: UITextView) {
        
        // keep for config. of text and speak feature ref...
        // testness = String(last(textView.text)!)
        
        var textString: NSString = textView.text
        
        var charSet: NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        
        var trimmedString: NSString = textString.stringByTrimmingCharactersInSet(charSet)
        
        textViewData = String(trimmedString)
        
        if trimmedString.length == 0 {
            
            speakAndPauseButton.enabled = false
            
        } else {
            
            speakAndPauseButton.enabled = true
            
        }
        
    }
    
    func clearTextButtonIsPressed(sender: UIButton) {
     
        textView?.text = nil
        
        speakAndPauseButton.enabled = false
        
        self.synthesizer.stopSpeakingAtBoundary(.Immediate)
        
        textViewData = nil
        
        textView.becomeFirstResponder()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
    }
    
    func speakAndPauseButtonIsPressed(sender: UIButton) {
     
        var textString:NSString = textView.text
        
        var charSet:NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        
        var trimmedString:NSString = textString.stringByTrimmingCharactersInSet(charSet)
        
        if trimmedString.length == 0 {
            
            // ...
            
        } else {
            
            if speechPaused == false {
                
                speakAndPauseButton.setTitle("Pause", forState: .Normal)
                self.synthesizer.continueSpeaking()
                speechPaused = true
                
            } else {
                
                speakAndPauseButton.setTitle("Speak", forState: .Normal)
                speechPaused = false
                self.synthesizer.pauseSpeakingAtBoundary(.Immediate)
                
            }
            
            if self.synthesizer.speaking == false {
                
                var text:String = textView.text
                var utterance:AVSpeechUtterance = AVSpeechUtterance(string:text)
                utterance.rate = 0.02
                self.synthesizer.speakUtterance(utterance)
                
            }
            
        }
        
    }
    
    /* CONFIGURE THE PROPER ALGORITHM FOR THIS FEATURE... */
    
//    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//    
//        // ...
//        var textString:NSString = textView.text
//        
//        // ...
//        var charSet:NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
//        
//        // ...
//        var trimmedString:NSString = textString.stringByTrimmingCharactersInSet(charSet)
//        
//        // ...
//        if text == " " {
//            
//            // ...
//            if speechPaused == false {
//                
//                // ...
//                speakAndPauseButton.setTitle("Pause", forState: .Normal)
//                // ...
//                self.synthesizer.continueSpeaking()
//                // ...
//                speechPaused = true
//                
//            } else {
//                
//                // ...
//                speakAndPauseButton.setTitle("Speak", forState: .Normal)
//                // ...
//                speechPaused = false
//                // ...
//                self.synthesizer.pauseSpeakingAtBoundary(.Immediate)
//                
//            }
//            
//            // ...
//            if self.synthesizer.speaking == false {
//                
//                var testaa = textView.text
//                
//                // ...
//                var text:String = textView.text
//                // ...
//                var utterance:AVSpeechUtterance = AVSpeechUtterance(string:text)
//                // ...
//                utterance.rate = 0.02
//                // ...
//                self.synthesizer.speakUtterance(utterance)
//                
//            }
//
//            
//        }
//        
//        return true
//        
//    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didFinishSpeechUtterance utterance: AVSpeechUtterance!) {
        
        speakAndPauseButton.setTitle("Speak", forState: .Normal)
        
        speechPaused = false
        
        var sentenceText: String = textView.text
        
         analyzeText(sentenceText)
        
    }
    
    func analyzeText(text: String) {
        
        let context = JSContext(virtualMachine: JSVirtualMachine())
        
        let path = NSBundle.mainBundle().pathForResource("text-analyzer", ofType: "js")
        
        let content = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil)
        
        context.evaluateScript(content)
        
        let analyzeText = context.objectForKeyedSubscript("analyzeText")
        
        analyzeText.callWithArguments([text])
        
        let getSentences = context.objectForKeyedSubscript("getSentences")
        
        let getWordsCount = context.objectForKeyedSubscript("getWordsCount")
        
        let getWordsPerSentence = context.objectForKeyedSubscript("getWordsPerSentence")
        
        let getAverageWordLength = context.objectForKeyedSubscript("getAverageWordLength")
        
        var sentences = getSentences.callWithArguments([]).toNumber()
        var wordsCount = getWordsCount.callWithArguments([]).toNumber()
        var wordsPerSentence = getWordsPerSentence.callWithArguments([]).toNumber()
        var averageWordLength = getAverageWordLength.callWithArguments([]).toNumber()
        
        var dataDic:NSDictionary = [
            "text": text,
            "sentences": sentences,
            "wordsCount": wordsCount,
            "wordsPerSentence": wordsPerSentence,
            "averageWordLength": averageWordLength
        ]
        
        println(dataDic)

        // configure an efficent and required way to deal with the networking feature with keen, parse, etc...
        
        let sentenceSpoken:NSString = "sentence_spoken"
        
        KeenClient.sharedClient().addEvent(dataDic, toEventCollection: sentenceSpoken, error: nil)
        
        KeenClient.sharedClient().uploadWithFinishedBlock({ (Void) -> Void in })
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    
    }

}