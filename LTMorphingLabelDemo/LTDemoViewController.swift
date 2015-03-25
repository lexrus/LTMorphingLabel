//
//  LTDemoViewController.swift
//  LTMorphingLabelDemo
//
//  Created by Lex on 6/23/14.
//  Copyright (c) 2015 LexTang.com. All rights reserved.
//

import UIKit

class LTDemoViewController: UIViewController, LTMorphingLabelDelegate {
    
    var i = 0
    var textArray = ["What is design?", "Design", "Design is not just", "what it looks like", "and feels like.", "Design", "is how it works.", "- Steve Jobs", "Older people", "sit down and ask,", "'What is it?'", "but the boy asks,", "'What can I do with it?'.", "- Steve Jobs", "", "Swift", "Objective-C", "iPhone", "iPad", "Mac Mini", "MacBook Pro", "Mac Pro", "老婆 & 女儿"]
    var text:String {
    get {
        if i >= textArray.count {
            i = 0
        }
        return textArray[i++]
    }
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.label.text = "Tap me please."
        
        self.label.delegate = self
    }

    @IBOutlet var label: LTMorphingLabel!
    @IBAction func changeText(sender: AnyObject) {
        label.text = text
    }
    
    @IBAction func segmentChanged(sender: AnyObject) {
        let seg = sender as UISegmentedControl
        switch seg.selectedSegmentIndex {
        case 1:
            self.label.morphingEffect = .Evaporate
        case 2:
            self.label.morphingEffect = .Fall
        case 3:
            self.label.morphingEffect = .Pixelate
        case 4:
            self.label.morphingEffect = .Sparkle
        case 5:
            self.label.morphingEffect = .Burn
        case 6:
            self.label.morphingEffect = .Anvil
        default:
            self.label.morphingEffect = .Scale
        }
        
        self.changeText(sender);
    }

    @IBAction func toggleLight(sender: UISegmentedControl) {
        let isNight = Bool(sender.selectedSegmentIndex == 0)
        self.view.backgroundColor = isNight ? UIColor.blackColor() : UIColor.whiteColor()
        self.label.textColor = isNight ? UIColor.whiteColor() : UIColor.blackColor()
    }
    
    @IBAction func changeFontSize(sender: UISlider) {
        self.label.font = self.label.font.fontWithSize(CGFloat(sender.value))
        self.label.text = self.label.text
        self.label.setNeedsDisplay()
    }
}

extension LTDemoViewController {
    
    func morphingDidStart(label: LTMorphingLabel) {
//        println("\(label) did start morphing.")
    }
    
    func morphingDidComplete(label: LTMorphingLabel) {
//        println("\(label) did complete morphing.")
    }
    
    func morphingOnProgress(label: LTMorphingLabel, _ progress: Float) {
//        println("\(label) is morphing on progress: \(progress)")
    }
    
}
