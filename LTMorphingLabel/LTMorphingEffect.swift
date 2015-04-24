//
//  LTMorphingEffect.swift
//  LTMorphingLabelDemo
//
//  Created by Lex on 3/15/15.
//  Copyright (c) 2015 LexTang.com. All rights reserved.
//

import UIKit


@objc public enum LTMorphingEffect: Int, Printable {
    case Scale = 0
    case Evaporate
    case Fall
    case Pixelate
    case Sparkle
    case Burn
    case Anvil
    
    static let allValues = ["Scale", "Evaporate", "Fall", "Pixelate", "Sparkle", "Burn", "Anvil"]
    
    public var description: String {
        get {
            switch self {
            case .Evaporate:
                return "Evaporate"
            case .Fall:
                return "Fall"
            case .Pixelate:
                return "Pixelate"
            case .Sparkle:
                return "Sparkle"
            case .Burn:
                return "Burn"
            case .Anvil:
                return "Anvil"
            default:
                return "Scale"
            }
        }
    }
}