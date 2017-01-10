//
//  LTMorphingLabel+Evaporate.swift
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
    
    func EvaporateLoad() {
        
        progressClosures["Evaporate\(LTMorphingPhases.progress)"] = {
            (index: Int, progress: Float, isNewChar: Bool) in
            let j: Int = Int(round(cos(Double(index)) * 1.2))
            let delay = isNewChar ? self.morphingCharacterDelay * -1.0 : self.morphingCharacterDelay
            return min(1.0, max(0.0, self.morphingProgress + delay * Float(j)))
        }
        
        effectClosures["Evaporate\(LTMorphingPhases.disappear)"] = {
            char, index, progress in
            
            let newProgress = LTEasing.easeOutQuint(progress, 0.0, 1.0, 1.0)
            let yOffset: CGFloat = -0.8 * CGFloat(self.font.pointSize) * CGFloat(newProgress)
            let currentRect = self.previousRects[index].offsetBy(dx: 0, dy: yOffset)
            let currentAlpha = CGFloat(1.0 - newProgress)
            
            return LTCharacterLimbo(
                char: char,
                rect: currentRect,
                alpha: currentAlpha,
                size: self.font.pointSize,
                drawingProgress: 0.0)
        }
        
        effectClosures["Evaporate\(LTMorphingPhases.appear)"] = {
            char, index, progress in
            
            let newProgress = 1.0 - LTEasing.easeOutQuint(progress, 0.0, 1.0)
            let yOffset = CGFloat(self.font.pointSize) * CGFloat(newProgress) * 1.2
            
            return LTCharacterLimbo(
                char: char,
                rect: self.newRects[index].offsetBy(dx: 0, dy: yOffset),
                alpha: CGFloat(self.morphingProgress),
                size: self.font.pointSize,
                drawingProgress: 0.0
            )
        }
    }
    
}
