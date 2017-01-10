//
//  LTMorphingLabel+Pixelate.swift
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
    
    func PixelateLoad() {
        
        effectClosures["Pixelate\(LTMorphingPhases.disappear)"] = {
            char, index, progress in
            
            return LTCharacterLimbo(
                char: char,
                rect: self.previousRects[index],
                alpha: CGFloat(1.0 - progress),
                size: self.font.pointSize,
                drawingProgress: CGFloat(progress))
        }
        
        effectClosures["Pixelate\(LTMorphingPhases.appear)"] = {
            char, index, progress in
            
            return LTCharacterLimbo(
                char: char,
                rect: self.newRects[index],
                alpha: CGFloat(progress),
                size: self.font.pointSize,
                drawingProgress: CGFloat(1.0 - progress)
            )
        }
        
        drawingClosures["Pixelate\(LTMorphingPhases.draw)"] = {
            limbo in
            
            if limbo.drawingProgress > 0.0 {
                
                let charImage = self.pixelateImageForCharLimbo(
                    limbo,
                    withBlurRadius: limbo.drawingProgress * 6.0
                )
                
                charImage.draw(in: limbo.rect)
                
                return true
            }
            
            return false
        }
    }
    
    fileprivate func pixelateImageForCharLimbo(
        _ charLimbo: LTCharacterLimbo,
        withBlurRadius blurRadius: CGFloat
        ) -> UIImage {
            let scale = min(UIScreen.main.scale, 1.0 / blurRadius)
            UIGraphicsBeginImageContextWithOptions(charLimbo.rect.size, false, scale)
            let fadeOutAlpha = min(1.0, max(0.0, charLimbo.drawingProgress * -2.0 + 2.0 + 0.01))
            let rect = CGRect(
                x: 0,
                y: 0,
                width: charLimbo.rect.size.width,
                height: charLimbo.rect.size.height
            )
            String(charLimbo.char).draw(in: rect, withAttributes: [
                NSFontAttributeName:
                    self.font,
                NSForegroundColorAttributeName:
                    self.textColor.withAlphaComponent(fadeOutAlpha)
                ])
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!
    }
    
}
