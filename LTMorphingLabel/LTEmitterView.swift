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
        let layer = CAEmitterLayer()
        layer.emitterPosition = CGPointMake(10, 10)
        layer.emitterSize = CGSizeMake(10, 1)
        layer.renderMode = kCAEmitterLayerOutline
        layer.emitterShape = kCAEmitterLayerLine
        return layer
        }()
    
    let cell: CAEmitterCell = {
        let image = UIImage(named:"Sparkle")!.CGImage
        let cell = CAEmitterCell()
        cell.name = "sparkle"
        cell.birthRate = 150.0
        cell.velocity = 50.0
        cell.velocityRange = -80.0
        cell.lifetime = 0.16
        cell.lifetimeRange = 0.1
        cell.emissionLongitude = CGFloat(M_PI_2 * 2.0)
        cell.emissionRange = CGFloat(M_PI_2 * 2.0)
        cell.contents = image
        cell.scale = 0.1
        cell.yAcceleration = 100
        cell.scaleSpeed = -0.06
        cell.scaleRange = 0.1
        return cell
        }()
    
    public var duration: Float = 0.6
    
    init(name: String, duration: Float) {
        self.cell.name = name
        self.duration = duration
    }
    
    public func play() {
        if let cells = layer.emitterCells {
            if cells.count > 0 {
                return
            }
        }
        
        layer.emitterCells = [cell]
        let d: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(duration * Float(NSEC_PER_SEC)))
        dispatch_after(d, dispatch_get_main_queue()) {
            self.layer.birthRate = 0.0
        }
    }
    
    public func stop() {
        if (nil != layer.superlayer) {
            layer.removeFromSuperlayer()
        }
    }
    
    func update(configureClosure: LTEmitterConfigureClosure? = .None) -> LTEmitter {
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