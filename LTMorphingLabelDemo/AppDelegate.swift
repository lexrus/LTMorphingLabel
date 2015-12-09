//
//  AppDelegate.swift
//  LTMorphingLabelDemo
//
//  Created by Lex on 6/18/14.
//  Copyright (c) 2015 lexrus.com. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    
    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?
        ) -> Bool {
            window!.backgroundColor = UIColor.blackColor()
            window!.makeKeyAndVisible()
            return true
    }

}
