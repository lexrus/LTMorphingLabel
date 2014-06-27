//
//  LTMorphingLabel.swift
//  https://github.com/lexrus/LTMorphingLabel
//
//  Created by Lex on 6/24/14.
//  Copyright (c) 2014 LexTang.com. All rights reserved.
//
//  The MIT License (MIT)
//  Copyright © 2014 Lex Tang, http://LexTang.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the “Software”), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import UIKit
import QuartzCore


enum LTMorphingMethod: Int {
    case ScaleAndFade = 0
    case EvaporateAndFade
//    case FallDownAndFade
}


struct LTCharacterLimbo: DebugPrintable {
    
    var char: Character
    var rect: CGRect
    var alpha: CGFloat
    var size: CGFloat
    
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


class LTMorphingLabel: UILabel {
    
    var morphingProgress:Float = 0.0
    var morphingDuration:Float = 0.3
    var morphingCharacterDelay:Float = 0.026
    var morphingMethod: LTMorphingMethod = .ScaleAndFade
    
    var _diffResults = Array<LTCharacterDiffResult>()
    var _originText = ""
    var _currentFrame = 0
    var _totalFrames = 0
    var _totalWidth: Float = 0.0
    let _characterOffsetYRatio = 1.1
    var _originRects = Array<CGRect>()
    var _newRects = Array<CGRect>()
    
    override var text:String! {
    get {
        return super.text
    }
    set {
        _originText = self.text
        _originRects = rectsOfEachCharacter(_originText)
        _diffResults = _originText >> newValue
        super.text = newValue
        _newRects = rectsOfEachCharacter(self.text!)
        
        morphingProgress = 0.0
        _currentFrame = 0
        self.displayLink.paused = false
    }
    }
    
    @lazy var displayLink: CADisplayLink = {
        let _displayLink = CADisplayLink(
            target: self,
            selector: Selector.convertFromStringLiteral("_displayFrameTick"))
        _displayLink.addToRunLoop(
            NSRunLoop.currentRunLoop(),
            forMode: NSRunLoopCommonModes)
        return _displayLink
        }()
    
}

// Animation
extension LTMorphingLabel {
    
    func _displayFrameTick() {
        let s = self.text as String
        let totalDelay = Float(countElements(s) + countElements(_originText)) * morphingCharacterDelay
        let framesForCharacterDelay = Int(ceilf(totalDelay))
        
        if displayLink.duration > 0.0 && _totalFrames == 0 {
            _totalFrames = Int(roundf((morphingDuration + totalDelay) / Float(displayLink.duration)))
        }
        
        if _currentFrame++ < _totalFrames + 20 {
            morphingProgress += 1.0 / Float(_totalFrames)
            self.setNeedsDisplay()
        } else {
            displayLink.paused = true
        }
    }
    
    // http://gsgd.co.uk/sandbox/jquery/easing/jquery.easing.1.3.js
    func easeOutQuint(currentTime:Float, beginning:Float, change:Float, duration:Float) -> Float {
        return {
            return change * ($0 * $0 * $0 * $0 * $0 + 1.0) + beginning
            }(currentTime / duration - 1.0)
    }
    
    func easeOutQuint(t:Float, _ b: Float, _ c: Float) -> Float {
        return easeOutQuint(t, beginning:b, change:c, duration:1.0)
    }
    
    func easeInQuint(currentTime: Float, beginning: Float, change: Float, duration: Float) -> Float {
        return {
            return change * $0 * $0 * $0 * $0 * $0 + beginning
        }(currentTime / duration)
    }
    
    func easeInQuint(t: Float, _ b: Float, _ c: Float) -> Float {
        return easeInQuint(t, beginning:b, change:c, duration:1.0)
    }
    
    // Could be enhanced by kerning text:
    // http://stackoverflow.com/questions/21443625/core-text-calculate-letter-frame-in-ios
    func rectsOfEachCharacter(textToDraw:String) -> Array<CGRect> {
        var charRects = Array<CGRect>()
        var leftOffset: CGFloat = 0.0
        
        for (i, char) in enumerate(textToDraw) {
            let charSize = String(char).bridgeToObjectiveC().sizeWithFont(self.font)
            charRects.append(CGRect(origin: CGPointMake(leftOffset, 0), size: charSize))
            leftOffset += charSize.width
        }
        
        _totalWidth = Float(leftOffset)
        
        var stringLeftOffSet: CGFloat = 0.0
        
        switch textAlignment {
        case .Center:
            stringLeftOffSet = CGFloat((Float(bounds.size.width) - _totalWidth) / 2.0)
        case .Right:
            stringLeftOffSet = CGFloat(Float(bounds.size.width) - _totalWidth)
        default:
            NSNotFound
        }
        
        var offsetedCharRects = Array<CGRect>()
        
        for r in charRects {
            offsetedCharRects.append(CGRectOffset(r, stringLeftOffSet, 0.0))
        }
        
        return offsetedCharRects
    }
    
    func limboOfOriginalCharacter(
        char: Character,
        index: Int,
        progress: Float) -> LTCharacterLimbo {
            
            let oriX = Float(_originRects[index].origin.x)
            var currentRect = _originRects[index]
            var newX = Float(currentRect.origin.x)
            var currentFontSize = font.pointSize
            var currentAlpha:CGFloat = 1.0
            var diffResult = _diffResults[index]
            
            switch diffResult.diffType {
            // Move the character that exists in the new text to current position
            case .Move, .MoveAndAdd, .Same:
                newX = Float(_newRects[index + diffResult.moveOffset].origin.x)
                currentRect.origin.x = CGFloat(easeOutQuint(progress, oriX, newX - oriX))
            default:
                // Otherwise, remove it
                
                switch morphingMethod {
                case .EvaporateAndFade:
                    let newProgress = easeInQuint(progress, 0.0, 1.0)
                    var yOffset = font.pointSize * Double(newProgress) * -1.0
                    currentRect = CGRectOffset(currentRect, 0, yOffset)
                default:
                    currentFontSize = font.pointSize - CGFloat(easeOutQuint(progress, 0, Float(font.pointSize)))
                    currentRect = CGRectOffset(currentRect, 0,
                        (font.pointSize - currentFontSize) / _characterOffsetYRatio)
                }
                
                currentAlpha = CGFloat(1.0 - progress)
            }
            
            let limbo = LTCharacterLimbo(
                char: char,
                rect: currentRect,
                alpha: currentAlpha,
                size: currentFontSize
            )
            return limbo
    }
    
    func limboOfNewCharacter(
        char: Character,
        index: Int,
        progress: Float) -> LTCharacterLimbo {
            
            var currentRect = _newRects[index]
            var newX = Float(currentRect.origin.x)
            var currentFontSize = CGFloat(easeOutQuint(progress, 0, Float(font.pointSize)))
            var currentAlpha:CGFloat = CGFloat(morphingProgress)
            
            switch morphingMethod {
            case .EvaporateAndFade:
                let newProgress = 1.0 - easeInQuint(progress, 0.0, 1.0)
                var yOffset = font.pointSize * Double(newProgress) * 0.6
                currentRect = CGRectOffset(currentRect, 0, yOffset)
            default:
                currentFontSize = CGFloat(easeOutQuint(progress, 0, Float(font.pointSize)))
                currentRect = CGRectOffset(currentRect, 0,
                    (font.pointSize - currentFontSize) / _characterOffsetYRatio)
            }
            
            return LTCharacterLimbo(
                char: char,
                rect: currentRect,
                alpha: currentAlpha,
                size: currentFontSize)
    }
    
    func limboOfCharacters() -> Array<LTCharacterLimbo> {
        let fontSize = font.pointSize
        var limbo = Array<LTCharacterLimbo>()
        
        // Iterate original characters
        for (i, character) in enumerate(_originText) {
            var progress: Float = 0.0
            
            switch morphingMethod {
            case .EvaporateAndFade:
                let j: Int = Int(round(cos(Double(i)) * 2.0))
                progress = min(1.0, max(0.0, morphingProgress - morphingCharacterDelay * Float(j)))
            default:
                progress = min(1.0, max(0.0, morphingProgress + morphingCharacterDelay * Float(i)))
            }

            let limboOfCharacter = limboOfOriginalCharacter(character, index: i, progress: progress)
            limbo.append(limboOfCharacter)
        }
        
        // Add new characters
        for (i, character) in enumerate(self.text!) {
            if i >= countElements(_diffResults) {
                break
            }
            
            var progress: Float = 0.0
            
            switch morphingMethod {
            case .EvaporateAndFade:
                let j: Int = Int(round(cos(Double(i)) * 2.0))
                progress = min(1.0, max(0.0, morphingProgress + morphingCharacterDelay * Float(j)))
            default:
                progress = min(1.0, max(0.0, morphingProgress - morphingCharacterDelay * Float(i)))
            }
            
            // Don't draw character that already exists
            let diffResult = _diffResults[i]
            if diffResult.skip {
                continue
            }
            
            switch diffResult.diffType {
            case .MoveAndAdd, .Replace, .Add, .Delete:
                let limboOfCharacter = limboOfNewCharacter(character, index: i, progress: progress)
                limbo.append(limboOfCharacter)
            default:
                NSNotFound
            }
        }
        
        return limbo
    }
}

// Overrides
extension LTMorphingLabel {
    override func didMoveToSuperview() {
        let s = self.text
        self.text = s
    }
    
    override func drawTextInRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext();
        
//        CGContextSaveGState(context);
        
        for charLimbo in limboOfCharacters() {
//            CGContextRotateCTM(context, -(M_PI/2.0) * Double(morphingProgress));
            self.textColor.colorWithAlphaComponent(charLimbo.alpha).setFill()
            
            String(charLimbo.char).bridgeToObjectiveC().drawInRect(
                charLimbo.rect,
                withFont: self.font.fontWithSize(charLimbo.size),
                lineBreakMode: NSLineBreakMode.ByWordWrapping,
                alignment: NSTextAlignment.Center)
            
        }
        
//        CGContextRestoreGState(context);
    }
}