//
//  LTEmitterView.swift
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


struct LTEmitter {

    let layer: CAEmitterLayer = {
        let _layer = CAEmitterLayer()
        _layer.emitterPosition = CGPointMake(10, 10)
        _layer.emitterSize = CGSizeMake(10, 1)
        _layer.renderMode = kCAEmitterLayerOutline
        _layer.emitterShape = kCAEmitterLayerLine
        return _layer
        }()
    
    let cell: CAEmitterCell = {
        let image = UIImage(named:"Sparkle").CGImage
        let _cell = CAEmitterCell()
        _cell.name = "sparkle"
        _cell.birthRate = 150.0
        _cell.velocity = 50.0
        _cell.velocityRange = -80.0
        _cell.lifetime = 0.16
        _cell.lifetimeRange = 0.1
        _cell.emissionLongitude = CGFloat(M_PI_2 * 2.0)
        _cell.emissionRange = CGFloat(M_PI_2 * 2.0)
        _cell.contents = image
        _cell.scale = 0.1
        _cell.yAcceleration = 100
        _cell.scaleSpeed = -0.06
        _cell.scaleRange = 0.1
        return _cell
        }()
    
    var _duration: Float = 0.6
    
    init(name: String, duration: Float) {
        cell.name = name
        _duration = duration
    }
    
    func play() {
        if let cells = layer.emitterCells {
            if cells.count > 0 {
                return
            }
        }
        
        layer.emitterCells = [cell]
        let d: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(_duration * Float(NSEC_PER_SEC)))
        dispatch_after(d, dispatch_get_main_queue()) {
            self.layer.birthRate = 0.0
        }
    }
    
    func stop() {
        if layer.superlayer {
            layer.removeFromSuperlayer()
        }
    }
    
    func update(configureClosure: LTEmitterConfigureClosure? = Optional.None) -> LTEmitter {
        if let closure = configureClosure {
            configureClosure!(self.layer, self.cell)
        }
        return self
    }

}


typealias LTEmitterConfigureClosure = (CAEmitterLayer, CAEmitterCell) -> Void


class LTEmitterView: UIView {
    
    lazy var emitters: Dictionary<String, LTEmitter> = {
        var _emitters = Dictionary<String, LTEmitter>()
        return _emitters
        }()
    
    func createEmitter(name: String, duration: Float, configureClosure: LTEmitterConfigureClosure? = Optional.None) -> LTEmitter {
        var emitter: LTEmitter
        if let e = emitterByName(name) {
            emitter = e
        } else {
            emitter = LTEmitter(name: name, duration: duration)
            
            if let closure = configureClosure {
                configureClosure!(emitter.layer, emitter.cell)
            }
            
            layer.addSublayer(emitter.layer)
            emitters.updateValue(emitter, forKey: name)
        }
        return emitter
    }
    
    func emitterByName(name: String) -> LTEmitter? {
        if let e = emitters[name] {
            return e
        }
        return Optional.None
    }
    
    func removeAllEmit() {
        for (name, emitter) in emitters {
            emitter.layer.removeFromSuperlayer()
        }
        emitters.removeAll(keepCapacity: false)
    }
    
}
