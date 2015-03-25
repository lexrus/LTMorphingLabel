//
//  LTCharacterLimbo.swift
//  LTMorphingLabelDemo
//
//  Created by Lex on 3/15/15.
//  Copyright (c) 2015 LexTang.com. All rights reserved.
//

import UIKit


public struct LTCharacterLimbo: DebugPrintable {
    
    public let char: Character
    public var rect: CGRect
    public var alpha: CGFloat
    public var size: CGFloat
    public var drawingProgress: CGFloat = 0.0
    
    public var debugDescription: String {
        get {
            return "Character: '\(char)'"
                + "drawIn (\(rect.origin.x), \(rect.origin.y), "
                + "\(rect.size.width)x\(rect.size.height) "
                + "with alpha \(alpha) "
                + "and \(size)pt font."
        }
    }
    
}