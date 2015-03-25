//
//  LTEmitterView.swift
//  LTMorphingLabelDemo
//
//  Created by Lex on 3/15/15.
//  Copyright (c) 2015 LexTang.com. All rights reserved.
//

import UIKit


public struct LTEmitter {
    
    let layer: CAEmitterLayer = {
        let _layer = CAEmitterLayer()
        _layer.emitterPosition = CGPointMake(10, 10)
        _layer.emitterSize = CGSizeMake(10, 1)
        _layer.renderMode = kCAEmitterLayerOutline
        _layer.emitterShape = kCAEmitterLayerLine
        return _layer
        }()
    
    let cell: CAEmitterCell = {
        let image = UIImage(named:"Sparkle")!.CGImage
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
    
    public var _duration: Float = 0.6
    
    init(name: String, duration: Float) {
        cell.name = name
        _duration = duration
    }
    
    public func play() {
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
    
    public func stop() {
        if (nil != layer.superlayer) {
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


public typealias LTEmitterConfigureClosure = (CAEmitterLayer, CAEmitterCell) -> Void


public class LTEmitterView: UIView {
    
    public lazy var emitters: Dictionary<String, LTEmitter> = {
        var _emitters = Dictionary<String, LTEmitter>()
        return _emitters
        }()
    
    public func createEmitter(name: String, duration: Float, configureClosure: LTEmitterConfigureClosure? = Optional.None) -> LTEmitter {
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
    
    public func emitterByName(name: String) -> LTEmitter? {
        if let e = emitters[name] {
            return e
        }
        return Optional.None
    }
    
    public func removeAllEmit() {
        for (name, emitter) in emitters {
            emitter.layer.removeFromSuperlayer()
        }
        emitters.removeAll(keepCapacity: false)
    }
    
}