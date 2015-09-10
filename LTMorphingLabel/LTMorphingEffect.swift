//
//  LTMorphingEffect.swift
//  LTMorphingLabelDemo
//
//  Created by Lex on 3/15/15.
//  Copyright (c) 2015 lexrus.com. All rights reserved.
//

import UIKit


@objc public enum LTMorphingEffect : Int, CustomStringConvertible {

    case Scale = 0
    case Evaporate
    case Fall
    case Pixelate
    case Sparkle
    case Burn
    case Anvil
    
    public static let allValues = [
        "Scale", "Evaporate", "Fall", "Pixelate", "Sparkle", "Burn", "Anvil"
    ]
    
    public var description: String {
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