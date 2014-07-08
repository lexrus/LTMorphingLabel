//
//  LTMorphingLabel+Sparkle.swift
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
import SpriteKit


var kSceneKey = "kSceneKey"
let kScenePointer = ConstUnsafePointer<String>(COpaquePointer(&kSceneKey))
var kParticleViewKey = "kParticleViewKey"
let kParticleViewPointer = ConstUnsafePointer<String>(COpaquePointer(&kParticleViewKey))


extension LTMorphingLabel {
    
    var scene: SKScene? {
    get {
        var _sceneObject : AnyObject? = objc_getAssociatedObject(self, kScenePointer)
        if let _scene : AnyObject = _sceneObject? {
            return _scene as? SKScene
        }
        let _scene = SKScene(size: self.bounds.size)
        _scene.scaleMode = .AspectFit
        _scene.backgroundColor = UIColor.clearColor()!
        self.scene = _scene
        return _scene
    }
    set {
        objc_setAssociatedObject(self, kScenePointer, newValue,
            objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
    }
    }
    
    var particleView: SKView? {
    get {
        var _viewObject : AnyObject? = objc_getAssociatedObject(self, kParticleViewPointer)
        if let _view : AnyObject = _viewObject? {
            return _view as? SKView
        }
        let _view = SKView()
        _view.allowsTransparency = true
        _view.backgroundColor = UIColor.clearColor()!
        _view.frame = self.bounds
        self.addSubview(_view)
        _view.presentScene(self.scene)
        self.particleView = _view
        return _view
    }
    set {
        objc_setAssociatedObject(self, kParticleViewPointer, newValue,
            objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
    }
    }
    
    func emitterNodeOfName(name: String) -> SKEmitterNode {
        if let node = self.scene!.childNodeWithName(name) as? SKEmitterNode {
            return node
        }
        let myParticlePath = NSBundle.mainBundle().pathForResource("Sparkle", ofType:"sks")
        if let node: SKEmitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(myParticlePath) as? SKEmitterNode {
            node.numParticlesToEmit = Int(self.font.pointSize * 2.5)
            node.particleColorSequence = SKKeyframeSequence(keyframeValues: [self.textColor], times: [0.0])
            node.name = name
            node.particleScale = self.font.pointSize / 230.0
            self.scene!.addChild(node)
            return node
        }
        return SKEmitterNode()
    }
    
    func _maskedImageForCharLimbo(charLimbo: LTCharacterLimbo, withProgress progress: CGFloat) -> (UIImage, CGRect) {
        let maskedHeight = charLimbo.rect.size.height * max(0.01, progress)
        let maskedSize = CGSizeMake( charLimbo.rect.size.width, maskedHeight)
        UIGraphicsBeginImageContextWithOptions(maskedSize, false, UIScreen.mainScreen().scale)
        let rect = CGRectMake(0, 0, charLimbo.rect.size.width, maskedHeight)
        String(charLimbo.char).bridgeToObjectiveC().drawInRect(rect, withAttributes: [
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
    
    func SparkleLoad() {
        
        _startClosures["Sparkle\(LTMorphingPhaseStart)"] = {
            self.particleView!.paused = false
            
            for node: AnyObject in self.scene!.children {
                if node.respondsToSelector(Selector("resetSimulation")) {
                    node.removeFromParent()
                }
            }
        }
        
        _progressClosures["Sparkle\(LTMorphingPhaseManipulateProgress)"] = {
            (index: Int, progress: Float, isNewChar: Bool) in
            
            if !isNewChar {
                return min(1.0, max(0.0, progress - self.morphingCharacterDelay * Float(index)))
            }
            
            let j = Float(sin(Double(index))) * 1.6
            return min(1.0, max(0.0001, progress + self.morphingCharacterDelay * j))
            
        }
        
        _effectClosures["Sparkle\(LTMorphingPhaseDisappear)"] = {
            (char:Character, index: Int, progress: Float) in
            
            return LTCharacterLimbo(
                char: char,
                rect: self._originRects[index],
                alpha: CGFloat(1.0 - progress),
                size: self.font.pointSize,
                drawingProgress: 0.0)
        }
        
        _effectClosures["Sparkle\(LTMorphingPhaseAppear)"] = {
            (char:Character, index: Int, progress: Float) in
            
            if char != " " {
                let node = self.emitterNodeOfName("c\(index)")
                let rect = self._newRects[index]
                
                node.position = CGPointMake(
                    rect.origin.x + rect.size.width / 2.0,
                    self.bounds.size.height - CGFloat(progress) * rect.size.height - rect.origin.y)
                node.particlePositionRange = CGVector(rect.size.width, self.font.pointSize / 5)
            }
            
            return LTCharacterLimbo(
                char: char,
                rect: self._newRects[index],
                alpha: CGFloat(self.morphingProgress),
                size: self.font.pointSize,
                drawingProgress: CGFloat(progress)
            )
        }
        
        _drawingClosures["Sparkle\(LTMorphingPhaseDraw)"] = {
            (charLimbo: LTCharacterLimbo) in
            
            if charLimbo.drawingProgress > 0.0 {
                
                let (charImage, rect) = self._maskedImageForCharLimbo(charLimbo, withProgress: charLimbo.drawingProgress)
                charImage.drawInRect(rect)
                
                return true
            }
            
            return false
        }
    }
    
}
