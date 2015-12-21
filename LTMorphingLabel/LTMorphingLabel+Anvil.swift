//
//  LTMorphingLabel+Anvil.swift
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

import UIKit


extension LTMorphingLabel {
    
    func AnvilLoad() {
        
        startClosures["Anvil\(phaseStart)"] = {
            self.emitterView.removeAllEmitters()
            
            guard self.newRects.count > 0 else { return }
            
            let centerRect = self.newRects[Int(self.newRects.count / 2)]

            self.emitterView.createEmitter(
                "leftSmoke",
                particleName: "Smoke",
                duration: 0.6
                ) { (layer, cell) in
                    layer.emitterSize = CGSize(width: 1, height: 1)
                    layer.emitterPosition = CGPoint(
                        x: centerRect.origin.x,
                        y: centerRect.origin.y + centerRect.size.height / 1.3)
                    layer.renderMode = kCAEmitterLayerSurface
                    cell.emissionLongitude = CGFloat(M_PI / 2.0)
                    cell.scale = self.font.pointSize / 90.0
                    cell.scaleSpeed = self.font.pointSize / 130
                    cell.birthRate = 60
                    cell.velocity = CGFloat(80 + Int(arc4random_uniform(60)))
                    cell.velocityRange = 100
                    cell.yAcceleration = -40
                    cell.xAcceleration = 70
                    cell.emissionLongitude = CGFloat(-M_PI_2)
                    cell.emissionRange = CGFloat(M_PI_4) / 5.0
                    cell.lifetime = self.morphingDuration * 2.0
                    cell.spin = 10
                    cell.alphaSpeed = -0.5 / self.morphingDuration
            }
            
            self.emitterView.createEmitter(
                "rightSmoke",
                particleName: "Smoke",
                duration: 0.6
                ) { (layer, cell) in
                    layer.emitterSize = CGSize(width: 1, height: 1)
                    layer.emitterPosition = CGPoint(
                        x: centerRect.origin.x,
                        y: centerRect.origin.y + centerRect.size.height / 1.3)
                    layer.renderMode = kCAEmitterLayerSurface
                    cell.emissionLongitude = CGFloat(M_PI / 2.0)
                    cell.scale = self.font.pointSize / 90.0
                    cell.scaleSpeed = self.font.pointSize / 130
                    cell.birthRate = 60
                    cell.velocity = CGFloat(80 + Int(arc4random_uniform(60)))
                    cell.velocityRange = 100
                    cell.yAcceleration = -40
                    cell.xAcceleration = -70
                    cell.emissionLongitude = CGFloat(M_PI_2)
                    cell.emissionRange = CGFloat(-M_PI_4) / 5.0
                    cell.lifetime = self.morphingDuration * 2.0
                    cell.spin = -10
                    cell.alphaSpeed = -0.5 / self.morphingDuration
            }
            
            self.emitterView.createEmitter(
                "leftFragments",
                particleName: "Fragment",
                duration: 0.6
                ) { (layer, cell) in
                    layer.emitterSize = CGSize(
                        width: self.font.pointSize,
                        height: 1
                    )
                    layer.emitterPosition = CGPoint(
                        x: centerRect.origin.x,
                        y: centerRect.origin.y + centerRect.size.height / 1.3
                    )
                    cell.scale = self.font.pointSize / 90.0
                    cell.scaleSpeed = self.font.pointSize / 40.0
                    cell.color = self.textColor.CGColor
                    cell.birthRate = 60
                    cell.velocity = 350
                    cell.yAcceleration = 0
                    cell.xAcceleration = CGFloat(10 * Int(arc4random_uniform(10)))
                    cell.emissionLongitude = CGFloat(-M_PI_2)
                    cell.emissionRange = CGFloat(M_PI_4) / 5.0
                    cell.alphaSpeed = -2
                    cell.lifetime = self.morphingDuration
            }
            
            self.emitterView.createEmitter(
                "rightFragments",
                particleName: "Fragment",
                duration: 0.6
                ) { (layer, cell) in
                    layer.emitterSize = CGSize(
                        width: self.font.pointSize,
                        height: 1
                    )
                    layer.emitterPosition = CGPoint(
                        x: centerRect.origin.x,
                        y: centerRect.origin.y + centerRect.size.height / 1.3)
                    cell.scale = self.font.pointSize / 90.0
                    cell.scaleSpeed = self.font.pointSize / 40.0
                    cell.color = self.textColor.CGColor
                    cell.birthRate = 60
                    cell.velocity = 350
                    cell.yAcceleration = 0
                    cell.xAcceleration = CGFloat(-10 * Int(arc4random_uniform(10)))
                    cell.emissionLongitude = CGFloat(M_PI_2)
                    cell.emissionRange = CGFloat(-M_PI_4) / 5.0
                    cell.alphaSpeed = -2
                    cell.lifetime = self.morphingDuration
            }
            
            self.emitterView.createEmitter(
                "fragments",
                particleName: "Fragment",
                duration: 0.6
                ) { (layer, cell) in
                    layer.emitterSize = CGSize(
                        width: self.font.pointSize,
                        height: 1
                    )
                    layer.emitterPosition = CGPoint(
                        x: centerRect.origin.x,
                        y: centerRect.origin.y + centerRect.size.height / 1.3)
                    cell.scale = self.font.pointSize / 90.0
                    cell.scaleSpeed = self.font.pointSize / 40.0
                    cell.color = self.textColor.CGColor
                    cell.birthRate = 60
                    cell.velocity = 250
                    cell.velocityRange = CGFloat(Int(arc4random_uniform(20)) + 30)
                    cell.yAcceleration = 500
                    cell.emissionLongitude = 0
                    cell.emissionRange = CGFloat(M_PI_2)
                    cell.alphaSpeed = -1
                    cell.lifetime = self.morphingDuration
            }
        }
        
        progressClosures["Anvil\(phaseProgress)"] = {
            (index: Int, progress: Float, isNewChar: Bool) in
            
            if !isNewChar {
                return min(1.0, max(0.0, progress))
            }
            
            let j = Float(sin(Float(index))) * 1.7
            return min(1.0, max(0.0001, progress + self.morphingCharacterDelay * j))
            
        }
        
        effectClosures["Anvil\(phaseDisappear)"] = {
            char, index, progress in
            
            return LTCharacterLimbo(
                char: char,
                rect: self.previousRects[index],
                alpha: CGFloat(1.0 - progress),
                size: self.font.pointSize,
                drawingProgress: 0.0)
        }
        
        effectClosures["Anvil\(phaseAppear)"] = {
            char, index, progress in
            
            var rect = self.newRects[index]
            
            if progress < 1.0 {
                let easingValue = LTEasing.easeOutBounce(progress, 0.0, 1.0)
                rect.origin.y = CGFloat(Float(rect.origin.y) * easingValue)
            }
            
            if progress > self.morphingDuration * 0.5 {
                let end = self.morphingDuration * 0.55
                self.emitterView.createEmitter(
                    "fragments",
                    particleName: "Fragment",
                    duration: 0.6
                    ) {_ in}.update {
                        (layer, cell) in
                        if progress > end {
                            layer.birthRate = 0
                        }
                    }.play()
                self.emitterView.createEmitter(
                    "leftFragments",
                    particleName: "Fragment",
                    duration: 0.6
                    ) {_ in}.update {
                        (layer, cell) in
                        if progress > end {
                            layer.birthRate = 0
                        }
                    }.play()
                self.emitterView.createEmitter(
                    "rightFragments",
                    particleName: "Fragment",
                    duration: 0.6
                    ) {_ in}.update {
                        (layer, cell) in
                        if progress > end {
                            layer.birthRate = 0
                        }
                    }.play()
            }
            
            if progress > self.morphingDuration * 0.63 {
                let end = self.morphingDuration * 0.7
                self.emitterView.createEmitter(
                    "leftSmoke",
                    particleName: "Smoke",
                    duration: 0.6
                    ) {_ in}.update {
                        (layer, cell) in
                        if progress > end {
                            layer.birthRate = 0
                        }
                    }.play()
                self.emitterView.createEmitter(
                    "rightSmoke",
                    particleName: "Smoke",
                    duration: 0.6
                    ) {_ in}.update {
                        (layer, cell) in
                        if progress > end {
                            layer.birthRate = 0
                        }
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
