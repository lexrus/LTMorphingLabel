//
//  LTEmitterView.swift
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


public struct LTEmitter {
    
    let layer: CAEmitterLayer = {
        let layer = CAEmitterLayer()
        layer.emitterPosition = CGPoint(x: 10, y: 10)
        layer.emitterSize = CGSize(width: 10, height: 1)
        layer.renderMode = kCAEmitterLayerOutline
        layer.emitterShape = kCAEmitterLayerLine
        return layer
        }()
    
    let cell: CAEmitterCell = {
        let cell = CAEmitterCell()
        cell.name = "sparkle"
        cell.birthRate = 150.0
        cell.velocity = 50.0
        cell.velocityRange = -80.0
        cell.lifetime = 0.16
        cell.lifetimeRange = 0.1
        cell.emissionLongitude = CGFloat(M_PI_2 * 2.0)
        cell.emissionRange = CGFloat(M_PI_2 * 2.0)
        cell.scale = 0.1
        cell.yAcceleration = 100
        cell.scaleSpeed = -0.06
        cell.scaleRange = 0.1
        return cell
        }()
    
    public var duration: Float = 0.6
    
    init(name: String, particleName: String, duration: Float) {
        cell.name = name
        self.duration = duration
        var image: UIImage?
        defer {
            cell.contents = image?.CGImage
        }

        image = UIImage(named: particleName)

        if image != nil {
            return
        }
        // Load from Framework
        image = UIImage(
            named: particleName,
            inBundle: NSBundle(forClass: LTMorphingLabel.self),
            compatibleWithTraitCollection: nil)
    }
    
    public func play() {
        if layer.emitterCells?.count > 0 {
            return
        }
        
        layer.emitterCells = [cell]
        let d = dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(duration * Float(NSEC_PER_SEC))
        )
        dispatch_after(d, dispatch_get_main_queue()) {
            self.layer.birthRate = 0.0
        }
    }
    
    public func stop() {
        if nil != layer.superlayer {
            layer.removeFromSuperlayer()
        }
    }
    
    func update(configureClosure: LTEmitterConfigureClosure? = .None) -> LTEmitter {
        configureClosure?(layer, cell)
        return self
    }
    
}


public typealias LTEmitterConfigureClosure = (CAEmitterLayer, CAEmitterCell) -> Void


public class LTEmitterView: UIView {
    
    public lazy var emitters: Dictionary<String, LTEmitter> = {
        var _emitters = Dictionary<String, LTEmitter>()
        return _emitters
        }()
    
    public func createEmitter(
        name: String,
        particleName: String,
        duration: Float,
        configureClosure: LTEmitterConfigureClosure?
        ) -> LTEmitter {

            var emitter: LTEmitter
            if let e = emitterByName(name) {
                emitter = e
            } else {
                emitter = LTEmitter(
                    name: name,
                    particleName: particleName,
                    duration: duration
                )

                configureClosure?(emitter.layer, emitter.cell)

                layer.addSublayer(emitter.layer)
                emitters.updateValue(emitter, forKey: name)
            }
            return emitter
    }
    
    public func emitterByName(name: String) -> LTEmitter? {
        if let e = emitters[name] {
            return e
        }
        return Optional.None
    }
    
    public func removeAllEmitters() {
        for (_, emitter) in emitters {
            emitter.layer.removeFromSuperlayer()
        }
        emitters.removeAll(keepCapacity: false)
    }
    
}
