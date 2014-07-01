//
//  LTEasing.swift
//  LTMorphingLabelDemo
//
//  Created by Lex on 7/1/14.
//  Copyright (c) 2014 LexTang.com. All rights reserved.
//

import UIKit

// http://gsgd.co.uk/sandbox/jquery/easing/jquery.easing.1.3.js
// t = currentTime
// b = beginning
// c = change
// d = duration

class LTEasing {
    
    class func easeOutQuint(t: Float, _ b: Float, _ c: Float, _ d: Float = 1.0) -> Float {
        return {
            return c * ($0 * $0 * $0 * $0 * $0 + 1.0) + b
            }(t / d - 1.0)
    }
    
    class func easeInQuint(t: Float, _ b: Float, _ c: Float, _ d: Float = 1.0) -> Float {
        return {
            return c * $0 * $0 * $0 * $0 * $0 + b
            }(t / d)
    }
    
    class func easeOutBack(t: Float, _ b: Float, _ c: Float, _ d: Float = 1.0) -> Float {
        let s: Float = 2.70158
        let t2: Float = t / d - 1.0
        return Float(c * (t2 * t2 * ((s + 1.0) * t2 + s) + 1.0)) + b
    }
}
