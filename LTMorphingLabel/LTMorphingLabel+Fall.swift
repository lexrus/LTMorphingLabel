//
//  LTMorphingLabel+Fall.swift
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
    
    func FallLoad() {
        
        progressClosures["Fall\(phaseProgress)"] = {
            (index: Int, progress: Float, isNewChar: Bool) in
            
            if isNewChar {
                return min(
                    1.0,
                    max(
                        0.0,
                        progress
                            - self.morphingCharacterDelay
                            * Float(index)
                            / 1.7
                    )
                )
            }
            
            let j: Float = Float(sin(Double(index))) * 1.7
            return min(1.0, max(0.0001, progress + self.morphingCharacterDelay * Float(j)))
            
        }
        
        effectClosures["Fall\(phaseDisappear)"] = {
            char, index, progress in
            
            return LTCharacterLimbo(
                char: char,
                rect: self.previousRects[index],
                alpha: CGFloat(1.0 - progress),
                size: self.font.pointSize,
                drawingProgress: CGFloat(progress))
        }
        
        effectClosures["Fall\(phaseAppear)"] = {
            char, index, progress in
            
            let currentFontSize = CGFloat(
                LTEasing.easeOutQuint(progress, 0.0, Float(self.font.pointSize))
            )
            let yOffset = CGFloat(self.font.pointSize - currentFontSize)
            
            return LTCharacterLimbo(
                char: char,
                rect: CGRectOffset(self.newRects[index], 0.0, yOffset),
                alpha: CGFloat(self.morphingProgress),
                size: currentFontSize,
                drawingProgress: 0.0
            )
        }
        
        
        drawingClosures["Fall\(phaseDraw)"] = {
            limbo in
            
            if limbo.drawingProgress > 0.0 {
                let context = UIGraphicsGetCurrentContext()
                var charRect = limbo.rect
                CGContextSaveGState(context)
                let charCenterX = charRect.origin.x + (charRect.size.width / 2.0)
                var charBottomY = charRect.origin.y + charRect.size.height - self.font.pointSize / 6
                var charColor = self.textColor
                
                // Fall down if drawingProgress is more than 50%
                if limbo.drawingProgress > 0.5 {
                    let ease = CGFloat(
                        LTEasing.easeInQuint(
                            Float(limbo.drawingProgress - 0.4),
                            0.0,
                            1.0,
                            0.5
                        )
                    )
                    charBottomY = charBottomY + ease * 10.0
                    let fadeOutAlpha = min(
                        1.0,
                        max(
                            0.0,
                            limbo.drawingProgress * -2.0 + 2.0 + 0.01
                        )
                    )
                    charColor = self.textColor.colorWithAlphaComponent(fadeOutAlpha)
                }
                
                charRect = CGRect(
                    x: charRect.size.width / -2.0,
                    y: charRect.size.height * -1.0 + self.font.pointSize / 6,
                    width: charRect.size.width,
                    height: charRect.size.height)
                CGContextTranslateCTM(context, charCenterX, charBottomY)
                
                let angle = Float(sin(Double(limbo.rect.origin.x)) > 0.5 ? 168 : -168)
                let rotation = CGFloat(
                    LTEasing.easeOutBack(
                        min(
                            1.0,
                            Float(limbo.drawingProgress)
                        ),
                        0.0,
                        1.0
                    ) * angle
                )
                CGContextRotateCTM(context, rotation * CGFloat(M_PI) / 180.0)
                let s = String(limbo.char)
                s.drawInRect(charRect, withAttributes: [
                    NSFontAttributeName: self.font.fontWithSize(limbo.size),
                    NSForegroundColorAttributeName: charColor
                    ])
                CGContextRestoreGState(context)
                
                return true
            }
            
            return false
        }
    }
    
}
