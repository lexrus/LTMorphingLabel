//
//  LTDemoViewController.swift
//  LTMorphingLabelDemo
//
//  Created by Lex on 6/23/14.
//  Copyright (c) 2015 lexrus.com. All rights reserved.
//

import UIKit

class LTDemoViewController : UIViewController, LTMorphingLabelDelegate {
    
    fileprivate var i = -1
    fileprivate var textArray = [
        "What is design?",
        "Design", "Design is not just", "what it looks like", "and feels like.",
        "Design", "is how it works.", "- Steve Jobs",
        "Older people", "sit down and ask,", "'What is it?'",
        "but the boy asks,", "'What can I do with it?'.", "- Steve Jobs",
        "", "Swift", "Objective-C", "iPhone", "iPad", "Mac Mini",
        "MacBook Pro🔥", "Mac Pro⚡️",
        "爱老婆",
        "老婆和女儿"
    ]
    fileprivate var text: String {
        i = i >= textArray.count - 1 ? 0 : i + 1
        return textArray[i]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.delegate = self
    }

    @IBOutlet fileprivate var label: LTMorphingLabel!
    
    @IBAction func changeText(_ sender: AnyObject) {
        label.text = text
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        let seg = sender
        if let effect = LTMorphingEffect(rawValue: seg.selectedSegmentIndex) {
            label.morphingEffect = effect
            changeText(sender)
        }
    }

    @IBAction func toggleLight(_ sender: UISegmentedControl) {
        let isNight = Bool(sender.selectedSegmentIndex == 0)
        view.backgroundColor = isNight ? UIColor.black : UIColor.white
        label.textColor = isNight ? UIColor.white : UIColor.black
    }
    
    @IBAction func changeFontSize(_ sender: UISlider) {
        label.font = UIFont.init(name: label.font.fontName, size: CGFloat(sender.value))
        label.text = label.text
    }
}

extension LTDemoViewController {
    
    func morphingDidStart(_ label: LTMorphingLabel) {
        
    }
    
    func morphingDidComplete(_ label: LTMorphingLabel) {
        
    }
    
    func morphingOnProgress(_ label: LTMorphingLabel, progress: Float) {
        
    }
    
}
