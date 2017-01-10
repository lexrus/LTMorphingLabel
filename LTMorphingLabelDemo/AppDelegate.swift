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
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
        ) -> Bool {
            window!.backgroundColor = UIColor.black
            window!.makeKeyAndVisible()
            return true
    }

}
