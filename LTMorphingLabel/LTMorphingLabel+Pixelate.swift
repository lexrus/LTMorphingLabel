//
//  LTMorphingLabel+Pixelate.swift
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


extension LTMorphingLabel {
    
    func PixelateLoad() {
        
        _effectClosures["Pixelate\(LTMorphingPhaseDisappear)"] = {
            (char:Character, index: Int, progress: Float) in
            
            return LTCharacterLimbo(
                char: char,
                rect: self._originRects[index],
                alpha: CGFloat(1.0 - progress),
                size: self.font.pointSize,
                drawingProgress: CGFloat(progress))
        }
        
        _effectClosures["Pixelate\(LTMorphingPhaseAppear)"] = {
            (char:Character, index: Int, progress: Float) in
            
            return LTCharacterLimbo(
                char: char,
                rect: self._newRects[index],
                alpha: CGFloat(progress),
                size: self.font.pointSize,
                drawingProgress: CGFloat(1.0 - progress)
            )
        }
        
        _drawingClosures["Pixelate\(LTMorphingPhaseDraw)"] = {
            (charLimbo: LTCharacterLimbo) in
            
            if charLimbo.drawingProgress > 0.0 {
                
                let charImage = self._pixelateImageForCharLimbo(charLimbo, withBlurRadius: charLimbo.drawingProgress * 6.0)
                
                let charRect = charLimbo.rect
                charImage.drawInRect(charLimbo.rect)
                
                return true
            }
            
            return false
        }
    }
    
    func _pixelateImageForCharLimbo(charLimbo: LTCharacterLimbo, withBlurRadius blurRadius: CGFloat) -> UIImage {
        let scale = min(UIScreen.mainScreen().scale, 1.0 / blurRadius)
        UIGraphicsBeginImageContextWithOptions(charLimbo.rect.size, false, scale)
        let fadeOutAlpha = min(1.0, max(0.0, charLimbo.drawingProgress * -2.0 + 2.0 + 0.01))
        let rect = CGRectMake(0, 0, charLimbo.rect.size.width, charLimbo.rect.size.height)
//        let context = UIGraphicsGetCurrentContext()
//        CGContextSetShouldAntialias(context, false)
        String(charLimbo.char).drawInRect(rect, withAttributes: [
            NSFontAttributeName: self.font,
            NSForegroundColorAttributeName: self.textColor.colorWithAlphaComponent(fadeOutAlpha)
            ])
//        CGContextSetShouldAntialias(context, true)
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage
    }
    
}