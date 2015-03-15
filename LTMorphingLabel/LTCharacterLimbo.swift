//
//  LTCharacterLimbo.swift
//  LTMorphingLabelDemo
//
//  Created by Lex on 3/15/15.
//  Copyright (c) 2015 LexTang.com. All rights reserved.
//

import UIKit


struct LTCharacterLimbo: DebugPrintable {
    
    let char: Character
    var rect: CGRect
    var alpha: CGFloat
    var size: CGFloat
    var drawingProgress: CGFloat = 0.0
    
    var debugDescription: String {
        get {
            return "Character: '\(char)'"
                + "drawIn (\(rect.origin.x), \(rect.origin.y), "
                + "\(rect.size.width)x\(rect.size.height) "
                + "with alpha \(alpha) "
                + "and \(size)pt font."
        }
    }
    
}