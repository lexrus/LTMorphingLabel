//
//  LTDemoViewController.swift
//  LTMorphingLabelDemo
//
//  Created by Lex on 6/23/14.
//  Copyright (c) 2014 LexTang.com. All rights reserved.
//

import UIKit

class LTDemoViewController: UIViewController {
    
    var i = 0
    var textArray = ["Design", "Design is not just", "what it looks like", "and feels like.", "Design", "is how it works.", "- Steve Jobs", "Swift", "Objective-C", "iPhone", "iPad", "Mac Mini", "MacBook Pro", "Mac Pro", "老婆 & 女儿"]
    var text:String {
    get {
        if i >= countElements(textArray) {
            i = 0
        }
        return textArray[i++]
    }
    }

    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBOutlet var label: LTMorphingLabel
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
        default:
            self.label.morphingEffect = .Scale
        }
    }
}
