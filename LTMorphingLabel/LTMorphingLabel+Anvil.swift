//
//  LTMorphingLabel+Anvil.swift
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
    
    func AnvilLoad() {
        
        _startClosures["Anvil\(LTMorphingPhaseStart)"] = {
            self.emitterView.removeAllEmit()
            
            if countElements(self._newRects) > 0 {
                self.emitterView.createEmitter("leftSmoke", duration: 0.6) {
                    (layer, cell) in
                    let x = self._newRects[0].origin.x
                    layer.emitterSize = CGSizeMake(self.font.pointSize , 1)
                    layer.emitterPosition = CGPointMake(x, self.bounds.size.height - self._newRects[0].size.height)
                    layer.renderMode = kCAEmitterLayerSurface
                    cell.contents = UIImage(named: "Smoke").CGImage
                    cell.emissionLongitude = CGFloat(M_PI / 2.0)
                    cell.scale = self.font.pointSize / 600.0
                    cell.scaleSpeed = self.font.pointSize / 50
                    cell.color = self.textColor.CGColor
                    cell.velocity = 80
                    cell.velocityRange = 100
                    cell.yAcceleration = -20
                    cell.xAcceleration = 100
                    cell.emissionLongitude = CGFloat(-M_PI_2)
                    cell.emissionRange = CGFloat(M_PI_4) / 5.0
                    cell.lifetime = self.morphingDuration
                    cell.spin = 5
                    cell.alphaSpeed = -1.0 / self.morphingDuration
                }
                
                self.emitterView.createEmitter("rightSmoke", duration: 0.6) {
                    (layer, cell) in
                    let lastRect = self._newRects[self._newRects.count - 1]
                    let x = lastRect.origin.x + lastRect.size.width
                    layer.emitterSize = CGSizeMake(self.font.pointSize , 1)
                    layer.emitterPosition = CGPointMake(x, self.bounds.size.height - self._newRects[0].size.height)
                    layer.renderMode = kCAEmitterLayerSurface
                    cell.contents = UIImage(named: "Smoke").CGImage
                    cell.emissionLongitude = CGFloat(M_PI / 2.0)
                    cell.scale = self.font.pointSize / 600.0
                    cell.scaleSpeed = self.font.pointSize / 50
                    cell.color = self.textColor.CGColor
                    cell.velocity = 80
                    cell.velocityRange = 100
                    cell.yAcceleration = -20
                    cell.xAcceleration = -100
                    cell.emissionLongitude = CGFloat(M_PI_2)
                    cell.emissionRange = CGFloat(M_PI_4) / 5.0
                    cell.lifetime = self.morphingDuration
                    cell.spin = -5
                    cell.alphaSpeed = -1.0 / self.morphingDuration
                }
            }
        }
        
        _progressClosures["Anvil\(LTMorphingPhaseManipulateProgress)"] = {
            (index: Int, progress: Float, isNewChar: Bool) in
            
            if !isNewChar {
                return min(1.0, max(0.0, progress))
            }
            
            let j = Float(sin(Float(index))) * 1.7
            return min(1.0, max(0.0001, progress + self.morphingCharacterDelay * j))
            
        }
        
        _effectClosures["Anvil\(LTMorphingPhaseDisappear)"] = {
            (char:Character, index: Int, progress: Float) in
            
            return LTCharacterLimbo(
                char: char,
                rect: self._originRects[index],
                alpha: CGFloat(1.0 - progress),
                size: self.font.pointSize,
                drawingProgress: 0.0)
        }
        
        _effectClosures["Anvil\(LTMorphingPhaseAppear)"] = {
            (char:Character, index: Int, progress: Float) in
            
            var rect = self._newRects[index]
            
            if progress < 1.0 {
                let easingValue: Float = LTEasing.easeOutBounce(progress, 0.0, 1.0)
                rect.origin.y = CGFloat(Float(rect.origin.y) * easingValue)
            }
            
            if char != " " && progress > 0.2 {
                let emitterPosition = CGPointMake(
                    rect.origin.x + rect.size.width / 2.0,
                    CGFloat(progress) * rect.size.height + rect.origin.y)
                
                self.emitterView.createEmitter("c\(index)", duration: 0.6) {
                    (layer, cell) in
                    layer.emitterSize = CGSizeMake(rect.size.width , 1)
                    layer.emitterPosition = CGPointMake(
                        rect.origin.x + rect.size.width / 2.0, rect.size.height + rect.origin.y)
                    cell.contents = UIImage(named: "Fragment").CGImage
                    cell.emissionLongitude = CGFloat(M_PI / 2.0)
                    cell.scale = self.font.pointSize / 50.0
                    cell.scaleSpeed = self.font.pointSize / 50.0 * -1.5
                    cell.color = self.textColor.CGColor
                    cell.birthRate = Float(arc4random_uniform(5) + 1)
                    cell.velocity = 150
                    cell.velocityRange = CGFloat(arc4random_uniform(200) + 50)
                    cell.yAcceleration = 800
                    cell.emissionLongitude = 0
                    cell.emissionRange = CGFloat(M_PI_4)
                    cell.lifetime = self.morphingDuration / 2.0
                }.play()
            }
            
            if progress > 0.5 {
                self.emitterView.createEmitter("leftSmoke", duration: 0.6) {_ in}.update {
                    (layer, cell) in
                    cell.birthRate = progress / 0.6 * 30
                    }.play()
                self.emitterView.createEmitter("rightSmoke", duration: 0.6) {_ in}.update {
                    (layer, cell) in
                    cell.birthRate = progress / 0.6 * 30
                    }.play()
            }
                
            return LTCharacterLimbo(
                char: char,
                rect: rect,
                alpha: CGFloat(self.morphingProgress),
                size: self.font.pointSize,
                drawingProgress: CGFloat(progress)
            )
        }
    }
    
}
