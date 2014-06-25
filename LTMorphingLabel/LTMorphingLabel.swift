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
    var morphingDuration:Float = 0.36
    var morphingCharacterDelay:Float = 0.03
    
    var _diffResults = Array<LTCharacterDiffResult>()
    var _originText = ""
    var _currentFrame = 0
    var _totalFrames = 0
    var _totalWidth: Float = 0.0
    let _characterOffsetYRatio = 1.1
    
    override var text:String! {
    get {
        return super.text
    }
    set {
        _originText = self.text
        _diffResults = _originText >> newValue
        super.text = newValue
        
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
        
        if displayLink.duration > 0.0 {
            let displayLinkDuration = Float(displayLink.duration)
            _totalFrames = Int(roundf((morphingDuration + totalDelay) / displayLinkDuration))
        }
        
        if _currentFrame++ < _totalFrames {
            morphingProgress += 1.0 / Float(_totalFrames)
            self.setNeedsDisplay()
        } else {
            displayLink.paused = true
        }
    }
    
    // http://gsgd.co.uk/sandbox/jquery/easing/jquery.easing.1.3.js
    func easeOutQuint(currentTime:Float, beginning:Float, change:Float, duration:Float) -> Float {
        var t = currentTime / duration - 1.0
        return change*(t*t*t*t*t + 1.0) + beginning;
    }
    
    // Could be enhanced by kerning text:
    // http://stackoverflow.com/questions/21443625/core-text-calculate-letter-frame-in-ios
    func rectsOfEachCharacter(textToDraw:String) -> Array<CGRect> {
        var charRects = Array<CGRect>()
        var leftOffset:CGFloat = 0.0
        
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
    
    func limboOfCharacters() -> Array<LTCharacterLimbo> {
        let fontSize = font.pointSize
        let s = self.text as String
        var limbo = Array<LTCharacterLimbo>()
        
        let originRects = rectsOfEachCharacter(_originText)
        var newRects = rectsOfEachCharacter(s)
        var targetLeftOffSet:CGFloat = 0.0
        
        for (i, character) in enumerate(_originText) {
            var currentRect = originRects[i]
            var currentAlpha: CGFloat = 1.0
            var currentFontSize: CGFloat = font.pointSize
            let progress:Float = min(1.0, max(0.0, morphingProgress + morphingCharacterDelay * Float(i)))
            
            let diffResult = _diffResults[i]
            
            switch diffResult.diffType {
            case .Move, .MoveAndAdd:
                var originRect = originRects[i]
                var charOffset = diffResult.moveOffset
                let oriX = Float(originRect.origin.x)
                let newX = Float(newRects[i + charOffset].origin.x)
                var currentX = easeOutQuint(progress,
                    beginning: oriX,
                    change: newX - oriX,
                    duration: 1.0)
                currentRect.origin.x = CGFloat(currentX)
            case .Same:
                let oriX = Float(currentRect.origin.x)
                let newX = Float(newRects[i].origin.x)
                var currentX = easeOutQuint(progress,
                    beginning: oriX,
                    change: newX - oriX,
                    duration: 1.0)
                currentRect.origin.x = CGFloat(currentX)
            default:
                currentFontSize = CGFloat(fontSize - CGFloat(easeOutQuint(progress,
                    beginning: 0,
                    change: Float(fontSize),
                    duration: 1.0)))
                var currentRect = originRects[i]
                currentAlpha = CGFloat(1.0 - progress)
            }
            
            currentRect.origin.y += (fontSize - currentFontSize) / _characterOffsetYRatio
            limbo.append(LTCharacterLimbo(
                char: character,
                rect: currentRect,
                alpha: currentAlpha,
                size: currentFontSize
                ))
        }
        
        for (i, character) in enumerate(s) {
            if i >= countElements(_diffResults) {
                break
            }
            
            var progress = min(1.0, max(0.0, morphingProgress - morphingCharacterDelay * Float(i)))
            var currentRect = newRects[i]
            var currentAlpha: CGFloat = 1.0
            var currentFontSize: CGFloat = font.pointSize
            
            
            let diffResult = _diffResults[i]
            if diffResult.skip {
                continue
            }
            
            switch diffResult.diffType {
            case .MoveAndAdd, .Replace, .Add, .Delete:
                currentFontSize = CGFloat(easeOutQuint(progress,
                    beginning: 0,
                    change: Float(fontSize),
                    duration: 1.0))
                currentRect.origin.y += (fontSize - currentFontSize) / _characterOffsetYRatio
                currentAlpha = CGFloat(morphingProgress)
                limbo.append(LTCharacterLimbo(
                    char: character,
                    rect: currentRect,
                    alpha: currentAlpha,
                    size: currentFontSize))
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
        for charLimbo in limboOfCharacters() {
            self.textColor.colorWithAlphaComponent(charLimbo.alpha).setFill()
            
            String(charLimbo.char).bridgeToObjectiveC().drawInRect(
                charLimbo.rect,
                withFont: self.font.fontWithSize(charLimbo.size),
                lineBreakMode: NSLineBreakMode.ByWordWrapping,
                alignment: NSTextAlignment.Center)
        }
    }
}