//
//  LTMorphingLabel+Burn.swift
//  https://github.com/lexrus/LTMorphingLabel
//
//  The MIT License (MIT)
//  Copyright (c) 2016 Lex Tang, http://lexrus.com
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
    
    fileprivate func burningImageForCharLimbo(
        _ charLimbo: LTCharacterLimbo,
        withProgress progress: CGFloat
        ) -> (UIImage, CGRect) {
            let maskedHeight = charLimbo.rect.size.height * max(0.01, progress)
            let maskedSize = CGSize(
                width: charLimbo.rect.size.width,
                height: maskedHeight
            )
            UIGraphicsBeginImageContextWithOptions(
                maskedSize,
                false,
                UIScreen.main.scale
            )
            let rect = CGRect(
                x: 0,
                y: 0,
                width: charLimbo.rect.size.width,
                height: maskedHeight
            )
            String(charLimbo.char).draw(in: rect, withAttributes: [
                NSFontAttributeName: self.font,
                NSForegroundColorAttributeName: self.textColor
                ])
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let newRect = CGRect(
                x: charLimbo.rect.origin.x,
                y: charLimbo.rect.origin.y,
                width: charLimbo.rect.size.width,
                height: maskedHeight
            )
        return (newImage!, newRect)
    }
    
    func BurnLoad() {
        
        startClosures["Burn\(LTMorphingPhases.start)"] = {
            self.emitterView.removeAllEmitters()
        }
        
        progressClosures["Burn\(LTMorphingPhases.progress)"] = {
            index, progress, isNewChar in
            
            if !isNewChar {
                return min(1.0, max(0.0, progress))
            }
            
            let j = Float(sin(Float(index))) * 1.5
            return min(1.0, max(0.0001, progress + self.morphingCharacterDelay * j))
            
        }
        
        effectClosures["Burn\(LTMorphingPhases.disappear)"] = {
            char, index, progress in
            
            return LTCharacterLimbo(
                char: char,
                rect: self.previousRects[index],
                alpha: CGFloat(1.0 - progress),
                size: self.font.pointSize,
                drawingProgress: 0.0
            )
        }
        
        effectClosures["Burn\(LTMorphingPhases.appear)"] = {
            char, index, progress in
            
            if char != " " {
                let rect = self.newRects[index]
                let emitterPosition = CGPoint(
                    x: rect.origin.x + rect.size.width / 2.0,
                    y: CGFloat(progress) * rect.size.height / 1.2 + rect.origin.y
                )
                
                self.emitterView.createEmitter(
                    "c\(index)",
                    particleName: "Fire",
                    duration: self.morphingDuration
                    ) { (layer, cell) in
                        layer.emitterSize = CGSize(
                            width: rect.size.width,
                            height: 1
                        )
                        layer.renderMode = kCAEmitterLayerAdditive
                        layer.emitterMode = kCAEmitterLayerOutline
                        cell.emissionLongitude = CGFloat(M_PI / 2.0)
                        cell.scale = self.font.pointSize / 160.0
                        cell.scaleSpeed = self.font.pointSize / 100.0
                        cell.birthRate = Float(self.font.pointSize)
                        cell.emissionLongitude = CGFloat(arc4random_uniform(30))
                        cell.emissionRange = CGFloat(M_PI_4)
                        cell.alphaSpeed = self.morphingDuration * -3.0
                        cell.yAcceleration = 10
                        cell.velocity = CGFloat(10 + Int(arc4random_uniform(3)))
                        cell.velocityRange = 10
                        cell.spin = 0
                        cell.spinRange = 0
                        cell.lifetime = self.morphingDuration / 3.0
                    }.update { (layer, _) in
                        layer.emitterPosition = emitterPosition
                    }.play()
                
                self.emitterView.createEmitter(
                    "s\(index)",
                    particleName: "Smoke",
                    duration: self.morphingDuration
                    ) { (layer, cell) in
                        layer.emitterSize = CGSize(
                            width: rect.size.width,
                            height: 10
                        )
                        layer.renderMode = kCAEmitterLayerAdditive
                        layer.emitterMode = kCAEmitterLayerVolume
                        cell.emissionLongitude = CGFloat(M_PI / 2.0)
                        cell.scale = self.font.pointSize / 40.0
                        cell.scaleSpeed = self.font.pointSize / 100.0
                        cell.birthRate =
                            Float(self.font.pointSize)
                            / Float(arc4random_uniform(10) + 10)
                        cell.emissionLongitude = 0
                        cell.emissionRange = CGFloat(M_PI_4)
                        cell.alphaSpeed = self.morphingDuration * -3
                        cell.yAcceleration = -5
                        cell.velocity = CGFloat(20 + Int(arc4random_uniform(15)))
                        cell.velocityRange = 20
                        cell.spin = CGFloat(Float(arc4random_uniform(30)) / 10.0)
                        cell.spinRange = 3
                        cell.lifetime = self.morphingDuration
                    }.update { (layer, _) in
                        layer.emitterPosition = emitterPosition
                    }.play()
            }
            
            return LTCharacterLimbo(
                char: char,
                rect: self.newRects[index],
                alpha: 1.0,
                size: self.font.pointSize,
                drawingProgress: CGFloat(progress)
            )
        }
        
        drawingClosures["Burn\(LTMorphingPhases.draw)"] = {
            (charLimbo: LTCharacterLimbo) in
            
            if charLimbo.drawingProgress > 0.0 {
                
                let (charImage, rect) = self.burningImageForCharLimbo(
                    charLimbo,
                    withProgress: charLimbo.drawingProgress
                )
                charImage.draw(in: rect)
                
                return true
            }
            
            return false
        }
        
        skipFramesClosures["Burn\(LTMorphingPhases.skipFrames)"] = {
            return 1
        }
    }
    
}
