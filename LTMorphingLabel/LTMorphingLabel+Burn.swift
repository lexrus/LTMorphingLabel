//
//  LTMorphingLabel+Burn.swift
//  https://github.com/lexrus/LTMorphingLabel
//
//  The MIT License (MIT)
//  Copyright (c) 2014 Lex Tang, http://LexTang.com
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
//

import UIKit
import QuartzCore


extension LTMorphingLabel {
    
    func _burningImageForCharLimbo(charLimbo: LTCharacterLimbo, withProgress progress: CGFloat) -> (UIImage, CGRect) {
        let maskedHeight = charLimbo.rect.size.height * max(0.01, progress)
        let maskedSize = CGSizeMake( charLimbo.rect.size.width, maskedHeight)
        UIGraphicsBeginImageContextWithOptions(maskedSize, false, UIScreen.mainScreen().scale)
        let rect = CGRectMake(0, 0, charLimbo.rect.size.width, maskedHeight)
        String(charLimbo.char).drawInRect(rect, withAttributes: [
            NSFontAttributeName: self.font,
            NSForegroundColorAttributeName: self.textColor
            ])
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        let newRect = CGRectMake(
            charLimbo.rect.origin.x,
            charLimbo.rect.origin.y,
            charLimbo.rect.size.width,
            maskedHeight)
        return (newImage, newRect)
    }
    
    func BurnLoad() {
        
        _startClosures["Burn\(LTMorphingPhaseStart)"] = {
            self.emitterView.removeAllEmit()
        }
        
        _progressClosures["Burn\(LTMorphingPhaseManipulateProgress)"] = {
            (index: Int, progress: Float, isNewChar: Bool) in
            
            if !isNewChar {
                return min(1.0, max(0.0, progress))
            }
            
            let j = Float(sin(Float(index))) * 1.5
            return min(1.0, max(0.0001, progress + self.morphingCharacterDelay * j))
            
        }
        
        _effectClosures["Burn\(LTMorphingPhaseDisappear)"] = {
            (char:Character, index: Int, progress: Float) in
            
            return LTCharacterLimbo(
                char: char,
                rect: self._originRects[index],
                alpha: CGFloat(1.0 - progress),
                size: self.font.pointSize,
                drawingProgress: 0.0
            )
        }
        
        _effectClosures["Burn\(LTMorphingPhaseAppear)"] = {
            (char:Character, index: Int, progress: Float) in
            
            if char != " " {
                let rect = self._newRects[index]
                let emitterPosition = CGPointMake(
                    rect.origin.x + rect.size.width / 2.0,
                    CGFloat(progress) * rect.size.height / 1.6 + rect.origin.y * 1.4)
                
                self.emitterView.createEmitter("c\(index)", duration: self.morphingDuration) {
                    (layer, cell) in
                    layer.emitterSize = CGSizeMake(rect.size.width , 1)
                    layer.renderMode = kCAEmitterLayerAdditive
                    layer.emitterMode = kCAEmitterLayerOutline
                    cell.emissionLongitude = CGFloat(M_PI / 2.0)
                    cell.scale = self.font.pointSize / 200.0
                    cell.scaleSpeed = self.font.pointSize / 100.0
                    cell.birthRate = Float(self.font.pointSize)
                    cell.contents = UIImage(named: "Fire")!.CGImage
                    cell.emissionLongitude = 0
                    cell.emissionRange = CGFloat(M_PI_4)
                    cell.alphaSpeed = -1.0
                    cell.yAcceleration = 10
                    cell.velocity = CGFloat(10 + Int(arc4random_uniform(3)))
                    cell.velocityRange = 10
                    cell.spin = 0
                    cell.spinRange = 0
                    cell.lifetime = self.morphingDuration
                    }.update {
                        (layer, cell) in
                        layer.emitterPosition = emitterPosition
                    }.play()
                
                self.emitterView.createEmitter("s\(index)", duration: self.morphingDuration) {
                    (layer, cell) in
                    layer.emitterSize = CGSizeMake(rect.size.width , 10)
                    layer.renderMode = kCAEmitterLayerUnordered
                    layer.emitterMode = kCAEmitterLayerOutline
                    cell.emissionLongitude = CGFloat(M_PI / 2.0)
                    cell.scale = self.font.pointSize / 40.0
                    cell.scaleSpeed = self.font.pointSize / 100.0
                    cell.birthRate = Float(self.font.pointSize) / Float(arc4random_uniform(10) + 20)
                    cell.contents = UIImage(named: "Smoke")!.CGImage
                    cell.emissionLongitude = 0
                    cell.emissionRange = CGFloat(M_PI_4)
                    cell.alphaSpeed = self.morphingDuration / -3.0
                    cell.yAcceleration = 10
                    cell.velocity = CGFloat(20 + Int(arc4random_uniform(15)))
                    cell.velocityRange = 20
                    cell.spin = CGFloat(Float(arc4random_uniform(30)) / 10.0)
                    cell.spinRange = 5
                    cell.lifetime = self.morphingDuration
                    }.update {
                        (layer, cell) in
                        layer.emitterPosition = emitterPosition
                    }.play()
            }
            
            return LTCharacterLimbo(
                char: char,
                rect: self._newRects[index],
                alpha: 1.0,
                size: self.font.pointSize,
                drawingProgress: CGFloat(progress)
            )
        }
        
        _drawingClosures["Burn\(LTMorphingPhaseDraw)"] = {
            (charLimbo: LTCharacterLimbo) in
            
            if charLimbo.drawingProgress > 0.0 {
                
                let (charImage, rect) = self._burningImageForCharLimbo(charLimbo, withProgress: charLimbo.drawingProgress)
                charImage.drawInRect(rect)
                
                return true
            }
            
            return false
        }
        
        _skipFramesClosures["Burn\(LTMorphingPhaseSkipFrames)"] = {
            return 1
        }
    }
    
}
