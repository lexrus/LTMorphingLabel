//
//  LTMorphingLabel.swift
//  https://github.com/lexrus/LTMorphingLabel
//
//  The MIT License (MIT)
//  Copyright (c) 2015 Lex Tang, http://lexrus.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files
//  (the “Software”), to deal in the Software without restriction,
//  including without limitation the rights to use, copy, modify, merge,
//  publish, distribute, sublicense, and/or sell copies of the Software,
//  and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included
//  in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
//  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
//  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation
import UIKit
import QuartzCore


let phaseStart = "Start"
let phaseAppear = "Appear"
let phaseDisappear = "Disappear"
let phaseDraw = "Draw"
let phaseProgress = "ManipulateProgress"
let phaseSkipFrames = "SkipFrames"


typealias LTMorphingStartClosure =
    (Void) -> Void

typealias LTMorphingEffectClosure =
    (Character, index: Int, progress: Float) -> LTCharacterLimbo

typealias LTMorphingDrawingClosure =
    LTCharacterLimbo -> Bool

typealias LTMorphingManipulateProgressClosure =
    (index: Int, progress: Float, isNewChar: Bool) -> Float

typealias LTMorphingSkipFramesClosure =
    (Void) -> Int


@objc public protocol LTMorphingLabelDelegate {
    optional func morphingDidStart(label: LTMorphingLabel)
    optional func morphingDidComplete(label: LTMorphingLabel)
    optional func morphingOnProgress(label: LTMorphingLabel, _ progress: Float)
}


// MARK: - LTMorphingLabel
@IBDesignable public class LTMorphingLabel: UILabel {
    
    @IBInspectable public var morphingProgress: Float = 0.0
    @IBInspectable public var morphingDuration: Float = 0.6
    @IBInspectable public var morphingCharacterDelay: Float = 0.026
    @IBInspectable public var morphingEnabled: Bool = true
    @IBOutlet public weak var delegate: LTMorphingLabelDelegate?
    public var morphingEffect: LTMorphingEffect = .Scale
    
    var startClosures = [String: LTMorphingStartClosure]()
    var effectClosures = [String: LTMorphingEffectClosure]()
    var drawingClosures = [String: LTMorphingDrawingClosure]()
    var progressClosures = [String: LTMorphingManipulateProgressClosure]()
    var skipFramesClosures = [String: LTMorphingSkipFramesClosure]()
    var diffResults = [LTCharacterDiffResult]()
    var previousText = ""
    
    var currentFrame = 0
    var totalFrames = 0
    var totalDelayFrames = 0
    
    var totalWidth: Float = 0.0
    var previousRects = [CGRect]()
    var newRects = [CGRect]()
    var charHeight: CGFloat = 0.0
    var skipFramesCount: Int = 0
    
    #if TARGET_INTERFACE_BUILDER
    let presentingInIB = true
    #else
    let presentingInIB = false
    #endif
    
    override public var text: String! {
        get {
            return super.text
        }
        set {
            previousText = text ?? ""
            diffResults = previousText >> (newValue ?? "")
            super.text = newValue ?? ""
            
            morphingProgress = 0.0
            currentFrame = 0
            totalFrames = 0
            
            setNeedsLayout()
            
            if !morphingEnabled {
                return
            }
            
            if presentingInIB {
                morphingDuration = 0.01
                morphingProgress = 0.5
            } else if previousText != text {
                displayLink.paused = false
                if let closure = startClosures[
                    "\(morphingEffect.description)\(phaseStart)"
                    ] {
                        return closure()
                }
                
                delegate?.morphingDidStart?(self)
            }
        }
    }
    
    public override func setNeedsLayout() {
        super.setNeedsLayout()
        previousRects = rectsOfEachCharacter(previousText, withFont: font)
        newRects = rectsOfEachCharacter(text ?? "", withFont: font)
    }
    
    override public var bounds: CGRect {
        get {
            return super.bounds
        }
        set {
            super.bounds = newValue
            setNeedsLayout()
        }
    }
    
    override public var frame: CGRect {
        get {
            return super.frame
        }
        set {
            super.frame = newValue
            setNeedsLayout()
        }
    }
    
    private lazy var displayLink: CADisplayLink = {
        let displayLink = CADisplayLink(
            target: self,
            selector: Selector("displayFrameTick"))
        displayLink.addToRunLoop(
            NSRunLoop.currentRunLoop(),
            forMode: NSRunLoopCommonModes)
        return displayLink
        }()
    
    lazy var emitterView: LTEmitterView = {
        let emitterView = LTEmitterView(frame: self.bounds)
        self.addSubview(emitterView)
        return emitterView
        }()
}

// MARK: - Animation extension
extension LTMorphingLabel {
    
    func displayFrameTick() {
        if displayLink.duration > 0.0 && totalFrames == 0 {
            let frameRate = Float(displayLink.duration) / Float(displayLink.frameInterval)
            totalFrames = Int(ceil(morphingDuration / frameRate))
            
            let totalDelay = Float((text!).characters.count) * morphingCharacterDelay
            totalDelayFrames = Int(ceil(totalDelay / frameRate))
        }
        
        if previousText != text && currentFrame++ < totalFrames + totalDelayFrames + 5 {
            morphingProgress += 1.0 / Float(totalFrames)
            
            if let closure = skipFramesClosures[
                "\(morphingEffect.description)\(phaseSkipFrames)"
                ] {
                    if ++skipFramesCount > closure() {
                        skipFramesCount = 0
                        setNeedsDisplay()
                    }
            } else {
                setNeedsDisplay()
            }
            
            if let onProgress = delegate?.morphingOnProgress {
                onProgress(self, morphingProgress)
            }
        } else {
            displayLink.paused = true
            
            delegate?.morphingDidComplete?(self)
        }
    }
    
    // Could be enhanced by kerning text:
    // http://stackoverflow.com/questions/21443625/core-text-calculate-letter-frame-in-ios
    func rectsOfEachCharacter(textToDraw: String, withFont font: UIFont) -> [CGRect] {
        var charRects = [CGRect]()
        var leftOffset: CGFloat = 0.0
        
        charHeight = "Leg".sizeWithAttributes([NSFontAttributeName: font]).height
        
        let topOffset = (bounds.size.height - charHeight) / 2.0
        
        for (_, char) in textToDraw.characters.enumerate() {
            let charSize = String(char).sizeWithAttributes([NSFontAttributeName: font])
            charRects.append(
                CGRect(
                    origin: CGPoint(
                        x: leftOffset,
                        y: topOffset
                    ),
                    size: charSize
                )
            )
            leftOffset += charSize.width
        }
        
        totalWidth = Float(leftOffset)
        
        var stringLeftOffSet: CGFloat = 0.0
        
        switch textAlignment {
        case .Center:
            stringLeftOffSet = CGFloat((Float(bounds.size.width) - totalWidth) / 2.0)
        case .Right:
            stringLeftOffSet = CGFloat(Float(bounds.size.width) - totalWidth)
        default:
            ()
        }
        
        var offsetedCharRects = [CGRect]()
        
        for r in charRects {
            offsetedCharRects.append(CGRectOffset(r, stringLeftOffSet, 0.0))
        }
        
        return offsetedCharRects
    }
    
    func limboOfOriginalCharacter(
        char: Character,
        index: Int,
        progress: Float) -> LTCharacterLimbo {
            
            var currentRect = previousRects[index]
            let oriX = Float(currentRect.origin.x)
            var newX = Float(currentRect.origin.x)
            let diffResult = diffResults[index]
            var currentFontSize: CGFloat = font.pointSize
            var currentAlpha: CGFloat = 1.0
            
            switch diffResult.diffType {
                // Move the character that exists in the new text to current position
            case .Move, .MoveAndAdd, .Same:
                newX = Float(newRects[index + diffResult.moveOffset].origin.x)
                currentRect.origin.x = CGFloat(
                    LTEasing.easeOutQuint(progress, oriX, newX - oriX)
                )
            default:
                // Otherwise, remove it
                
                // Override morphing effect with closure in extenstions
                if let closure = effectClosures[
                    "\(morphingEffect.description)\(phaseDisappear)"
                    ] {
                        return closure(char, index: index, progress: progress)
                } else {
                    // And scale it by default
                    let fontEase = CGFloat(
                        LTEasing.easeOutQuint(
                            progress, 0, Float(font.pointSize)
                        )
                    )
                    // For emojis
                    currentFontSize = max(0.0001, font.pointSize - fontEase)
                    currentAlpha = CGFloat(1.0 - progress)
                    currentRect = CGRectOffset(previousRects[index], 0,
                        CGFloat(font.pointSize - currentFontSize))
                }
            }
            
            return LTCharacterLimbo(
                char: char,
                rect: currentRect,
                alpha: currentAlpha,
                size: currentFontSize,
                drawingProgress: 0.0
            )
    }
    
    func limboOfNewCharacter(
        char: Character,
        index: Int,
        progress: Float) -> LTCharacterLimbo {
            
            let currentRect = newRects[index]
            var currentFontSize = CGFloat(
                LTEasing.easeOutQuint(progress, 0, Float(font.pointSize))
            )
            
            if let closure = effectClosures[
                "\(morphingEffect.description)\(phaseAppear)"
                ] {
                    return closure(char, index: index, progress: progress)
            } else {
                currentFontSize = CGFloat(
                    LTEasing.easeOutQuint(progress, 0.0, Float(font.pointSize))
                )
                // For emojis
                currentFontSize = max(0.0001, currentFontSize)
                
                let yOffset = CGFloat(font.pointSize - currentFontSize)
                
                return LTCharacterLimbo(
                    char: char,
                    rect: CGRectOffset(currentRect, 0.0, yOffset),
                    alpha: CGFloat(morphingProgress),
                    size: currentFontSize,
                    drawingProgress: 0.0
                )
            }
    }
    
    func limboOfCharacters() -> [LTCharacterLimbo] {
        var limbo = [LTCharacterLimbo]()
        
        // Iterate original characters
        for (i, character) in previousText.characters.enumerate() {
            var progress: Float = 0.0
            
            if let closure = progressClosures[
                "\(morphingEffect.description)\(phaseProgress)"
                ] {
                    progress = closure(index: i, progress: morphingProgress, isNewChar: false)
            } else {
                progress = min(1.0, max(0.0, morphingProgress + morphingCharacterDelay * Float(i)))
            }
            
            let limboOfCharacter = limboOfOriginalCharacter(character, index: i, progress: progress)
            limbo.append(limboOfCharacter)
        }
        
        // Add new characters
        for (i, character) in (text!).characters.enumerate() {
            if i >= diffResults.count {
                break
            }
            
            var progress: Float = 0.0
            
            if let closure = progressClosures[
                "\(morphingEffect.description)\(phaseProgress)"
                ] {
                    progress = closure(index: i, progress: morphingProgress, isNewChar: true)
            } else {
                progress = min(1.0, max(0.0, morphingProgress - morphingCharacterDelay * Float(i)))
            }
            
            // Don't draw character that already exists
            let diffResult = diffResults[i]
            if diffResult.skip {
                continue
            }
            
            switch diffResult.diffType {
            case .MoveAndAdd, .Replace, .Add, .Delete:
                let limboOfCharacter = limboOfNewCharacter(character, index: i, progress: progress)
                limbo.append(limboOfCharacter)
            default:
                ()
            }
        }
        
        return limbo
    }

}


// MARK: - Drawing extension
extension LTMorphingLabel {
    
    override public func didMoveToSuperview() {
        if let s = text {
            text = s
        }
        
        // Load all morphing effects
        for effectName: String in LTMorphingEffect.allValues {
            let effectFunc = Selector("\(effectName)Load")
            if respondsToSelector(effectFunc) {
                performSelector(effectFunc)
            }
        }
    }
    
    override public func drawTextInRect(rect: CGRect) {
        if !morphingEnabled {
            super.drawTextInRect(rect)
            return
        }
        
        for charLimbo in limboOfCharacters() {
            let charRect = charLimbo.rect
            
            let willAvoidDefaultDrawing: Bool = {
                if let closure = drawingClosures[
                    "\(morphingEffect.description)\(phaseDraw)"
                    ] {
                        return closure($0)
                }
                return false
                }(charLimbo)
            
            if !willAvoidDefaultDrawing {
                let s = String(charLimbo.char)
                s.drawInRect(charRect, withAttributes: [
                    NSFontAttributeName:
                        font.fontWithSize(charLimbo.size),
                    NSForegroundColorAttributeName:
                        textColor.colorWithAlphaComponent(charLimbo.alpha)
                    ])
            }
        }
    }

}
