//
//  LTMorphingLabel+Sparkle.swift
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
    
    fileprivate func maskedImageForCharLimbo(
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
    
    func SparkleLoad() {
        
        startClosures["Sparkle\(LTMorphingPhases.start)"] = {
            self.emitterView.removeAllEmitters()
        }
        
        progressClosures["Sparkle\(LTMorphingPhases.progress)"] = {
            (index: Int, progress: Float, isNewChar: Bool) in
            
            if !isNewChar {
                return min(1.0, max(0.0, progress))
            }
            
            let j = Float(sin(Float(index))) * 1.5
            return min(
                1.0,
                max(
                    0.0001,
                    progress + self.morphingCharacterDelay * j
                )
            )
            
        }
        
        effectClosures["Sparkle\(LTMorphingPhases.disappear)"] = {
            char, index, progress in
            
            return LTCharacterLimbo(
                char: char,
                rect: self.previousRects[index],
                alpha: CGFloat(1.0 - progress),
                size: self.font.pointSize,
                drawingProgress: 0.0)
        }
        
        effectClosures["Sparkle\(LTMorphingPhases.appear)"] = {
            char, index, progress in
            
            if char != " " {
                let rect = self.newRects[index]
                let emitterPosition = CGPoint(
                    x: rect.origin.x + rect.size.width / 2.0,
                    y: CGFloat(progress) * rect.size.height * 0.9 + rect.origin.y
                )

                self.emitterView.createEmitter(
                    "c\(index)",
                    particleName: "Sparkle",
                    duration: self.morphingDuration
                    ) { (layer, cell) in
                        layer.emitterSize = CGSize(
                            width: rect.size.width,
                            height: 1
                        )
                        layer.renderMode = kCAEmitterLayerOutline
                        cell.emissionLongitude = CGFloat(Double.pi / 2.0)
                        cell.scale = self.font.pointSize / 300.0
                        cell.scaleSpeed = self.font.pointSize / 300.0 * -1.5
                        cell.color = self.textColor.cgColor
                        cell.birthRate =
                            Float(self.font.pointSize)
                            * Float(arc4random_uniform(7) + 3)
                    }.update { (layer, _) in
                        layer.emitterPosition = emitterPosition
                    }.play()
            }

            return LTCharacterLimbo(
                char: char,
                rect: self.newRects[index],
                alpha: CGFloat(self.morphingProgress),
                size: self.font.pointSize,
                drawingProgress: CGFloat(progress)
            )
        }
        
        drawingClosures["Sparkle\(LTMorphingPhases.draw)"] = {
            (charLimbo: LTCharacterLimbo) in
            
            if charLimbo.drawingProgress > 0.0 {
                
                let (charImage, rect) = self.maskedImageForCharLimbo(
                    charLimbo,
                    withProgress: charLimbo.drawingProgress
                )
                charImage.draw(in: rect)
                
                return true
            }
            
            return false
        }
        
        skipFramesClosures["Sparkle\(LTMorphingPhases.skipFrames)"] = {
            return 1
        }
    }
    
}
