//
//  AppDelegate.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 26/03/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var mapBuilder: MapBuilding!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window =  UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        if let mapBuilder = Container.shared.resolve(MapBuilding.self), let window = self.window {
            window.rootViewController = mapBuilder.buildMapModule()?.viewController
        }
        return true
    }
}

