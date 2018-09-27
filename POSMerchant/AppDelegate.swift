//
//  AppDelegate.swift
//  POSMerchant
//
//  Created by Mederic Petit on 25/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        _ = POSMerchantManager.shared
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.black
        self.window?.makeKeyAndVisible()
        self.loadRootView()
        SessionManager.shared.attachObserver(observer: self)
        return true
    }

    func loadRootView() {
        switch SessionManager.shared.state {
        case .loggedOut?:
            self.window?.rootViewController = Storyboard.signin.storyboard.instantiateInitialViewController()
        case .loading?:
            self.window?.rootViewController = Storyboard.loading.storyboard.instantiateInitialViewController()
        case .welcome?:
            self.window?.rootViewController = Storyboard.welcome.storyboard.instantiateInitialViewController()
        case .loggedIn?:
            self.window?.rootViewController = Storyboard.tabBar.storyboard.instantiateInitialViewController()
        default: break
        }
    }
}

extension AppDelegate: Observer {
    func id() -> Int {
        return 0
    }

    func onChange(event: AppEvent) {
        switch event {
        case .onAppStateUpdate:
            self.loadRootView()
        default: break
        }
    }
}
