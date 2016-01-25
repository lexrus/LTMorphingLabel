//
//  LTDemoViewController.swift
//  LTMorphingLabelDemo
//
//  Created by Lex on 6/23/14.
//  Copyright (c) 2015 lexrus.com. All rights reserved.
//

import UIKit

class LTDemoViewController : UIViewController, LTMorphingLabelDelegate {
    
    private var i = 0
    private var textArray = [
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
    private var text: String {
        if i >= textArray.count {
            i = 0
        }
        return textArray[i++]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.delegate = self
    }
    
    deinit {
        label.delegate = nil
    }

    @IBOutlet private var label: LTMorphingLabel!
    @IBAction func changeText(sender: AnyObject) {
        label.text = text
    }
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        let seg = sender
        switch seg.selectedSegmentIndex {
        case 1:
            label.morphingEffect = .Evaporate
        case 2:
            label.morphingEffect = .Fall
        case 3:
            label.morphingEffect = .Pixelate
        case 4:
            label.morphingEffect = .Sparkle
        case 5:
            label.morphingEffect = .Burn
        case 6:
            label.morphingEffect = .Anvil
        default:
            label.morphingEffect = .Scale
        }
        
        changeText(sender)
    }

    @IBAction func toggleLight(sender: UISegmentedControl) {
        let isNight = Bool(sender.selectedSegmentIndex == 0)
        view.backgroundColor = isNight ? UIColor.blackColor() : UIColor.whiteColor()
        label.textColor = isNight ? UIColor.whiteColor() : UIColor.blackColor()
    }
    
    @IBAction func changeFontSize(sender: UISlider) {
        label.font = UIFont.init(name: label.font.fontName, size: CGFloat(sender.value))
        label.text = label.text
        label.setNeedsDisplay()
    }
}

extension LTDemoViewController {
    
    func morphingDidStart(label: LTMorphingLabel) {
        
    }
    
    func morphingDidComplete(label: LTMorphingLabel) {
        
    }
    
    func morphingOnProgress(label: LTMorphingLabel, _ progress: Float) {
        
    }
    
}
